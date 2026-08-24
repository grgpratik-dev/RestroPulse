-- =========================================================
-- Order Functions
--
-- Controlled order creation so an order and all of its
-- order_items are created atomically.
--
-- The client provides:
--   - channel
--   - menu item IDs
--   - quantities
--   - optional discount
--   - optional notes
--   - optional order time
--
-- Prices, costs, names, subtotal, and total are calculated
-- from trusted database values rather than client input.
-- =========================================================


-- =========================================================
-- Create Order
--
-- Example p_items:
--
-- [
--   {
--     "menu_item_id": "uuid",
--     "quantity": 2
--   },
--   {
--     "menu_item_id": "uuid",
--     "quantity": 1
--   }
-- ]
--
-- Rules:
--   - Caller must be authenticated.
--   - Caller must be the restaurant owner.
--   - At least one item is required.
--   - Every quantity must be greater than zero.
--   - Every menu item must belong to the owner's restaurant.
--   - Only active and available menu items can be sold.
--   - Duplicate menu_item_id entries are rejected.
--   - Selling price / cost / item name come from menu_items.
--   - Discount cannot exceed subtotal.
--   - Order + order_items are committed together.
-- =========================================================

create or replace function public.create_order(
  p_channel public.order_channel,
  p_items jsonb,
  p_discount_amount numeric default 0,
  p_notes text default null,
  p_ordered_at timestamptz default now()
)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id uuid;
  v_restaurant_id uuid;
  v_order_id uuid;

  v_subtotal numeric(12,2);
  v_total_amount numeric(12,2);

  v_requested_item_count integer;
  v_valid_item_count integer;
begin

  -- =======================================================
  -- Authentication
  -- =======================================================

  v_user_id := auth.uid();

  if v_user_id is null then
    raise exception 'Authentication required';
  end if;


  -- =======================================================
  -- Find the restaurant owned by the current user.
  --
  -- Viewers are intentionally not allowed to create orders.
  -- =======================================================

  select rm.restaurant_id
  into v_restaurant_id
  from public.restaurant_memberships rm
  where rm.profile_id = v_user_id
    and rm.role = 'owner';

  if not found then
    raise exception 'Only a restaurant owner can create orders';
  end if;


  -- =======================================================
  -- Validate items payload.
  -- =======================================================

  if p_items is null
     or jsonb_typeof(p_items) <> 'array'
     or jsonb_array_length(p_items) = 0 then

    raise exception 'Order must contain at least one item';

  end if;


  -- Number of lines supplied by the client.
  v_requested_item_count := jsonb_array_length(p_items);


  -- =======================================================
  -- Validate quantities.
  -- =======================================================

  if exists (
    select 1
    from jsonb_array_elements(p_items) item
    where
      not (item ? 'menu_item_id')
      or not (item ? 'quantity')
      or (item ->> 'quantity')::integer <= 0
  ) then
    raise exception 'Every order item must have a valid menu item and positive quantity';
  end if;


  -- =======================================================
  -- Reject duplicate menu items.
  --
  -- Flutter should increase quantity instead of sending
  -- the same menu item as multiple separate lines.
  -- =======================================================

  if (
    select count(*)
    from (
      select item ->> 'menu_item_id'
      from jsonb_array_elements(p_items) item
      group by item ->> 'menu_item_id'
      having count(*) > 1
    ) duplicates
  ) > 0 then
    raise exception 'Duplicate menu items are not allowed';
  end if;


  -- =======================================================
  -- Verify that every requested menu item:
  --   - exists
  --   - belongs to this restaurant
  --   - is active
  --   - is currently available
  -- =======================================================

  select count(*)
  into v_valid_item_count
  from jsonb_array_elements(p_items) item
  join public.menu_items mi
    on mi.id = (item ->> 'menu_item_id')::uuid
  where mi.restaurant_id = v_restaurant_id
    and mi.is_active = true
    and mi.is_available = true;


  if v_valid_item_count <> v_requested_item_count then
    raise exception 'One or more menu items are invalid or unavailable';
  end if;


  -- =======================================================
  -- Calculate subtotal using DATABASE prices.
  --
  -- The client never decides the selling price.
  -- =======================================================

  select
    coalesce(
      sum(
        mi.selling_price
        * (item ->> 'quantity')::integer
      ),
      0
    )
  into v_subtotal
  from jsonb_array_elements(p_items) item
  join public.menu_items mi
    on mi.id = (item ->> 'menu_item_id')::uuid
  where mi.restaurant_id = v_restaurant_id;


  -- =======================================================
  -- Validate discount.
  -- =======================================================

  if p_discount_amount is null then
    p_discount_amount := 0;
  end if;


  if p_discount_amount < 0 then
    raise exception 'Discount cannot be negative';
  end if;


  if p_discount_amount > v_subtotal then
    raise exception 'Discount cannot exceed order subtotal';
  end if;


  v_total_amount := v_subtotal - p_discount_amount;


  -- =======================================================
  -- Create the parent order.
  -- =======================================================

  insert into public.orders (
    restaurant_id,
    recorded_by_profile_id,
    channel,
    subtotal,
    discount_amount,
    total_amount,
    notes,
    ordered_at
  )
  values (
    v_restaurant_id,
    v_user_id,
    p_channel,
    v_subtotal,
    p_discount_amount,
    v_total_amount,
    p_notes,
    coalesce(p_ordered_at, now())
  )
  returning id into v_order_id;


  -- =======================================================
  -- Create order item snapshots.
  --
  -- We deliberately copy the current:
  --   - item name
  --   - selling price
  --   - cost price
  --
  -- Future menu edits therefore do not change historical
  -- order/reporting data.
  -- =======================================================

  insert into public.order_items (
    order_id,
    menu_item_id,
    item_name,
    quantity,
    unit_price,
    unit_cost,
    line_total
  )
  select
    v_order_id,
    mi.id,
    mi.name,
    (item ->> 'quantity')::integer,
    mi.selling_price,
    mi.cost_price,
    mi.selling_price * (item ->> 'quantity')::integer
  from jsonb_array_elements(p_items) item
  join public.menu_items mi
    on mi.id = (item ->> 'menu_item_id')::uuid
  where mi.restaurant_id = v_restaurant_id;


  -- Return the newly created order ID to Flutter.
  return v_order_id;

end;
$$;


-- =========================================================
-- Function Permissions
-- =========================================================

revoke all
on function public.create_order(
  public.order_channel,
  jsonb,
  numeric,
  text,
  timestamptz
)
from public;


grant execute
on function public.create_order(
  public.order_channel,
  jsonb,
  numeric,
  text,
  timestamptz
)
to authenticated;



-- =========================================================
-- Create Orders Batch
--
-- Creates multiple normal orders in one RPC call.
--
-- Batch entry is only a faster input workflow.
-- Each entry still becomes its own orders row with its
-- own order_items.
--
-- If any order in the batch fails, the entire batch
-- transaction is rolled back.
-- =========================================================

create or replace function public.create_orders_batch(
  p_orders jsonb
)
returns uuid[]
language plpgsql
security invoker
set search_path = public
as $$
declare
  v_order jsonb;
  v_order_id uuid;
  v_order_ids uuid[] := array[]::uuid[];
begin
  -- Batch payload must be a non-empty JSON array.
  if p_orders is null
     or jsonb_typeof(p_orders) <> 'array'
     or jsonb_array_length(p_orders) = 0 then
    raise exception 'Batch must contain at least one order';
  end if;


  -- Process each order individually using the already
  -- validated create_order() function.
  for v_order in
    select value
    from jsonb_array_elements(p_orders)
  loop

    -- Every batch entry needs a channel.
    if not (v_order ? 'channel') then
      raise exception 'Every order must include a channel';
    end if;


    -- Every batch entry needs an items array.
    if not (v_order ? 'items') then
      raise exception 'Every order must include items';
    end if;


    v_order_id := public.create_order(
      p_channel :=
        (v_order ->> 'channel')::public.order_channel,

      p_items :=
        v_order -> 'items',

      p_discount_amount :=
        coalesce(
          (v_order ->> 'discount_amount')::numeric,
          0
        ),

      p_notes :=
        v_order ->> 'notes',

      p_ordered_at :=
        coalesce(
          (v_order ->> 'ordered_at')::timestamptz,
          now()
        )
    );


    -- Collect each newly created order ID.
    v_order_ids := array_append(
      v_order_ids,
      v_order_id
    );

  end loop;


  return v_order_ids;
end;
$$;


-- =========================================================
-- Function Permissions
-- =========================================================

revoke all
on function public.create_orders_batch(jsonb)
from public;

grant execute
on function public.create_orders_batch(jsonb)
to authenticated;