-- =========================================================
-- Sales Read Functions
--
-- Read-only functions used by the Sales screen.
--
-- This function returns restaurant orders for a selected
-- date range and optional sales channel.
--
-- Both owners and viewers can use it.
-- =========================================================


-- =========================================================
-- Get Orders
--
-- Returns order history for the current user's restaurant.
--
-- Includes:
--   - order UUID
--   - human-readable order number
--   - channel
--   - subtotal
--   - discount
--   - total
--   - estimated food cost
--   - order date/time
--   - notes
--
-- Estimated food cost is calculated from the historical
-- unit_cost snapshots stored in order_items.
--
-- p_channel is optional:
--   null -> all channels
--   value -> only that channel
-- =========================================================

create or replace function public.get_orders(
  p_start_at timestamptz,
  p_end_at timestamptz,
  p_channel public.order_channel default null
)
returns table (
  id uuid,
  order_number bigint,
  channel public.order_channel,
  subtotal numeric(12,2),
  discount_amount numeric(12,2),
  total_amount numeric(12,2),
  estimated_food_cost numeric,
  notes text,
  ordered_at timestamptz
)
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_user_id uuid;
  v_restaurant_id uuid;

begin

  -- =======================================================
  -- Authentication
  -- =======================================================

  v_user_id := auth.uid();

  if v_user_id is null then
    raise exception 'Authentication required';
  end if;


  -- =======================================================
  -- Determine current user's restaurant.
  --
  -- Both owner and viewer memberships are valid for reads.
  -- =======================================================

  select rm.restaurant_id
  into v_restaurant_id
  from public.restaurant_memberships rm
  where rm.profile_id = v_user_id;

  if not found then
    raise exception 'User does not belong to a restaurant';
  end if;


  -- =======================================================
  -- Validate date range.
  -- =======================================================

  if p_start_at is null or p_end_at is null then
    raise exception 'Start and end date are required';
  end if;

  if p_start_at >= p_end_at then
    raise exception 'Start date must be before end date';
  end if;


  -- =======================================================
  -- Return matching orders.
  --
  -- Food cost:
  --   quantity × historical unit_cost
  --
  -- If an old order item had no cost recorded,
  -- its contribution is treated as 0.
  -- =======================================================

  return query

  select
    o.id,
    o.order_number,
    o.channel,
    o.subtotal,
    o.discount_amount,
    o.total_amount,

    coalesce(
      sum(
        oi.quantity
        * coalesce(oi.unit_cost, 0)
      ),
      0
    ) as estimated_food_cost,

    o.notes,
    o.ordered_at

  from public.orders o

  left join public.order_items oi
    on oi.order_id = o.id

  where o.restaurant_id = v_restaurant_id

    -- Inclusive start, exclusive end.
    --
    -- Example:
    -- start = 2026-08-01 00:00
    -- end   = 2026-09-01 00:00
    --
    -- gives the full month of August.
    and o.ordered_at >= p_start_at
    and o.ordered_at < p_end_at

    and (
      p_channel is null
      or o.channel = p_channel
    )

  group by
    o.id,
    o.order_number,
    o.channel,
    o.subtotal,
    o.discount_amount,
    o.total_amount,
    o.notes,
    o.ordered_at

  order by
    o.ordered_at desc,
    o.order_number desc;

end;
$$;


-- =========================================================
-- Permissions
-- =========================================================

revoke all
on function public.get_orders(
  timestamptz,
  timestamptz,
  public.order_channel
)
from public;


grant execute
on function public.get_orders(
  timestamptz,
  timestamptz,
  public.order_channel
)
to authenticated;