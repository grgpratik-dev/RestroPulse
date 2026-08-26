-- =========================================================
-- Dashboard Analytics Read Functions
--
-- Aggregated Dashboard analytics only.
--
-- Flutter handles presentation:
--   - alert wording
--   - icons
--   - colors
--   - navigation
--
-- IMPORTANT:
--
-- Flutter sends restaurant BUSINESS DATES.
--
-- The RPC:
--   1. resolves the current restaurant
--   2. reads restaurants.timezone
--   3. converts DATE boundaries to timestamptz for
--      orders / expenses
--   4. uses DATE boundaries directly for wastage
--
-- This keeps Dashboard analytics aligned with the
-- restaurant's local calendar.
-- =========================================================


create or replace function public.get_dashboard_snapshot(
  p_today_start_date date,
  p_today_end_date date,
  p_yesterday_start_date date,

  p_pulse_start_date date,
  p_previous_pulse_start_date date,
  p_previous_previous_pulse_start_date date
)
returns table (
  pulse_score integer,
  pulse_health text,
  pulse_change integer,
  pulse_data_status text,

  sales_status text,
  profitability_status text,

  today_revenue numeric,
  revenue_change_percent numeric,

  today_orders bigint,
  orders_change_percent numeric,

  average_order numeric,
  average_order_change_percent numeric,

  estimated_profit numeric,
  estimated_profit_change_percent numeric,

  food_cost_percent numeric,
  cost_data_complete boolean,

  alert_code text,
  alert_value numeric
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

  -- Timestamp boundaries used for timestamptz columns.
  v_today_start_at timestamptz;
  v_today_end_at timestamptz;
  v_yesterday_start_at timestamptz;

  v_pulse_start_at timestamptz;
  v_previous_pulse_start_at timestamptz;
  v_previous_previous_pulse_start_at timestamptz;

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
  -- Validate required inputs
  -- =======================================================

  if p_today_start_date is null
     or p_today_end_date is null
     or p_yesterday_start_date is null
     or p_pulse_start_date is null
     or p_previous_pulse_start_date is null
     or p_previous_previous_pulse_start_date is null then

    raise exception 'Dashboard period boundaries are required';

  end if;


  -- =======================================================
  -- Validate daily periods
  -- =======================================================

  if p_yesterday_start_date >= p_today_start_date
     or p_today_start_date >= p_today_end_date then

    raise exception 'Invalid daily period boundaries';

  end if;


  -- =======================================================
  -- Validate Pulse periods
  -- =======================================================

  if p_previous_previous_pulse_start_date
        >= p_previous_pulse_start_date

     or p_previous_pulse_start_date
        >= p_pulse_start_date

     or p_pulse_start_date
        >= p_today_end_date then

    raise exception 'Invalid Pulse period boundaries';

  end if;


  -- =======================================================
  -- Pulse periods must contain the same number of
  -- restaurant calendar days.
  --
  -- DATE subtraction returns number of days.
  -- =======================================================

  if
    (
      p_previous_pulse_start_date
      - p_previous_previous_pulse_start_date
    )
    <>
    (
      p_pulse_start_date
      - p_previous_pulse_start_date
    )

    or

    (
      p_pulse_start_date
      - p_previous_pulse_start_date
    )
    <>
    (
      p_today_end_date
      - p_pulse_start_date
    )
  then

    raise exception 'Pulse comparison periods must have equal duration';

  end if;


  -- =======================================================
  -- Convert restaurant-local business dates into exact
  -- timestamptz boundaries.
  --
  -- Example:
  --
  -- 2026-08-25 00:00 Asia/Kathmandu
  --
  -- becomes:
  --
  -- 2026-08-24 18:15 UTC
  --
  -- PostgreSQL also handles DST-aware zones correctly.
  -- =======================================================

  v_today_start_at :=
    p_today_start_date::timestamp
    at time zone v_timezone;

  v_today_end_at :=
    p_today_end_date::timestamp
    at time zone v_timezone;

  v_yesterday_start_at :=
    p_yesterday_start_date::timestamp
    at time zone v_timezone;


  v_pulse_start_at :=
    p_pulse_start_date::timestamp
    at time zone v_timezone;

  v_previous_pulse_start_at :=
    p_previous_pulse_start_date::timestamp
    at time zone v_timezone;

  v_previous_previous_pulse_start_at :=
    p_previous_previous_pulse_start_date::timestamp
    at time zone v_timezone;


  -- =======================================================
  -- Build Dashboard snapshot
  -- =======================================================

  return query

  with

  -- =======================================================
  -- TODAY: Orders
  -- =======================================================

  today_orders_data as (
    select
      coalesce(
        sum(o.total_amount),
        0
      )::numeric as revenue,

      count(*)::bigint as orders,

      coalesce(
        avg(o.total_amount),
        0
      )::numeric as average_order

    from public.orders o

    where o.restaurant_id = v_restaurant_id
      and o.ordered_at >= v_today_start_at
      and o.ordered_at < v_today_end_at
  ),


  -- =======================================================
  -- TODAY: Food Cost
  -- =======================================================

  today_cost as (
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
      and o.ordered_at >= v_today_start_at
      and o.ordered_at < v_today_end_at
  ),


  -- =======================================================
  -- TODAY: Expenses
  -- =======================================================

  today_expenses as (
    select
      coalesce(
        sum(e.amount),
        0
      )::numeric as expenses

    from public.expenses e

    where e.restaurant_id = v_restaurant_id
      and e.expense_at >= v_today_start_at
      and e.expense_at < v_today_end_at
  ),


  -- =======================================================
  -- TODAY: Wastage
  --
  -- wastage_date is already a restaurant business DATE.
  -- No timezone conversion is required.
  -- =======================================================

  today_wastage as (
    select
      coalesce(
        sum(w.estimated_loss),
        0
      )::numeric as wastage

    from public.wastage_entries w

    where w.restaurant_id = v_restaurant_id
      and w.wastage_date >= p_today_start_date
      and w.wastage_date < p_today_end_date
  ),


  -- =======================================================
  -- YESTERDAY: Orders
  -- =======================================================

  yesterday_orders_data as (
    select
      coalesce(
        sum(o.total_amount),
        0
      )::numeric as revenue,

      count(*)::bigint as orders,

      coalesce(
        avg(o.total_amount),
        0
      )::numeric as average_order

    from public.orders o

    where o.restaurant_id = v_restaurant_id
      and o.ordered_at >= v_yesterday_start_at
      and o.ordered_at < v_today_start_at
  ),


  -- =======================================================
  -- YESTERDAY: Food Cost
  -- =======================================================

  yesterday_cost as (
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
      and o.ordered_at >= v_yesterday_start_at
      and o.ordered_at < v_today_start_at
  ),


  -- =======================================================
  -- YESTERDAY: Expenses
  -- =======================================================

  yesterday_expenses as (
    select
      coalesce(
        sum(e.amount),
        0
      )::numeric as expenses

    from public.expenses e

    where e.restaurant_id = v_restaurant_id
      and e.expense_at >= v_yesterday_start_at
      and e.expense_at < v_today_start_at
  ),


  -- =======================================================
  -- YESTERDAY: Wastage
  -- =======================================================

  yesterday_wastage as (
    select
      coalesce(
        sum(w.estimated_loss),
        0
      )::numeric as wastage

    from public.wastage_entries w

    where w.restaurant_id = v_restaurant_id
      and w.wastage_date >= p_yesterday_start_date
      and w.wastage_date < p_today_start_date
  ),


  -- =======================================================
  -- CURRENT PULSE: Revenue
  -- =======================================================

  current_pulse_orders as (
    select
      coalesce(
        sum(o.total_amount),
        0
      )::numeric as revenue

    from public.orders o

    where o.restaurant_id = v_restaurant_id
      and o.ordered_at >= v_pulse_start_at
      and o.ordered_at < v_today_end_at
  ),


  -- =======================================================
  -- CURRENT PULSE: Food Cost
  -- =======================================================

  current_pulse_cost as (
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
      and o.ordered_at >= v_pulse_start_at
      and o.ordered_at < v_today_end_at
  ),


  -- =======================================================
  -- CURRENT PULSE: Expenses
  -- =======================================================

  current_pulse_expenses as (
    select
      coalesce(
        sum(e.amount),
        0
      )::numeric as expenses

    from public.expenses e

    where e.restaurant_id = v_restaurant_id
      and e.expense_at >= v_pulse_start_at
      and e.expense_at < v_today_end_at
  ),


  -- =======================================================
  -- CURRENT PULSE: Wastage
  -- =======================================================

  current_pulse_wastage as (
    select
      coalesce(
        sum(w.estimated_loss),
        0
      )::numeric as wastage

    from public.wastage_entries w

    where w.restaurant_id = v_restaurant_id
      and w.wastage_date >= p_pulse_start_date
      and w.wastage_date < p_today_end_date
  ),


  -- =======================================================
  -- PREVIOUS PULSE: Revenue
  -- =======================================================

  previous_pulse_orders as (
    select
      coalesce(
        sum(o.total_amount),
        0
      )::numeric as revenue

    from public.orders o

    where o.restaurant_id = v_restaurant_id
      and o.ordered_at >= v_previous_pulse_start_at
      and o.ordered_at < v_pulse_start_at
  ),


  -- =======================================================
  -- PREVIOUS PULSE: Food Cost
  -- =======================================================

  previous_pulse_cost as (
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
      and o.ordered_at >= v_previous_pulse_start_at
      and o.ordered_at < v_pulse_start_at
  ),


  -- =======================================================
  -- PREVIOUS PULSE: Expenses
  -- =======================================================

  previous_pulse_expenses as (
    select
      coalesce(
        sum(e.amount),
        0
      )::numeric as expenses

    from public.expenses e

    where e.restaurant_id = v_restaurant_id
      and e.expense_at >= v_previous_pulse_start_at
      and e.expense_at < v_pulse_start_at
  ),


  -- =======================================================
  -- PREVIOUS PULSE: Wastage
  -- =======================================================

  previous_pulse_wastage as (
    select
      coalesce(
        sum(w.estimated_loss),
        0
      )::numeric as wastage

    from public.wastage_entries w

    where w.restaurant_id = v_restaurant_id
      and w.wastage_date >= p_previous_pulse_start_date
      and w.wastage_date < p_pulse_start_date
  ),


  -- =======================================================
  -- PREVIOUS-PREVIOUS PULSE SALES
  -- =======================================================

  previous_previous_pulse_orders as (
    select
      coalesce(
        sum(o.total_amount),
        0
      )::numeric as revenue

    from public.orders o

    where o.restaurant_id = v_restaurant_id
      and o.ordered_at >= v_previous_previous_pulse_start_at
      and o.ordered_at < v_previous_pulse_start_at
  ),


  -- =======================================================
  -- DAILY VALUES
  -- =======================================================

  daily as (
    select
      t.revenue as today_revenue,
      t.orders as today_orders,
      t.average_order,

      y.revenue as yesterday_revenue,
      y.orders as yesterday_orders,
      y.average_order as yesterday_average_order,

      tc.food_cost as today_food_cost,
      yc.food_cost as yesterday_food_cost,

      (
        tc.total_rows = tc.rows_with_cost
      ) as today_cost_complete,

      (
        yc.total_rows = yc.rows_with_cost
      ) as yesterday_cost_complete,

      te.expenses as today_expenses,
      ye.expenses as yesterday_expenses,

      tw.wastage as today_wastage,
      yw.wastage as yesterday_wastage

    from today_orders_data t

    cross join yesterday_orders_data y
    cross join today_cost tc
    cross join yesterday_cost yc
    cross join today_expenses te
    cross join yesterday_expenses ye
    cross join today_wastage tw
    cross join yesterday_wastage yw
  ),


  -- =======================================================
  -- DAILY CALCULATIONS
  -- =======================================================

  daily_calculated as (
    select
      d.*,

      case
        when d.today_cost_complete
        then
          d.today_revenue
          - d.today_food_cost
          - d.today_expenses
          - d.today_wastage

        else null
      end as today_profit,


      case
        when d.yesterday_cost_complete
        then
          d.yesterday_revenue
          - d.yesterday_food_cost
          - d.yesterday_expenses
          - d.yesterday_wastage

        else null
      end as yesterday_profit,


      case
        when d.today_revenue > 0
             and d.today_cost_complete
        then
          (
            d.today_food_cost
            / d.today_revenue
          ) * 100

        else null
      end as today_food_cost_percent,


      case
        when d.today_revenue > 0
        then
          (
            d.today_wastage
            / d.today_revenue
          ) * 100

        else 0
      end as today_wastage_percent,


      case
        when d.yesterday_revenue = 0
        then null

        else
          (
            (
              d.today_revenue
              - d.yesterday_revenue
            )
            / d.yesterday_revenue
          ) * 100
      end as revenue_change,


      case
        when d.yesterday_orders = 0
        then null

        else
          (
            (
              d.today_orders
              - d.yesterday_orders
            )::numeric
            / d.yesterday_orders
          ) * 100
      end as orders_change,


      case
        when d.yesterday_average_order = 0
        then null

        else
          (
            (
              d.average_order
              - d.yesterday_average_order
            )
            / d.yesterday_average_order
          ) * 100
      end as average_order_change

    from daily d
  ),


  daily_final as (
    select
      dc.*,

      case
        when dc.yesterday_profit is null
          or dc.yesterday_profit = 0
          or dc.today_profit is null
        then null

        else
          (
            (
              dc.today_profit
              - dc.yesterday_profit
            )
            / abs(dc.yesterday_profit)
          ) * 100
      end as profit_change

    from daily_calculated dc
  ),


  -- =======================================================
  -- PULSE VALUES
  -- =======================================================

  pulse_raw as (
    select
      cpo.revenue as current_revenue,
      ppo.revenue as previous_revenue,
      pppo.revenue as previous_previous_revenue,

      cpc.food_cost as current_food_cost,
      ppc.food_cost as previous_food_cost,

      (
        cpc.total_rows = cpc.rows_with_cost
      ) as current_cost_complete,

      (
        ppc.total_rows = ppc.rows_with_cost
      ) as previous_cost_complete,

      cpe.expenses as current_expenses,
      ppe.expenses as previous_expenses,

      cpw.wastage as current_wastage,
      ppw.wastage as previous_wastage

    from current_pulse_orders cpo

    cross join previous_pulse_orders ppo
    cross join previous_previous_pulse_orders pppo

    cross join current_pulse_cost cpc
    cross join previous_pulse_cost ppc

    cross join current_pulse_expenses cpe
    cross join previous_pulse_expenses ppe

    cross join current_pulse_wastage cpw
    cross join previous_pulse_wastage ppw
  ),


  -- =======================================================
  -- PULSE DERIVED METRICS
  -- =======================================================

  pulse_metrics as (
    select
      pr.*,

      case
        when pr.current_cost_complete
        then
          pr.current_revenue
          - pr.current_food_cost
          - pr.current_expenses
          - pr.current_wastage

        else null
      end as current_profit,


      case
        when pr.previous_cost_complete
        then
          pr.previous_revenue
          - pr.previous_food_cost
          - pr.previous_expenses
          - pr.previous_wastage

        else null
      end as previous_profit,


      case
        when pr.current_revenue > 0
             and pr.current_cost_complete
        then
          (
            (
              pr.current_revenue
              - pr.current_food_cost
              - pr.current_expenses
              - pr.current_wastage
            )
            / pr.current_revenue
          ) * 100

        else null
      end as current_margin,


      case
        when pr.previous_revenue > 0
             and pr.previous_cost_complete
        then
          (
            (
              pr.previous_revenue
              - pr.previous_food_cost
              - pr.previous_expenses
              - pr.previous_wastage
            )
            / pr.previous_revenue
          ) * 100

        else null
      end as previous_margin,


      case
        when pr.current_revenue > 0
             and pr.current_cost_complete
        then
          (
            pr.current_food_cost
            / pr.current_revenue
          ) * 100

        else null
      end as current_food_cost_percent,


      case
        when pr.previous_revenue > 0
             and pr.previous_cost_complete
        then
          (
            pr.previous_food_cost
            / pr.previous_revenue
          ) * 100

        else null
      end as previous_food_cost_percent,


      case
        when pr.current_revenue > 0
        then
          (
            pr.current_wastage
            / pr.current_revenue
          ) * 100

        else 0
      end as current_wastage_percent,


      case
        when pr.previous_revenue > 0
        then
          (
            pr.previous_wastage
            / pr.previous_revenue
          ) * 100

        else 0
      end as previous_wastage_percent,


      case
        when pr.previous_revenue = 0
        then null

        else
          (
            (
              pr.current_revenue
              - pr.previous_revenue
            )
            / pr.previous_revenue
          ) * 100
      end as current_sales_change,


      case
        when pr.previous_previous_revenue = 0
        then null

        else
          (
            (
              pr.previous_revenue
              - pr.previous_previous_revenue
            )
            / pr.previous_previous_revenue
          ) * 100
      end as previous_sales_change

    from pulse_raw pr
  ),


  -- =======================================================
  -- PULSE SCORING
  -- =======================================================

  pulse_scores as (
    select
      pm.*,

      -- Sales / 30
      case
        when pm.current_sales_change is null then 15
        when pm.current_sales_change >= 10 then 30
        when pm.current_sales_change >= 0 then 24
        when pm.current_sales_change >= -10 then 18
        when pm.current_sales_change >= -20 then 10
        else 4
      end as current_sales_score,


      case
        when pm.previous_sales_change is null then 15
        when pm.previous_sales_change >= 10 then 30
        when pm.previous_sales_change >= 0 then 24
        when pm.previous_sales_change >= -10 then 18
        when pm.previous_sales_change >= -20 then 10
        else 4
      end as previous_sales_score,


      -- Profitability / 30
      case
        when pm.current_margin >= 25 then 30
        when pm.current_margin >= 20 then 25
        when pm.current_margin >= 15 then 20
        when pm.current_margin >= 10 then 12
        when pm.current_margin >= 0 then 6
        else 0
      end as current_profit_score,


      case
        when pm.previous_margin >= 25 then 30
        when pm.previous_margin >= 20 then 25
        when pm.previous_margin >= 15 then 20
        when pm.previous_margin >= 10 then 12
        when pm.previous_margin >= 0 then 6
        else 0
      end as previous_profit_score,


      -- Food Cost / 25
      case
        when pm.current_food_cost_percent <= 25 then 25
        when pm.current_food_cost_percent <= 30 then 22
        when pm.current_food_cost_percent <= 35 then 16
        when pm.current_food_cost_percent <= 40 then 9
        else 3
      end as current_food_score,


      case
        when pm.previous_food_cost_percent <= 25 then 25
        when pm.previous_food_cost_percent <= 30 then 22
        when pm.previous_food_cost_percent <= 35 then 16
        when pm.previous_food_cost_percent <= 40 then 9
        else 3
      end as previous_food_score,


      -- Wastage / 15
      case
        when pm.current_wastage_percent <= 1 then 15
        when pm.current_wastage_percent <= 2 then 12
        when pm.current_wastage_percent <= 3 then 8
        when pm.current_wastage_percent <= 5 then 4
        else 1
      end as current_wastage_score,


      case
        when pm.previous_wastage_percent <= 1 then 15
        when pm.previous_wastage_percent <= 2 then 12
        when pm.previous_wastage_percent <= 3 then 8
        when pm.previous_wastage_percent <= 5 then 4
        else 1
      end as previous_wastage_score

    from pulse_metrics pm
  ),


  -- =======================================================
  -- FINAL PULSE VALUES
  -- =======================================================

  pulse_final as (
    select
      ps.*,

      case
        when ps.current_revenue = 0
        then null

        when not ps.current_cost_complete
        then null

        else
          ps.current_sales_score
          + ps.current_profit_score
          + ps.current_food_score
          + ps.current_wastage_score
      end as current_pulse,


      case
        when ps.previous_revenue = 0
        then null

        when not ps.previous_cost_complete
        then null

        else
          ps.previous_sales_score
          + ps.previous_profit_score
          + ps.previous_food_score
          + ps.previous_wastage_score
      end as previous_pulse

    from pulse_scores ps
  )


  -- =======================================================
  -- FINAL RESPONSE
  -- =======================================================

  select

    -- Pulse Score
    pf.current_pulse::integer,


    -- Pulse Health
    case
      when pf.current_pulse is null then 'insufficient_data'
      when pf.current_pulse >= 90 then 'excellent'
      when pf.current_pulse >= 75 then 'good'
      when pf.current_pulse >= 60 then 'average'
      when pf.current_pulse >= 40 then 'weak'
      else 'critical'
    end,


    -- Pulse Change
    case
      when pf.current_pulse is null
        or pf.previous_pulse is null
      then null

      else
        (
          pf.current_pulse
          - pf.previous_pulse
        )::integer
    end,


    -- Pulse Data Status
    case
      when pf.current_revenue = 0
      then 'insufficient_sales'

      when not pf.current_cost_complete
      then 'missing_cost_data'

      else 'complete'
    end,


    -- Sales Status
    case
      when df.revenue_change is null then 'neutral'
      when df.revenue_change >= 10 then 'strong'
      when df.revenue_change >= 0 then 'stable'
      when df.revenue_change >= -10 then 'soft'
      else 'weak'
    end,


    -- Profitability Status
    case
      when df.today_profit is null
        or df.today_revenue = 0
      then 'unknown'

      when (
        df.today_profit
        / df.today_revenue
      ) * 100 >= 25
      then 'healthy'

      when (
        df.today_profit
        / df.today_revenue
      ) * 100 >= 15
      then 'moderate'

      when df.today_profit >= 0
      then 'low'

      else 'negative'
    end,


    -- Revenue
    round(
      df.today_revenue,
      2
    ),

    case
      when df.revenue_change is null
      then null

      else round(
        df.revenue_change,
        1
      )
    end,


    -- Orders
    df.today_orders,

    case
      when df.orders_change is null
      then null

      else round(
        df.orders_change,
        1
      )
    end,


    -- Average Order
    round(
      df.average_order,
      2
    ),

    case
      when df.average_order_change is null
      then null

      else round(
        df.average_order_change,
        1
      )
    end,


    -- Estimated Profit
    case
      when df.today_profit is null
      then null

      else round(
        df.today_profit,
        2
      )
    end,

    case
      when df.profit_change is null
      then null

      else round(
        df.profit_change,
        1
      )
    end,


    -- Food Cost %
    case
      when df.today_food_cost_percent is null
      then null

      else round(
        df.today_food_cost_percent,
        1
      )
    end,


    -- Cost completeness
    df.today_cost_complete,


    -- =====================================================
    -- Highest-priority alert
    -- =====================================================

    case
      when not df.today_cost_complete
      then 'missing_cost_data'

      when df.today_profit < 0
      then 'negative_profit'

      when df.today_food_cost_percent > 40
      then 'high_food_cost'

      when df.today_wastage_percent > 5
      then 'high_wastage'

      when df.revenue_change <= -20
      then 'sales_decline'

      when df.today_food_cost_percent >= 28
      then 'food_cost_warning'

      else null
    end,


    -- Alert Value
    case
      when not df.today_cost_complete
      then null

      when df.today_profit < 0
      then round(
        df.today_profit,
        2
      )

      when df.today_food_cost_percent > 40
      then round(
        df.today_food_cost_percent,
        1
      )

      when df.today_wastage_percent > 5
      then round(
        df.today_wastage_percent,
        1
      )

      when df.revenue_change <= -20
      then round(
        df.revenue_change,
        1
      )

      when df.today_food_cost_percent >= 28
      then round(
        df.today_food_cost_percent,
        1
      )

      else null
    end

  from daily_final df

  cross join pulse_final pf;

end;
$$;


-- =========================================================
-- Permissions
-- =========================================================

revoke all
on function public.get_dashboard_snapshot(
  date,
  date,
  date,
  date,
  date,
  date
)
from public;


grant execute
on function public.get_dashboard_snapshot(
  date,
  date,
  date,
  date,
  date,
  date
)
to authenticated;