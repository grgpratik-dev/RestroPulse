-- =========================================================
-- Menu Analytics Read Functions
--
-- Contains ONLY calculated / aggregated Menu analytics.
--
-- Normal menu CRUD and category reads should use
-- standard Supabase queries + RLS.
-- =========================================================


-- =========================================================
-- 1. Get Menu Performance Summary
--
-- Reusable for selected periods:
--   1M / 3M / 6M / 1Y
--
-- Best Seller:
--   highest units sold
--
-- Most Profitable:
--   highest margin percentage
--
-- IMPORTANT:
--   "Most profitable" here means highest margin %, exactly
--   as defined by the product.
-- =========================================================

create or replace function public.get_menu_performance_summary(
  p_start_at timestamptz,
  p_end_at timestamptz
)
returns table (
  best_seller_item_id uuid,
  best_seller_item_name varchar,
  best_seller_units_sold numeric,

  most_profitable_item_id uuid,
  most_profitable_item_name varchar,
  most_profitable_margin_percent numeric
)
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_user_id uuid;
  v_restaurant_id uuid;

  v_best_seller_item_id uuid;
  v_best_seller_item_name varchar;
  v_best_seller_units numeric := 0;

  v_profitable_item_id uuid;
  v_profitable_item_name varchar;
  v_profitable_margin numeric;

begin

  -- Authentication
  v_user_id := auth.uid();

  if v_user_id is null then
    raise exception 'Authentication required';
  end if;


  -- Resolve restaurant
  select rm.restaurant_id
  into v_restaurant_id
  from public.restaurant_memberships rm
  where rm.profile_id = v_user_id;

  if not found then
    raise exception 'User does not belong to a restaurant';
  end if;


  -- Validate period
  if p_start_at is null or p_end_at is null then
    raise exception 'Menu period boundaries are required';
  end if;

  if p_start_at >= p_end_at then
    raise exception 'Start must be before end';
  end if;


  -- =======================================================
  -- Best seller by units sold
  -- =======================================================

  select
    mi.id,
    mi.name,
    sum(oi.quantity)

  into
    v_best_seller_item_id,
    v_best_seller_item_name,
    v_best_seller_units

  from public.order_items oi

  join public.orders o
    on o.id = oi.order_id

  join public.menu_items mi
    on mi.id = oi.menu_item_id

  where o.restaurant_id = v_restaurant_id
    and o.ordered_at >= p_start_at
    and o.ordered_at < p_end_at
    and mi.is_active = true

  group by
    mi.id,
    mi.name

  order by
    sum(oi.quantity) desc,
    mi.name asc

  limit 1;


  if not found then
    v_best_seller_item_id := null;
    v_best_seller_item_name := null;
    v_best_seller_units := 0;
  end if;


  -- =======================================================
  -- Most profitable by margin %
  --
  -- We exclude any item whose sold rows contain missing
  -- historical unit-cost snapshots.
  --
  -- This avoids falsely inflating margin by treating
  -- unknown cost as zero.
  -- =======================================================

  select
    mi.id,
    mi.name,

    round(
      (
        (
          sum(oi.line_total)
          - sum(oi.quantity * oi.unit_cost)
        )
        / nullif(sum(oi.line_total), 0)
      ) * 100,
      1
    )

  into
    v_profitable_item_id,
    v_profitable_item_name,
    v_profitable_margin

  from public.order_items oi

  join public.orders o
    on o.id = oi.order_id

  join public.menu_items mi
    on mi.id = oi.menu_item_id

  where o.restaurant_id = v_restaurant_id
    and o.ordered_at >= p_start_at
    and o.ordered_at < p_end_at
    and mi.is_active = true

  group by
    mi.id,
    mi.name

  having
    count(*) = count(oi.unit_cost)
    and sum(oi.line_total) > 0

  order by
    (
      (
        sum(oi.line_total)
        - sum(oi.quantity * oi.unit_cost)
      )
      / nullif(sum(oi.line_total), 0)
    ) desc,
    mi.name asc

  limit 1;


  if not found then
    v_profitable_item_id := null;
    v_profitable_item_name := null;
    v_profitable_margin := null;
  end if;


  return query
  select
    v_best_seller_item_id,
    v_best_seller_item_name,
    v_best_seller_units,
    v_profitable_item_id,
    v_profitable_item_name,
    v_profitable_margin;

end;
$$;


revoke all
on function public.get_menu_performance_summary(
  timestamptz,
  timestamptz
)
from public;

grant execute
on function public.get_menu_performance_summary(
  timestamptz,
  timestamptz
)
to authenticated;



-- =========================================================
-- 2. Get Menu Items Performance
--
-- Powers the Menu Performance item list.
--
-- Optional:
--   p_category_id
--
-- Returns current pricing info plus selected-period
-- performance analytics for every active menu item.
-- =========================================================

create or replace function public.get_menu_items_performance(
  p_start_at timestamptz,
  p_end_at timestamptz,
  p_category_id uuid default null
)
returns table (
  item_id uuid,
  item_name varchar,
  image_path varchar,

  category_id uuid,
  category_name varchar,

  selling_price numeric,
  food_cost_percent numeric,

  units_sold numeric,
  revenue numeric,

  status text
)
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_user_id uuid;
  v_restaurant_id uuid;
  v_average_units numeric := 0;

begin

  -- Authentication
  v_user_id := auth.uid();

  if v_user_id is null then
    raise exception 'Authentication required';
  end if;


  -- Resolve restaurant
  select rm.restaurant_id
  into v_restaurant_id
  from public.restaurant_memberships rm
  where rm.profile_id = v_user_id;

  if not found then
    raise exception 'User does not belong to a restaurant';
  end if;


  -- Validate period
  if p_start_at is null or p_end_at is null then
    raise exception 'Menu period boundaries are required';
  end if;

  if p_start_at >= p_end_at then
    raise exception 'Start must be before end';
  end if;


  -- Validate optional category belongs to restaurant.
  if p_category_id is not null
     and not exists (
       select 1
       from public.menu_categories mc
       where mc.id = p_category_id
         and mc.restaurant_id = v_restaurant_id
         and mc.is_active = true
     ) then

    raise exception 'Menu category not found';

  end if;


  -- =======================================================
  -- Average units among SOLD active items.
  --
  -- Used only for a lightweight status signal.
  -- =======================================================

  select
    coalesce(avg(item_units), 0)

  into v_average_units

  from (
    select
      mi.id,
      sum(oi.quantity) as item_units

    from public.menu_items mi

    join public.order_items oi
      on oi.menu_item_id = mi.id

    join public.orders o
      on o.id = oi.order_id

    where mi.restaurant_id = v_restaurant_id
      and mi.is_active = true
      and o.ordered_at >= p_start_at
      and o.ordered_at < p_end_at

    group by mi.id
  ) sold_items;


  -- =======================================================
  -- Return active menu items, including zero-sale items.
  -- =======================================================

  return query

  with performance as (
    select
      mi.id as item_id,
      coalesce(sum(oi.quantity), 0) as units_sold,
      coalesce(sum(oi.line_total), 0) as revenue

    from public.menu_items mi

    left join public.order_items oi
      on oi.menu_item_id = mi.id

    left join public.orders o
      on o.id = oi.order_id
      and o.restaurant_id = v_restaurant_id
      and o.ordered_at >= p_start_at
      and o.ordered_at < p_end_at

    where mi.restaurant_id = v_restaurant_id
      and mi.is_active = true

    group by mi.id
  )

  select
    mi.id,
    mi.name,
    mi.image_path,

    mc.id,
    mc.name,

    round(mi.selling_price, 2),

    case
      when mi.cost_price is null
        or mi.selling_price = 0
      then null

      else round(
        (mi.cost_price / mi.selling_price) * 100,
        1
      )
    end,

    p.units_sold,
    round(p.revenue, 2),

    case

      when mi.cost_price is not null
           and mi.selling_price > 0
           and (
             mi.cost_price
             / mi.selling_price
           ) * 100 >= 40
      then 'review_cost'

      when p.units_sold > 0
           and v_average_units > 0
           and p.units_sold >= v_average_units
      then 'high_demand'

      when mi.cost_price is not null
           and mi.selling_price > 0
           and (
             mi.cost_price
             / mi.selling_price
           ) * 100 <= 30
      then 'healthy_margin'

      else null

    end as status

  from public.menu_items mi

  left join public.menu_categories mc
    on mc.id = mi.category_id

  join performance p
    on p.item_id = mi.id

  where mi.restaurant_id = v_restaurant_id
    and mi.is_active = true
    and (
      p_category_id is null
      or mi.category_id = p_category_id
    )

  order by
    p.units_sold desc,
    p.revenue desc,
    mi.name asc;

end;
$$;


revoke all
on function public.get_menu_items_performance(
  timestamptz,
  timestamptz,
  uuid
)
from public;

grant execute
on function public.get_menu_items_performance(
  timestamptz,
  timestamptz,
  uuid
)
to authenticated;



-- =========================================================
-- 3. Get Menu Item Performance Detail
--
-- Powers Menu Item Detail analytics.
--
-- Returns:
--
-- Current pricing
--   selling price
--   estimated cost per unit
--   food cost %
--   contribution per unit
--
-- Selected-period performance
--   units sold
--   revenue
--   estimated total cost
--   total contribution
--   orders containing item
--
-- Previous-period comparison
--   previous units sold
--   units sold change %
--
-- Historical cost totals become NULL if any sold row in
-- the selected period is missing its unit_cost snapshot.
-- =========================================================

create or replace function public.get_menu_item_performance_detail(
  p_item_id uuid,
  p_start_at timestamptz,
  p_end_at timestamptz,
  p_previous_start_at timestamptz
)
returns table (
  item_id uuid,
  item_name varchar,
  image_path varchar,

  category_id uuid,
  category_name varchar,

  selling_price numeric,
  estimated_cost numeric,
  food_cost_percent numeric,
  contribution_per_unit numeric,

  units_sold numeric,
  revenue numeric,
  estimated_total_cost numeric,
  total_contribution numeric,
  orders_containing_item bigint,

  previous_units_sold numeric,
  units_sold_change_percent numeric,

  status text
)
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_user_id uuid;
  v_restaurant_id uuid;

  v_item_name varchar;
  v_image_path varchar;

  v_category_id uuid;
  v_category_name varchar;

  v_selling_price numeric;
  v_cost_price numeric;

  v_units_sold numeric := 0;
  v_revenue numeric := 0;
  v_total_cost numeric;
  v_total_contribution numeric;
  v_orders_containing bigint := 0;

  v_previous_units numeric := 0;
  v_units_change numeric;

  v_cost_rows bigint := 0;
  v_total_rows bigint := 0;

  v_average_units numeric := 0;
  v_status text;

begin

  -- Authentication
  v_user_id := auth.uid();

  if v_user_id is null then
    raise exception 'Authentication required';
  end if;


  -- Resolve restaurant
  select rm.restaurant_id
  into v_restaurant_id
  from public.restaurant_memberships rm
  where rm.profile_id = v_user_id;

  if not found then
    raise exception 'User does not belong to a restaurant';
  end if;


  -- Validate inputs
  if p_item_id is null then
    raise exception 'Menu item ID is required';
  end if;

  if p_start_at is null
     or p_end_at is null
     or p_previous_start_at is null then

    raise exception 'Menu period boundaries are required';

  end if;

  if p_start_at >= p_end_at then
    raise exception 'Start must be before end';
  end if;

  if p_previous_start_at >= p_start_at then
    raise exception 'Previous period must begin before current period';
  end if;


  -- =======================================================
  -- Current item identity / pricing
  -- =======================================================

  select
    mi.name,
    mi.image_path,
    mc.id,
    mc.name,
    mi.selling_price,
    mi.cost_price

  into
    v_item_name,
    v_image_path,
    v_category_id,
    v_category_name,
    v_selling_price,
    v_cost_price

  from public.menu_items mi

  left join public.menu_categories mc
    on mc.id = mi.category_id

  where mi.id = p_item_id
    and mi.restaurant_id = v_restaurant_id
    and mi.is_active = true;


  if not found then
    raise exception 'Menu item not found';
  end if;


  -- =======================================================
  -- Current-period historical performance
  -- =======================================================

  select
    coalesce(sum(oi.quantity), 0),
    coalesce(sum(oi.line_total), 0),

    count(*),
    count(oi.unit_cost),

    count(distinct o.id)

  into
    v_units_sold,
    v_revenue,
    v_total_rows,
    v_cost_rows,
    v_orders_containing

  from public.order_items oi

  join public.orders o
    on o.id = oi.order_id

  where oi.menu_item_id = p_item_id
    and o.restaurant_id = v_restaurant_id
    and o.ordered_at >= p_start_at
    and o.ordered_at < p_end_at;


  -- Only calculate historical cost/contribution when every
  -- sold row has a cost snapshot.
  if v_total_rows = 0 then

    v_total_cost := 0;
    v_total_contribution := 0;

  elsif v_total_rows = v_cost_rows then

    select
      coalesce(sum(oi.quantity * oi.unit_cost), 0)

    into v_total_cost

    from public.order_items oi

    join public.orders o
      on o.id = oi.order_id

    where oi.menu_item_id = p_item_id
      and o.restaurant_id = v_restaurant_id
      and o.ordered_at >= p_start_at
      and o.ordered_at < p_end_at;


    v_total_contribution :=
      v_revenue - v_total_cost;

  else

    -- Unknown cost history should remain unknown rather
    -- than being treated as zero.
    v_total_cost := null;
    v_total_contribution := null;

  end if;


  -- =======================================================
  -- Previous-period units
  -- =======================================================

  select
    coalesce(sum(oi.quantity), 0)

  into v_previous_units

  from public.order_items oi

  join public.orders o
    on o.id = oi.order_id

  where oi.menu_item_id = p_item_id
    and o.restaurant_id = v_restaurant_id
    and o.ordered_at >= p_previous_start_at
    and o.ordered_at < p_start_at;


  if v_previous_units = 0 then

    v_units_change := null;

  else

    v_units_change :=
      round(
        (
          (v_units_sold - v_previous_units)
          / v_previous_units
        ) * 100,
        1
      );

  end if;


  -- =======================================================
  -- Average units among sold items for status signal
  -- =======================================================

  select
    coalesce(avg(item_units), 0)

  into v_average_units

  from (
    select
      oi.menu_item_id,
      sum(oi.quantity) as item_units

    from public.order_items oi

    join public.orders o
      on o.id = oi.order_id

    where o.restaurant_id = v_restaurant_id
      and o.ordered_at >= p_start_at
      and o.ordered_at < p_end_at
      and oi.menu_item_id is not null

    group by oi.menu_item_id
  ) item_sales;


  -- =======================================================
  -- Status
  -- =======================================================

  if v_cost_price is not null
     and v_selling_price > 0
     and (
       v_cost_price / v_selling_price
     ) * 100 >= 40 then

    v_status := 'review_cost';

  elsif v_units_sold > 0
        and v_average_units > 0
        and v_units_sold >= v_average_units then

    v_status := 'high_demand';

  elsif v_cost_price is not null
        and v_selling_price > 0
        and (
          v_cost_price / v_selling_price
        ) * 100 <= 30 then

    v_status := 'healthy_margin';

  elsif v_units_sold = 0 then

    v_status := 'low_demand';

  else

    v_status := null;

  end if;


  -- =======================================================
  -- Return detail
  -- =======================================================

  return query
  select
    p_item_id,
    v_item_name,
    v_image_path,

    v_category_id,
    v_category_name,

    round(v_selling_price, 2),

    case
      when v_cost_price is null
      then null
      else round(v_cost_price, 2)
    end,

    case
      when v_cost_price is null
        or v_selling_price = 0
      then null

      else round(
        (v_cost_price / v_selling_price) * 100,
        1
      )
    end,

    case
      when v_cost_price is null
      then null
      else round(
        v_selling_price - v_cost_price,
        2
      )
    end,

    v_units_sold,
    round(v_revenue, 2),

    case
      when v_total_cost is null
      then null
      else round(v_total_cost, 2)
    end,

    case
      when v_total_contribution is null
      then null
      else round(v_total_contribution, 2)
    end,

    v_orders_containing,

    v_previous_units,
    v_units_change,

    v_status;

end;
$$;


revoke all
on function public.get_menu_item_performance_detail(
  uuid,
  timestamptz,
  timestamptz,
  timestamptz
)
from public;

grant execute
on function public.get_menu_item_performance_detail(
  uuid,
  timestamptz,
  timestamptz,
  timestamptz
)
to authenticated;