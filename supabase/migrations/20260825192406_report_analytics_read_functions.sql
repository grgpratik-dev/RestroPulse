-- =========================================================
-- Report Analytics Read Functions
--
-- Contains ONLY aggregated / calculated report analytics.
--
-- Raw rows, detail screens, and normal CRUD should use
-- standard Supabase queries + RLS.
-- =========================================================


-- =========================================================
-- 1. Get Report Overview
--
-- Reusable for:
--   1M / 3M / 6M / 1Y
--
-- Current period:
--   [p_start_at, p_end_at)
--
-- Previous period:
--   [p_previous_start_at, p_start_at)
--
-- Returns the metrics required by:
--   Performance Overview
--   Financial Breakdown
--
-- IMPORTANT:
-- Historical food-cost calculations are considered valid
-- only when every sold order-item row has a unit_cost
-- snapshot.
-- =========================================================

create or replace function public.get_report_overview(
  p_start_at timestamptz,
  p_end_at timestamptz,
  p_previous_start_at timestamptz
)
returns table (
  revenue numeric,
  revenue_change_percent numeric,

  operating_expenses numeric,
  expenses_change_percent numeric,

  estimated_food_cost numeric,
  food_cost_percent numeric,
  cost_data_complete boolean,

  gross_profit numeric,

  wastage_loss numeric,
  wastage_change_percent numeric,

  estimated_net_profit numeric,
  profit_change_percent numeric,
  profit_margin_percent numeric,

  total_orders bigint,
  orders_change_percent numeric,

  average_order numeric,
  average_order_change_percent numeric
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
  -- Resolve restaurant
  -- =======================================================

  select rm.restaurant_id
  into v_restaurant_id
  from public.restaurant_memberships rm
  where rm.profile_id = v_user_id;

  if not found then
    raise exception 'User does not belong to a restaurant';
  end if;


  -- =======================================================
  -- Validate period
  -- =======================================================

  if p_start_at is null
     or p_end_at is null
     or p_previous_start_at is null then

    raise exception 'Report period boundaries are required';

  end if;

  if p_start_at >= p_end_at then
    raise exception 'Start must be before end';
  end if;

  if p_previous_start_at >= p_start_at then
    raise exception 'Previous period must begin before current period';
  end if;


  -- =======================================================
  -- Build overview
  -- =======================================================

  return query

  with

  current_orders as (
    select
      coalesce(sum(o.total_amount), 0)::numeric as revenue,
      count(*)::bigint as total_orders,
      coalesce(avg(o.total_amount), 0)::numeric as average_order

    from public.orders o

    where o.restaurant_id = v_restaurant_id
      and o.ordered_at >= p_start_at
      and o.ordered_at < p_end_at
  ),


  previous_orders as (
    select
      coalesce(sum(o.total_amount), 0)::numeric as revenue,
      count(*)::bigint as total_orders,
      coalesce(avg(o.total_amount), 0)::numeric as average_order

    from public.orders o

    where o.restaurant_id = v_restaurant_id
      and o.ordered_at >= p_previous_start_at
      and o.ordered_at < p_start_at
  ),


  current_cost as (
    select
      coalesce(
        sum(oi.quantity * oi.unit_cost)
          filter (where oi.unit_cost is not null),
        0
      )::numeric as food_cost,

      count(*)::bigint as total_rows,
      count(oi.unit_cost)::bigint as rows_with_cost

    from public.order_items oi

    join public.orders o
      on o.id = oi.order_id

    where o.restaurant_id = v_restaurant_id
      and o.ordered_at >= p_start_at
      and o.ordered_at < p_end_at
  ),


  previous_cost as (
    select
      coalesce(
        sum(oi.quantity * oi.unit_cost)
          filter (where oi.unit_cost is not null),
        0
      )::numeric as food_cost,

      count(*)::bigint as total_rows,
      count(oi.unit_cost)::bigint as rows_with_cost

    from public.order_items oi

    join public.orders o
      on o.id = oi.order_id

    where o.restaurant_id = v_restaurant_id
      and o.ordered_at >= p_previous_start_at
      and o.ordered_at < p_start_at
  ),


  current_expenses as (
    select
      coalesce(sum(e.amount), 0)::numeric as expenses

    from public.expenses e

    where e.restaurant_id = v_restaurant_id
      and e.expense_at >= p_start_at
      and e.expense_at < p_end_at
  ),


  previous_expenses as (
    select
      coalesce(sum(e.amount), 0)::numeric as expenses

    from public.expenses e

    where e.restaurant_id = v_restaurant_id
      and e.expense_at >= p_previous_start_at
      and e.expense_at < p_start_at
  ),


  current_wastage as (
    select
      coalesce(sum(w.estimated_loss), 0)::numeric as wastage

    from public.wastage_entries w

    where w.restaurant_id = v_restaurant_id
      and w.wastage_date >= p_start_at::date
      and w.wastage_date < p_end_at::date
  ),


  previous_wastage as (
    select
      coalesce(sum(w.estimated_loss), 0)::numeric as wastage

    from public.wastage_entries w

    where w.restaurant_id = v_restaurant_id
      and w.wastage_date >= p_previous_start_at::date
      and w.wastage_date < p_start_at::date
  ),


  metrics as (
    select

      co.revenue as revenue,
      po.revenue as previous_revenue,

      ce.expenses as expenses,
      pe.expenses as previous_expenses,

      cc.food_cost as food_cost,
      pc.food_cost as previous_food_cost,

      (cc.total_rows = cc.rows_with_cost) as cost_complete,
      (pc.total_rows = pc.rows_with_cost) as previous_cost_complete,

      cw.wastage as wastage,
      pw.wastage as previous_wastage,

      co.total_orders,
      po.total_orders as previous_orders,

      co.average_order,
      po.average_order as previous_average_order

    from current_orders co
    cross join previous_orders po
    cross join current_cost cc
    cross join previous_cost pc
    cross join current_expenses ce
    cross join previous_expenses pe
    cross join current_wastage cw
    cross join previous_wastage pw
  ),


  calculated as (
    select
      m.*,

      case
        when m.cost_complete
        then m.revenue - m.food_cost
        else null
      end as gross_profit,

      case
        when m.cost_complete
        then
          m.revenue
          - m.food_cost
          - m.expenses
          - m.wastage
        else null
      end as net_profit,

      case
        when m.previous_cost_complete
        then
          m.previous_revenue
          - m.previous_food_cost
          - m.previous_expenses
          - m.previous_wastage
        else null
      end as previous_net_profit

    from metrics m
  )

  select

    -- Revenue
    round(c.revenue, 2),

    case
      when c.previous_revenue = 0 then null
      else round(
        ((c.revenue - c.previous_revenue) / c.previous_revenue) * 100,
        1
      )
    end,


    -- Expenses
    round(c.expenses, 2),

    case
      when c.previous_expenses = 0 then null
      else round(
        ((c.expenses - c.previous_expenses) / c.previous_expenses) * 100,
        1
      )
    end,


    -- Food cost
    case
      when c.cost_complete
      then round(c.food_cost, 2)
      else null
    end,

    case
      when not c.cost_complete
        or c.revenue = 0
      then null

      else round(
        (c.food_cost / c.revenue) * 100,
        1
      )
    end,

    c.cost_complete,


    -- Gross profit
    case
      when c.gross_profit is null then null
      else round(c.gross_profit, 2)
    end,


    -- Wastage
    round(c.wastage, 2),

    case
      when c.previous_wastage = 0 then null
      else round(
        ((c.wastage - c.previous_wastage) / c.previous_wastage) * 100,
        1
      )
    end,


    -- Estimated net profit
    case
      when c.net_profit is null then null
      else round(c.net_profit, 2)
    end,

    case
      when c.net_profit is null
        or c.previous_net_profit is null
        or c.previous_net_profit = 0
      then null

      else round(
        (
          (c.net_profit - c.previous_net_profit)
          / abs(c.previous_net_profit)
        ) * 100,
        1
      )
    end,

    case
      when c.net_profit is null
        or c.revenue = 0
      then null

      else round(
        (c.net_profit / c.revenue) * 100,
        1
      )
    end,


    -- Orders
    c.total_orders,

    case
      when c.previous_orders = 0 then null
      else round(
        (
          (c.total_orders - c.previous_orders)::numeric
          / c.previous_orders
        ) * 100,
        1
      )
    end,


    -- Average order
    round(c.average_order, 2),

    case
      when c.previous_average_order = 0 then null
      else round(
        (
          (c.average_order - c.previous_average_order)
          / c.previous_average_order
        ) * 100,
        1
      )
    end

  from calculated c;

end;
$$;


revoke all
on function public.get_report_overview(
  timestamptz,
  timestamptz,
  timestamptz
)
from public;

grant execute
on function public.get_report_overview(
  timestamptz,
  timestamptz,
  timestamptz
)
to authenticated;



-- =========================================================
-- 2. Get Report Revenue Expense Trend
--
-- Powers the ONE major Reports chart.
--
-- Supported grouping:
--   week
--   month
--
-- Suggested:
--   1M -> week
--   3M -> week
--   6M -> month
--   1Y -> month
--
-- Zero-value buckets are returned.
--
-- p_timezone ensures calendar grouping matches the
-- restaurant/user's local timezone.
-- =========================================================

create or replace function public.get_report_revenue_expense_trend(
  p_start_at timestamptz,
  p_end_at timestamptz,
  p_group_by text,
  p_timezone text default 'UTC'
)
returns table (
  period_start date,
  revenue numeric,
  expenses numeric
)
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_user_id uuid;
  v_restaurant_id uuid;
  v_step interval;

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


  -- Validate
  if p_start_at is null or p_end_at is null then
    raise exception 'Report period boundaries are required';
  end if;

  if p_start_at >= p_end_at then
    raise exception 'Start must be before end';
  end if;


  case p_group_by

    when 'week' then
      v_step := interval '1 week';

    when 'month' then
      v_step := interval '1 month';

    else
      raise exception 'Group by must be week or month';

  end case;


  if not exists (
    select 1
    from pg_timezone_names
    where name = p_timezone
  ) then
    raise exception 'Invalid timezone';
  end if;


  return query

  with bounds as (
    select
      date_trunc(
        p_group_by,
        p_start_at at time zone p_timezone
      ) as bucket_start,

      date_trunc(
        p_group_by,
        (p_end_at - interval '1 microsecond')
          at time zone p_timezone
      ) as bucket_end
  ),


  buckets as (
    select
      generate_series(
        b.bucket_start,
        b.bucket_end,
        v_step
      ) as bucket

    from bounds b
  ),


  sales as (
    select
      date_trunc(
        p_group_by,
        o.ordered_at at time zone p_timezone
      ) as bucket,

      sum(o.total_amount)::numeric as revenue

    from public.orders o

    where o.restaurant_id = v_restaurant_id
      and o.ordered_at >= p_start_at
      and o.ordered_at < p_end_at

    group by
      date_trunc(
        p_group_by,
        o.ordered_at at time zone p_timezone
      )
  ),


  expense_data as (
    select
      date_trunc(
        p_group_by,
        e.expense_at at time zone p_timezone
      ) as bucket,

      sum(e.amount)::numeric as expenses

    from public.expenses e

    where e.restaurant_id = v_restaurant_id
      and e.expense_at >= p_start_at
      and e.expense_at < p_end_at

    group by
      date_trunc(
        p_group_by,
        e.expense_at at time zone p_timezone
      )
  )


  select
    b.bucket::date,

    round(
      coalesce(s.revenue, 0),
      2
    ),

    round(
      coalesce(e.expenses, 0),
      2
    )

  from buckets b

  left join sales s
    on s.bucket = b.bucket

  left join expense_data e
    on e.bucket = b.bucket

  order by
    b.bucket asc;

end;
$$;


revoke all
on function public.get_report_revenue_expense_trend(
  timestamptz,
  timestamptz,
  text,
  text
)
from public;

grant execute
on function public.get_report_revenue_expense_trend(
  timestamptz,
  timestamptz,
  text,
  text
)
to authenticated;



-- =========================================================
-- 3. Get Report Drivers
--
-- Returns ONLY analytics that are unique to the
-- "Drivers & Impact" section.
--
-- We intentionally do NOT return:
--   food cost
--   wastage
--   average order
--
-- because get_report_overview() already provides those.
--
-- Returns:
--   - leading sales channel
--   - leading channel revenue/share
--   - top revenue menu item
--   - top menu item revenue
-- =========================================================

create or replace function public.get_report_drivers(
  p_start_at timestamptz,
  p_end_at timestamptz
)
returns table (
  leading_channel public.order_channel,
  leading_channel_revenue numeric,
  leading_channel_share_percent numeric,

  top_menu_item_id uuid,
  top_menu_item_name varchar,
  top_menu_item_revenue numeric
)
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_user_id uuid;
  v_restaurant_id uuid;

  v_total_revenue numeric := 0;

  v_leading_channel public.order_channel;
  v_leading_channel_revenue numeric := 0;

  v_top_item_id uuid;
  v_top_item_name varchar;
  v_top_item_revenue numeric := 0;

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


  -- Validate
  if p_start_at is null or p_end_at is null then
    raise exception 'Report period boundaries are required';
  end if;

  if p_start_at >= p_end_at then
    raise exception 'Start must be before end';
  end if;


  -- =======================================================
  -- Total revenue
  -- =======================================================

  select
    coalesce(sum(o.total_amount), 0)

  into v_total_revenue

  from public.orders o

  where o.restaurant_id = v_restaurant_id
    and o.ordered_at >= p_start_at
    and o.ordered_at < p_end_at;


  -- =======================================================
  -- Leading sales channel
  -- =======================================================

  select
    o.channel,
    sum(o.total_amount)

  into
    v_leading_channel,
    v_leading_channel_revenue

  from public.orders o

  where o.restaurant_id = v_restaurant_id
    and o.ordered_at >= p_start_at
    and o.ordered_at < p_end_at

  group by o.channel

  order by
    sum(o.total_amount) desc,
    o.channel asc

  limit 1;


  if not found then
    v_leading_channel := null;
    v_leading_channel_revenue := 0;
  end if;


  -- =======================================================
  -- Top revenue menu item
  --
  -- Historical item_name is intentionally used.
  --
  -- This allows historical reports to remain meaningful
  -- even if the current menu item was later renamed,
  -- deactivated, or deleted.
  -- =======================================================

  select
    oi.menu_item_id,
    oi.item_name,
    sum(oi.line_total)

  into
    v_top_item_id,
    v_top_item_name,
    v_top_item_revenue

  from public.order_items oi

  join public.orders o
    on o.id = oi.order_id

  where o.restaurant_id = v_restaurant_id
    and o.ordered_at >= p_start_at
    and o.ordered_at < p_end_at

  group by
    oi.menu_item_id,
    oi.item_name

  order by
    sum(oi.line_total) desc,
    oi.item_name asc

  limit 1;


  if not found then
    v_top_item_id := null;
    v_top_item_name := null;
    v_top_item_revenue := 0;
  end if;


  -- =======================================================
  -- Return unique Report drivers
  -- =======================================================

  return query
  select

    v_leading_channel,

    round(
      v_leading_channel_revenue,
      2
    ),

    case
      when v_total_revenue = 0 then 0
      else round(
        (
          v_leading_channel_revenue
          / v_total_revenue
        ) * 100,
        1
      )
    end,

    v_top_item_id,
    v_top_item_name,

    round(
      v_top_item_revenue,
      2
    );

end;
$$;


revoke all
on function public.get_report_drivers(
  timestamptz,
  timestamptz
)
from public;

grant execute
on function public.get_report_drivers(
  timestamptz,
  timestamptz
)
to authenticated;