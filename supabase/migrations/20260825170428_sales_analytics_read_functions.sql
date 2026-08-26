-- =========================================================
-- Sales Analytics Read Functions
--
-- Contains ONLY calculated / aggregated Sales reads.
--
-- Raw order lists and order details should be queried
-- directly from Flutter through Supabase + RLS.
--
-- IMPORTANT:
-- Flutter supplies restaurant BUSINESS DATES.
--
-- The RPC:
--   1. resolves the user's restaurant
--   2. reads restaurants.timezone
--   3. converts local business dates into timestamptz
--      boundaries
--   4. filters orders.ordered_at using those boundaries
--
-- This keeps all sales analytics aligned with the
-- restaurant's actual local calendar.
-- =========================================================


-- =========================================================
-- 1. Get Sales Summary
--
-- Current period:
--   [p_start_date, p_end_date)
--
-- Previous period:
--   [p_previous_start_date, p_start_date)
--
-- Example:
--
-- Today:
--   p_start_date          = 2026-08-25
--   p_end_date            = 2026-08-26
--   p_previous_start_date = 2026-08-24
--
-- If restaurant timezone is Asia/Kathmandu:
--
-- 2026-08-25 00:00 local
-- becomes the correct timestamptz boundary internally.
-- =========================================================

create or replace function public.get_sales_summary(
  p_start_date date,
  p_end_date date,
  p_previous_start_date date
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
  v_timezone text;

  v_start_at timestamptz;
  v_end_at timestamptz;
  v_previous_start_at timestamptz;

  v_total_sales numeric := 0;
  v_total_orders bigint := 0;
  v_average_order numeric := 0;
  v_previous_sales numeric := 0;
  v_sales_change numeric;

begin

  -- =======================================================
  -- Authentication
  -- =======================================================

  v_user_id := auth.uid();

  if v_user_id is null then
    raise exception 'Authentication required';
  end if;


  -- =======================================================
  -- Resolve restaurant + permanent restaurant timezone
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

    raise exception 'Sales period boundaries are required';

  end if;


  if p_start_date >= p_end_date then
    raise exception 'Start must be before end';
  end if;


  if p_previous_start_date >= p_start_date then
    raise exception 'Previous period must begin before current period';
  end if;


  -- =======================================================
  -- Convert restaurant-local calendar dates into exact
  -- timestamptz boundaries.
  --
  -- Example:
  --
  -- 2026-08-25 00:00 Asia/Kathmandu
  --
  -- becomes:
  --
  -- 2026-08-24 18:15 UTC
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
  -- Current-period sales
  -- =======================================================

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
    and o.ordered_at >= v_start_at
    and o.ordered_at < v_end_at;


  -- =======================================================
  -- Previous-period sales
  -- =======================================================

  select
    coalesce(sum(o.total_amount), 0)

  into v_previous_sales

  from public.orders o

  where o.restaurant_id = v_restaurant_id
    and o.ordered_at >= v_previous_start_at
    and o.ordered_at < v_start_at;


  -- =======================================================
  -- Comparison
  -- =======================================================

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
  date,
  date,
  date
)
from public;


grant execute
on function public.get_sales_summary(
  date,
  date,
  date
)
to authenticated;



-- =========================================================
-- 2. Get Sales By Channel
--
-- Returns every order-channel enum value, including
-- channels with zero sales.
--
-- Flutter can consistently display:
--
--   Dine-in
--   Takeaway
--   Delivery
-- =========================================================

create or replace function public.get_sales_by_channel(
  p_start_date date,
  p_end_date date
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
  v_timezone text;

  v_start_at timestamptz;
  v_end_at timestamptz;

  v_period_total numeric := 0;

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

    raise exception 'Sales period boundaries are required';

  end if;


  if p_start_date >= p_end_date then
    raise exception 'Start must be before end';
  end if;


  -- =======================================================
  -- Convert restaurant-local dates to timestamp boundaries
  -- =======================================================

  v_start_at :=
    p_start_date::timestamp
    at time zone v_timezone;

  v_end_at :=
    p_end_date::timestamp
    at time zone v_timezone;


  -- =======================================================
  -- Total period revenue
  -- =======================================================

  select
    coalesce(sum(o.total_amount), 0)

  into v_period_total

  from public.orders o

  where o.restaurant_id = v_restaurant_id
    and o.ordered_at >= v_start_at
    and o.ordered_at < v_end_at;


  -- =======================================================
  -- Channel breakdown
  -- =======================================================

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
      and o.ordered_at >= v_start_at
      and o.ordered_at < v_end_at

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
      when v_period_total = 0
      then 0

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
  date,
  date
)
from public;


grant execute
on function public.get_sales_by_channel(
  date,
  date
)
to authenticated;



-- =========================================================
-- 3. Get Sales Trend
--
-- Used by Sales History chart.
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
-- IMPORTANT:
-- Grouping is based on the restaurant's stored timezone.
--
-- Flutter does NOT provide timezone.
--
-- Zero-sales periods are returned so charts do not have
-- missing buckets.
-- =========================================================

create or replace function public.get_sales_trend(
  p_start_date date,
  p_end_date date,
  p_group_by text
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

    raise exception 'Sales period boundaries are required';

  end if;


  if p_start_date >= p_end_date then
    raise exception 'Start must be before end';
  end if;


  -- =======================================================
  -- Determine bucket interval
  -- =======================================================

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


  -- =======================================================
  -- Convert requested restaurant-local date range into
  -- timestamptz boundaries for indexed filtering.
  -- =======================================================

  v_start_at :=
    p_start_date::timestamp
    at time zone v_timezone;

  v_end_at :=
    p_end_date::timestamp
    at time zone v_timezone;


  -- =======================================================
  -- Determine local calendar bucket range
  --
  -- These remain timestamp WITHOUT time zone because they
  -- represent restaurant-local calendar bucket labels.
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
  -- Trend
  -- =======================================================

  return query

  with buckets as (
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

      sum(o.total_amount) as total_sales,

      count(*) as total_orders

    from public.orders o

    where o.restaurant_id = v_restaurant_id
      and o.ordered_at >= v_start_at
      and o.ordered_at < v_end_at

    group by
      date_trunc(
        p_group_by,
        o.ordered_at at time zone v_timezone
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

  order by b.bucket asc;

end;
$$;


revoke all
on function public.get_sales_trend(
  date,
  date,
  text
)
from public;


grant execute
on function public.get_sales_trend(
  date,
  date,
  text
)
to authenticated;