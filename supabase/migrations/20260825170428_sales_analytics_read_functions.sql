-- =========================================================
-- Sales Analytics Read Functions
--
-- Contains ONLY calculated / aggregated Sales reads.
--
-- Raw order lists and order details should be queried
-- directly from Flutter through Supabase + RLS.
-- =========================================================


-- =========================================================
-- 1. Get Sales Summary
--
-- Reusable by:
--   - Sales Main
--   - Sales History
--
-- Flutter supplies the period boundaries.
--
-- Example: Today
--   p_start_at          = start of today
--   p_end_at            = start of tomorrow
--   p_previous_start_at = start of yesterday
--
-- Example: 1 Month
--   p_start_at          = start of selected month
--   p_end_at            = end of selected month
--   p_previous_start_at = start of previous equivalent period
--
-- Current period:
--   [p_start_at, p_end_at)
--
-- Previous period:
--   [p_previous_start_at, p_start_at)
-- =========================================================

create or replace function public.get_sales_summary(
  p_start_at timestamptz,
  p_end_at timestamptz,
  p_previous_start_at timestamptz
)
returns table (
  total_sales numeric,
  total_orders bigint,
  average_order numeric,
  previous_sales numeric,
  sales_change_percent numeric
)
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_user_id uuid;
  v_restaurant_id uuid;

  v_total_sales numeric := 0;
  v_total_orders bigint := 0;
  v_average_order numeric := 0;

  v_previous_sales numeric := 0;
  v_sales_change numeric;

begin

  -- -------------------------------------------------------
  -- Authentication
  -- -------------------------------------------------------

  v_user_id := auth.uid();

  if v_user_id is null then
    raise exception 'Authentication required';
  end if;


  -- -------------------------------------------------------
  -- Resolve current user's restaurant
  -- -------------------------------------------------------

  select rm.restaurant_id
  into v_restaurant_id
  from public.restaurant_memberships rm
  where rm.profile_id = v_user_id;

  if not found then
    raise exception 'User does not belong to a restaurant';
  end if;


  -- -------------------------------------------------------
  -- Validate period
  -- -------------------------------------------------------

  if p_start_at is null
     or p_end_at is null
     or p_previous_start_at is null then

    raise exception 'Sales period boundaries are required';

  end if;

  if p_start_at >= p_end_at then
    raise exception 'Start must be before end';
  end if;

  if p_previous_start_at >= p_start_at then
    raise exception 'Previous period must begin before current period';
  end if;


  -- -------------------------------------------------------
  -- Current-period sales
  -- -------------------------------------------------------

  select
    coalesce(sum(o.total_amount), 0),
    count(*),
    coalesce(avg(o.total_amount), 0)

  into
    v_total_sales,
    v_total_orders,
    v_average_order

  from public.orders o

  where o.restaurant_id = v_restaurant_id
    and o.ordered_at >= p_start_at
    and o.ordered_at < p_end_at;


  -- -------------------------------------------------------
  -- Previous-period sales
  -- -------------------------------------------------------

  select
    coalesce(sum(o.total_amount), 0)

  into v_previous_sales

  from public.orders o

  where o.restaurant_id = v_restaurant_id
    and o.ordered_at >= p_previous_start_at
    and o.ordered_at < p_start_at;


  -- -------------------------------------------------------
  -- Comparison
  --
  -- NULL when previous period had no sales.
  -- This avoids misleading/infinite percentage increases.
  -- -------------------------------------------------------

  if v_previous_sales = 0 then

    v_sales_change := null;

  else

    v_sales_change :=
      round(
        (
          (v_total_sales - v_previous_sales)
          / v_previous_sales
        ) * 100,
        1
      );

  end if;


  return query
  select
    round(v_total_sales, 2),
    v_total_orders,
    round(v_average_order, 2),
    round(v_previous_sales, 2),
    v_sales_change;

end;
$$;


revoke all
on function public.get_sales_summary(
  timestamptz,
  timestamptz,
  timestamptz
)
from public;

grant execute
on function public.get_sales_summary(
  timestamptz,
  timestamptz,
  timestamptz
)
to authenticated;


-- =========================================================
-- 2. Get Sales By Channel
--
-- Reusable by:
--   - Sales Main
--   - Sales History
--
-- Returns every order-channel enum value, including
-- channels with zero sales.
--
-- This allows Flutter to consistently display:
--
--   Dine-in
--   Takeaway
--   Delivery
-- =========================================================

create or replace function public.get_sales_by_channel(
  p_start_at timestamptz,
  p_end_at timestamptz
)
returns table (
  channel public.order_channel,
  total_sales numeric,
  total_orders bigint,
  sales_share_percent numeric
)
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_user_id uuid;
  v_restaurant_id uuid;
  v_period_total numeric := 0;

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
    raise exception 'Sales period boundaries are required';
  end if;

  if p_start_at >= p_end_at then
    raise exception 'Start must be before end';
  end if;


  -- Total revenue used to calculate percentage share.
  select coalesce(sum(o.total_amount), 0)
  into v_period_total
  from public.orders o
  where o.restaurant_id = v_restaurant_id
    and o.ordered_at >= p_start_at
    and o.ordered_at < p_end_at;


  return query

  with channels as (
    select
      unnest(
        enum_range(
          null::public.order_channel
        )
      ) as channel
  ),

  channel_totals as (
    select
      o.channel,
      sum(o.total_amount) as total_sales,
      count(*) as total_orders

    from public.orders o

    where o.restaurant_id = v_restaurant_id
      and o.ordered_at >= p_start_at
      and o.ordered_at < p_end_at

    group by o.channel
  )

  select
    c.channel,

    round(
      coalesce(ct.total_sales, 0),
      2
    ),

    coalesce(
      ct.total_orders,
      0
    )::bigint,

    case
      when v_period_total = 0 then 0

      else round(
        (
          coalesce(ct.total_sales, 0)
          / v_period_total
        ) * 100,
        1
      )
    end

  from channels c

  left join channel_totals ct
    on ct.channel = c.channel

  order by
    case c.channel
      when 'dine_in'::public.order_channel then 1
      when 'takeaway'::public.order_channel then 2
      when 'delivery'::public.order_channel then 3
      else 99
    end;

end;
$$;


revoke all
on function public.get_sales_by_channel(
  timestamptz,
  timestamptz
)
from public;

grant execute
on function public.get_sales_by_channel(
  timestamptz,
  timestamptz
)
to authenticated;


-- =========================================================
-- 3. Get Sales Trend
--
-- Used only by Sales History chart.
--
-- Supported grouping:
--
--   day
--   week
--   month
--
-- Suggested Flutter mapping:
--
--   1W → day
--   1M → day
--   3M → week
--   6M → month
--   1Y → month
--
-- p_timezone controls local calendar grouping.
--
-- Example:
--   Asia/Kathmandu
--
-- Zero-sales periods are also returned so charts do not
-- have missing dates/buckets.
-- =========================================================

create or replace function public.get_sales_trend(
  p_start_at timestamptz,
  p_end_at timestamptz,
  p_group_by text,
  p_timezone text default 'UTC'
)
returns table (
  period_start date,
  total_sales numeric,
  total_orders bigint
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


  -- Validate period
  if p_start_at is null or p_end_at is null then
    raise exception 'Sales period boundaries are required';
  end if;

  if p_start_at >= p_end_at then
    raise exception 'Start must be before end';
  end if;


  -- Determine bucket interval.
  case p_group_by

    when 'day' then
      v_step := interval '1 day';

    when 'week' then
      v_step := interval '1 week';

    when 'month' then
      v_step := interval '1 month';

    else
      raise exception 'Group by must be day, week, or month';

  end case;


  -- Validate timezone.
  --
  -- PostgreSQL raises an error if timezone() receives an
  -- invalid timezone name. This check produces a clearer
  -- application error instead.
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

      sum(o.total_amount) as total_sales,
      count(*) as total_orders

    from public.orders o

    where o.restaurant_id = v_restaurant_id
      and o.ordered_at >= p_start_at
      and o.ordered_at < p_end_at

    group by
      date_trunc(
        p_group_by,
        o.ordered_at at time zone p_timezone
      )
  )

  select
    b.bucket::date,

    round(
      coalesce(s.total_sales, 0),
      2
    ),

    coalesce(
      s.total_orders,
      0
    )::bigint

  from buckets b

  left join sales s
    on s.bucket = b.bucket

  order by
    b.bucket asc;

end;
$$;


revoke all
on function public.get_sales_trend(
  timestamptz,
  timestamptz,
  text,
  text
)
from public;

grant execute
on function public.get_sales_trend(
  timestamptz,
  timestamptz,
  text,
  text
)
to authenticated;