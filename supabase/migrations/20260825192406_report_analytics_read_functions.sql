-- =========================================================
-- Report Analytics Read Functions
--
-- Contains ONLY aggregated / calculated report analytics.
--
-- Raw rows, detail screens, and normal CRUD should use
-- standard Supabase queries + RLS.
--
-- IMPORTANT:
--
-- Flutter supplies restaurant BUSINESS DATES.
--
-- The RPC:
--   1. resolves the user's restaurant
--   2. reads restaurants.timezone
--   3. converts DATE boundaries to timestamptz for
--      orders / expenses
--   4. uses DATE boundaries directly for wastage
--   5. performs calendar grouping in restaurant local time
-- =========================================================



-- =========================================================
-- 1. Get Report Overview
--
-- Reusable for:
--   1M / 3M / 6M / 1Y
--
-- Current period:
--   [p_start_date, p_end_date)
--
-- Previous period:
--   [p_previous_start_date, p_start_date)
--
-- Historical food-cost calculations are valid only when
-- every sold order-item row contains unit_cost.
-- =========================================================

create or replace function public.get_report_overview(
  p_start_date date,
  p_end_date date,
  p_previous_start_date date
)
returns table (
  revenue numeric,
  revenue_change_percent numeric,

  operating_expenses numeric,
  expenses_change_percent numeric,

  estimated_food_cost numeric,
  food_cost_percent numeric,
  previous_food_cost_percent numeric,
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
  v_timezone text;

  v_start_at timestamptz;
  v_end_at timestamptz;
  v_previous_start_at timestamptz;

begin

  -- =======================================================
  -- Authentication
  -- =======================================================

  v_user_id := auth.uid();

  if v_user_id is null then
    raise exception 'Authentication required';
  end if;


  -- =======================================================
  -- Resolve restaurant + permanent timezone
  -- =======================================================

  select
    rm.restaurant_id,
    r.timezone
  into
    v_restaurant_id,
    v_timezone

  from public.restaurant_memberships rm

  join public.restaurants r
    on r.id = rm.restaurant_id

  where rm.profile_id = v_user_id;


  if not found then
    raise exception 'User does not belong to a restaurant';
  end if;


  -- =======================================================
  -- Validate period
  -- =======================================================

  if p_start_date is null
     or p_end_date is null
     or p_previous_start_date is null then

    raise exception 'Report period boundaries are required';

  end if;


  if p_start_date >= p_end_date then
    raise exception 'Start must be before end';
  end if;


  if p_previous_start_date >= p_start_date then
    raise exception 'Previous period must begin before current period';
  end if;


  -- =======================================================
  -- Convert restaurant-local dates into exact timestamptz
  -- boundaries for orders and expenses.
  -- =======================================================

  v_start_at :=
    p_start_date::timestamp
    at time zone v_timezone;

  v_end_at :=
    p_end_date::timestamp
    at time zone v_timezone;

  v_previous_start_at :=
    p_previous_start_date::timestamp
    at time zone v_timezone;


  -- =======================================================
  -- Build overview
  -- =======================================================

  return query

  with

  -- =======================================================
  -- Current Orders
  -- =======================================================

  current_orders as (
    select
      coalesce(
        sum(o.total_amount),
        0
      )::numeric as revenue,

      count(*)::bigint as total_orders,

      coalesce(
        avg(o.total_amount),
        0
      )::numeric as average_order

    from public.orders o

    where o.restaurant_id = v_restaurant_id
      and o.ordered_at >= v_start_at
      and o.ordered_at < v_end_at
  ),


  -- =======================================================
  -- Previous Orders
  -- =======================================================

  previous_orders as (
    select
      coalesce(
        sum(o.total_amount),
        0
      )::numeric as revenue,

      count(*)::bigint as total_orders,

      coalesce(
        avg(o.total_amount),
        0
      )::numeric as average_order

    from public.orders o

    where o.restaurant_id = v_restaurant_id
      and o.ordered_at >= v_previous_start_at
      and o.ordered_at < v_start_at
  ),


  -- =======================================================
  -- Current Food Cost
  -- =======================================================

  current_cost as (
    select
      coalesce(
        sum(
          oi.quantity * oi.unit_cost
        )
        filter (
          where oi.unit_cost is not null
        ),
        0
      )::numeric as food_cost,

      count(*)::bigint as total_rows,

      count(
        oi.unit_cost
      )::bigint as rows_with_cost

    from public.order_items oi

    join public.orders o
      on o.id = oi.order_id

    where o.restaurant_id = v_restaurant_id
      and o.ordered_at >= v_start_at
      and o.ordered_at < v_end_at
  ),


  -- =======================================================
  -- Previous Food Cost
  -- =======================================================

  previous_cost as (
    select
      coalesce(
        sum(
          oi.quantity * oi.unit_cost
        )
        filter (
          where oi.unit_cost is not null
        ),
        0
      )::numeric as food_cost,

      count(*)::bigint as total_rows,

      count(
        oi.unit_cost
      )::bigint as rows_with_cost

    from public.order_items oi

    join public.orders o
      on o.id = oi.order_id

    where o.restaurant_id = v_restaurant_id
      and o.ordered_at >= v_previous_start_at
      and o.ordered_at < v_start_at
  ),


  -- =======================================================
  -- Current Expenses
  -- =======================================================

  current_expenses as (
    select
      coalesce(
        sum(e.amount),
        0
      )::numeric as expenses

    from public.expenses e

    where e.restaurant_id = v_restaurant_id
      and e.expense_at >= v_start_at
      and e.expense_at < v_end_at
  ),


  -- =======================================================
  -- Previous Expenses
  -- =======================================================

  previous_expenses as (
    select
      coalesce(
        sum(e.amount),
        0
      )::numeric as expenses

    from public.expenses e

    where e.restaurant_id = v_restaurant_id
      and e.expense_at >= v_previous_start_at
      and e.expense_at < v_start_at
  ),


  -- =======================================================
  -- Current Wastage
  --
  -- wastage_date is already a business DATE.
  -- =======================================================

  current_wastage as (
    select
      coalesce(
        sum(w.estimated_loss),
        0
      )::numeric as wastage

    from public.wastage_entries w

    where w.restaurant_id = v_restaurant_id
      and w.wastage_date >= p_start_date
      and w.wastage_date < p_end_date
  ),


  -- =======================================================
  -- Previous Wastage
  -- =======================================================

  previous_wastage as (
    select
      coalesce(
        sum(w.estimated_loss),
        0
      )::numeric as wastage

    from public.wastage_entries w

    where w.restaurant_id = v_restaurant_id
      and w.wastage_date >= p_previous_start_date
      and w.wastage_date < p_start_date
  ),


  -- =======================================================
  -- Combine Raw Metrics
  -- =======================================================

  metrics as (
    select
      co.revenue,
      po.revenue as previous_revenue,

      ce.expenses,
      pe.expenses as previous_expenses,

      cc.food_cost,
      pc.food_cost as previous_food_cost,

      (
        cc.total_rows = cc.rows_with_cost
      ) as cost_complete,

      (
        pc.total_rows = pc.rows_with_cost
      ) as previous_cost_complete,

      cw.wastage,
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


  -- =======================================================
  -- Derived Financial Values
  -- =======================================================

  calculated as (
    select
      m.*,

      case
        when m.cost_complete
        then
          m.revenue
          - m.food_cost

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


  -- =======================================================
  -- Final Overview
  -- =======================================================

  select

    -- Revenue
    round(
      c.revenue,
      2
    ),

    case
      when c.previous_revenue = 0
      then null

      else round(
        (
          (
            c.revenue
            - c.previous_revenue
          )
          / c.previous_revenue
        ) * 100,
        1
      )
    end,


    -- Expenses
    round(
      c.expenses,
      2
    ),

    case
      when c.previous_expenses = 0
      then null

      else round(
        (
          (
            c.expenses
            - c.previous_expenses
          )
          / c.previous_expenses
        ) * 100,
        1
      )
    end,


    -- Food Cost
    case
      when c.cost_complete
      then round(
        c.food_cost,
        2
      )

      else null
    end,


    -- Food Cost %
    case
      when not c.cost_complete
        or c.revenue = 0
      then null

      else round(
        (
          c.food_cost
          / c.revenue
        ) * 100,
        1
      )
    end,


    -- Previous Food Cost %
    case
      when not c.previous_cost_complete
        or c.previous_revenue = 0
      then null

      else round(
        (
          c.previous_food_cost
          / c.previous_revenue
        ) * 100,
        1
      )
    end,


    -- Cost completeness
    c.cost_complete,


    -- Gross Profit
    case
      when c.gross_profit is null
      then null

      else round(
        c.gross_profit,
        2
      )
    end,


    -- Wastage
    round(
      c.wastage,
      2
    ),

    case
      when c.previous_wastage = 0
      then null

      else round(
        (
          (
            c.wastage
            - c.previous_wastage
          )
          / c.previous_wastage
        ) * 100,
        1
      )
    end,


    -- Estimated Net Profit
    case
      when c.net_profit is null
      then null

      else round(
        c.net_profit,
        2
      )
    end,


    -- Profit Change %
    case
      when c.net_profit is null
        or c.previous_net_profit is null
        or c.previous_net_profit = 0
      then null

      else round(
        (
          (
            c.net_profit
            - c.previous_net_profit
          )
          / abs(c.previous_net_profit)
        ) * 100,
        1
      )
    end,


    -- Profit Margin %
    case
      when c.net_profit is null
        or c.revenue = 0
      then null

      else round(
        (
          c.net_profit
          / c.revenue
        ) * 100,
        1
      )
    end,


    -- Orders
    c.total_orders,

    case
      when c.previous_orders = 0
      then null

      else round(
        (
          (
            c.total_orders
            - c.previous_orders
          )::numeric
          / c.previous_orders
        ) * 100,
        1
      )
    end,


    -- Average Order
    round(
      c.average_order,
      2
    ),

    case
      when c.previous_average_order = 0
      then null

      else round(
        (
          (
            c.average_order
            - c.previous_average_order
          )
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
  date,
  date,
  date
)
from public;


grant execute
on function public.get_report_overview(
  date,
  date,
  date
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
--   1M → week
--   3M → week
--   6M → month
--   1Y → month
--
-- Zero-value buckets are returned.
--
-- Calendar grouping uses restaurants.timezone.
-- Flutter does NOT supply timezone.
-- =========================================================

create or replace function public.get_report_revenue_expense_trend(
  p_start_date date,
  p_end_date date,
  p_group_by text
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
  v_timezone text;

  v_start_at timestamptz;
  v_end_at timestamptz;

  v_bucket_start timestamp;
  v_bucket_end timestamp;

  v_step interval;

begin

  -- =======================================================
  -- Authentication
  -- =======================================================

  v_user_id := auth.uid();

  if v_user_id is null then
    raise exception 'Authentication required';
  end if;


  -- =======================================================
  -- Resolve restaurant + timezone
  -- =======================================================

  select
    rm.restaurant_id,
    r.timezone
  into
    v_restaurant_id,
    v_timezone

  from public.restaurant_memberships rm

  join public.restaurants r
    on r.id = rm.restaurant_id

  where rm.profile_id = v_user_id;


  if not found then
    raise exception 'User does not belong to a restaurant';
  end if;


  -- =======================================================
  -- Validate period
  -- =======================================================

  if p_start_date is null
     or p_end_date is null then

    raise exception 'Report period boundaries are required';

  end if;


  if p_start_date >= p_end_date then
    raise exception 'Start must be before end';
  end if;


  -- =======================================================
  -- Determine bucket interval
  -- =======================================================

  case p_group_by

    when 'week' then
      v_step := interval '1 week';

    when 'month' then
      v_step := interval '1 month';

    else
      raise exception 'Group by must be week or month';

  end case;


  -- =======================================================
  -- Convert restaurant-local dates into timestamptz
  -- boundaries for indexed filtering.
  -- =======================================================

  v_start_at :=
    p_start_date::timestamp
    at time zone v_timezone;

  v_end_at :=
    p_end_date::timestamp
    at time zone v_timezone;


  -- =======================================================
  -- Local calendar bucket boundaries
  -- =======================================================

  v_bucket_start :=
    date_trunc(
      p_group_by,
      p_start_date::timestamp
    );

  v_bucket_end :=
    date_trunc(
      p_group_by,
      (p_end_date - 1)::timestamp
    );


  -- =======================================================
  -- Revenue / Expense Trend
  -- =======================================================

  return query

  with

  buckets as (
    select
      generate_series(
        v_bucket_start,
        v_bucket_end,
        v_step
      ) as bucket
  ),


  sales as (
    select
      date_trunc(
        p_group_by,
        o.ordered_at at time zone v_timezone
      ) as bucket,

      sum(
        o.total_amount
      )::numeric as revenue

    from public.orders o

    where o.restaurant_id = v_restaurant_id
      and o.ordered_at >= v_start_at
      and o.ordered_at < v_end_at

    group by
      date_trunc(
        p_group_by,
        o.ordered_at at time zone v_timezone
      )
  ),


  expense_data as (
    select
      date_trunc(
        p_group_by,
        e.expense_at at time zone v_timezone
      ) as bucket,

      sum(
        e.amount
      )::numeric as expenses

    from public.expenses e

    where e.restaurant_id = v_restaurant_id
      and e.expense_at >= v_start_at
      and e.expense_at < v_end_at

    group by
      date_trunc(
        p_group_by,
        e.expense_at at time zone v_timezone
      )
  )


  select
    b.bucket::date,

    round(
      coalesce(
        s.revenue,
        0
      ),
      2
    ),

    round(
      coalesce(
        e.expenses,
        0
      ),
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
  date,
  date,
  text
)
from public;


grant execute
on function public.get_report_revenue_expense_trend(
  date,
  date,
  text
)
to authenticated;



-- =========================================================
-- 3. Get Report Drivers
--
-- Returns analytics unique to the "Drivers & Impact"
-- section.
--
-- get_report_overview() already provides:
--   food cost
--   wastage
--   average order
--
-- This RPC returns:
--   - leading sales channel
--   - leading channel revenue
--   - leading channel share
--   - top revenue menu item
--   - top menu item revenue
-- =========================================================

create or replace function public.get_report_drivers(
  p_start_date date,
  p_end_date date
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
  v_timezone text;

  v_start_at timestamptz;
  v_end_at timestamptz;

  v_total_revenue numeric := 0;

  v_leading_channel public.order_channel;
  v_leading_channel_revenue numeric := 0;

  v_top_item_id uuid;
  v_top_item_name varchar;
  v_top_item_revenue numeric := 0;

begin

  -- =======================================================
  -- Authentication
  -- =======================================================

  v_user_id := auth.uid();

  if v_user_id is null then
    raise exception 'Authentication required';
  end if;


  -- =======================================================
  -- Resolve restaurant + timezone
  -- =======================================================

  select
    rm.restaurant_id,
    r.timezone
  into
    v_restaurant_id,
    v_timezone

  from public.restaurant_memberships rm

  join public.restaurants r
    on r.id = rm.restaurant_id

  where rm.profile_id = v_user_id;


  if not found then
    raise exception 'User does not belong to a restaurant';
  end if;


  -- =======================================================
  -- Validate period
  -- =======================================================

  if p_start_date is null
     or p_end_date is null then

    raise exception 'Report period boundaries are required';

  end if;


  if p_start_date >= p_end_date then
    raise exception 'Start must be before end';
  end if;


  -- =======================================================
  -- Convert restaurant-local dates to timestamptz
  -- =======================================================

  v_start_at :=
    p_start_date::timestamp
    at time zone v_timezone;

  v_end_at :=
    p_end_date::timestamp
    at time zone v_timezone;


  -- =======================================================
  -- Total Revenue
  -- =======================================================

  select
    coalesce(
      sum(o.total_amount),
      0
    )

  into v_total_revenue

  from public.orders o

  where o.restaurant_id = v_restaurant_id
    and o.ordered_at >= v_start_at
    and o.ordered_at < v_end_at;


  -- =======================================================
  -- Leading Sales Channel
  -- =======================================================

  select
    o.channel,
    sum(o.total_amount)

  into
    v_leading_channel,
    v_leading_channel_revenue

  from public.orders o

  where o.restaurant_id = v_restaurant_id
    and o.ordered_at >= v_start_at
    and o.ordered_at < v_end_at

  group by
    o.channel

  order by
    sum(o.total_amount) desc,
    o.channel asc

  limit 1;


  if not found then
    v_leading_channel := null;
    v_leading_channel_revenue := 0;
  end if;


  -- =======================================================
  -- Top Revenue Menu Item
  --
  -- Historical item_name is intentionally used so old
  -- reports remain meaningful after a menu rename/delete.
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
    and o.ordered_at >= v_start_at
    and o.ordered_at < v_end_at

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
  -- Return
  -- =======================================================

  return query

  select
    v_leading_channel,

    round(
      v_leading_channel_revenue,
      2
    ),

    case
      when v_total_revenue = 0
      then 0

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
  date,
  date
)
from public;


grant execute
on function public.get_report_drivers(
  date,
  date
)
to authenticated;