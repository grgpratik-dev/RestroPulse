-- =========================================================
-- Wastage Analytics Read Functions
--
-- Contains ONLY calculated / aggregated Wastage reads.
--
-- Raw wastage lists, history, detail reads, and normal CRUD
-- should use standard Supabase queries + RLS.
-- =========================================================


-- =========================================================
-- 1. Get Wastage Summary
--
-- Reusable by:
--   - Wastage Main
--   - Wastage History
--
-- Current period:
--   [p_start_date, p_end_date)
--
-- Previous period:
--   [p_previous_start_date, p_start_date)
--
-- Returns:
--   - estimated loss
--   - total entries
--   - previous-period loss
--   - percentage change
--   - top reason
--   - top reason loss
--
-- wastage_date is stored as DATE, so this RPC uses DATE
-- parameters directly instead of timestamptz.
-- =========================================================

create or replace function public.get_wastage_summary(
  p_start_date date,
  p_end_date date,
  p_previous_start_date date
)
returns table (
  estimated_loss numeric,
  total_entries bigint,

  previous_loss numeric,
  loss_change_percent numeric,

  top_reason public.wastage_reason,
  top_reason_loss numeric
)
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_user_id uuid;
  v_restaurant_id uuid;

  v_estimated_loss numeric := 0;
  v_total_entries bigint := 0;

  v_previous_loss numeric := 0;
  v_loss_change numeric;

  v_top_reason public.wastage_reason;
  v_top_reason_loss numeric := 0;

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

  if p_start_date is null
     or p_end_date is null
     or p_previous_start_date is null then

    raise exception 'Wastage period boundaries are required';

  end if;

  if p_start_date >= p_end_date then
    raise exception 'Start date must be before end date';
  end if;

  if p_previous_start_date >= p_start_date then
    raise exception 'Previous period must begin before current period';
  end if;


  -- -------------------------------------------------------
  -- Current-period totals
  -- -------------------------------------------------------

  select
    coalesce(sum(w.estimated_loss), 0),
    count(*)

  into
    v_estimated_loss,
    v_total_entries

  from public.wastage_entries w

  where w.restaurant_id = v_restaurant_id
    and w.wastage_date >= p_start_date
    and w.wastage_date < p_end_date;


  -- -------------------------------------------------------
  -- Previous-period total
  -- -------------------------------------------------------

  select
    coalesce(sum(w.estimated_loss), 0)

  into v_previous_loss

  from public.wastage_entries w

  where w.restaurant_id = v_restaurant_id
    and w.wastage_date >= p_previous_start_date
    and w.wastage_date < p_start_date;


  -- -------------------------------------------------------
  -- Percentage comparison
  -- -------------------------------------------------------

  if v_previous_loss = 0 then

    v_loss_change := null;

  else

    v_loss_change :=
      round(
        (
          (v_estimated_loss - v_previous_loss)
          / v_previous_loss
        ) * 100,
        1
      );

  end if;


  -- -------------------------------------------------------
  -- Top reason by estimated loss
  -- -------------------------------------------------------

  select
    w.reason,
    sum(w.estimated_loss)

  into
    v_top_reason,
    v_top_reason_loss

  from public.wastage_entries w

  where w.restaurant_id = v_restaurant_id
    and w.wastage_date >= p_start_date
    and w.wastage_date < p_end_date

  group by w.reason

  order by
    sum(w.estimated_loss) desc,
    w.reason asc

  limit 1;


  if not found then
    v_top_reason := null;
    v_top_reason_loss := 0;
  end if;


  -- -------------------------------------------------------
  -- Return summary
  -- -------------------------------------------------------

  return query
  select
    round(v_estimated_loss, 2),
    v_total_entries,

    round(v_previous_loss, 2),
    v_loss_change,

    v_top_reason,
    round(v_top_reason_loss, 2);

end;
$$;


revoke all
on function public.get_wastage_summary(
  date,
  date,
  date
)
from public;

grant execute
on function public.get_wastage_summary(
  date,
  date,
  date
)
to authenticated;



-- =========================================================
-- 2. Get Wastage By Reason
--
-- Reusable by:
--   - Wastage Main
--   - selected-period wastage analytics
--
-- Returns:
--   - reason
--   - total estimated loss
--   - entry count
--   - percentage share of period wastage loss
--
-- Only reasons that actually occurred are returned.
-- =========================================================

create or replace function public.get_wastage_by_reason(
  p_start_date date,
  p_end_date date
)
returns table (
  reason public.wastage_reason,
  estimated_loss numeric,
  total_entries bigint,
  loss_share_percent numeric
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

  if p_start_date is null or p_end_date is null then
    raise exception 'Wastage period boundaries are required';
  end if;

  if p_start_date >= p_end_date then
    raise exception 'Start date must be before end date';
  end if;


  -- -------------------------------------------------------
  -- Total loss for percentage share
  -- -------------------------------------------------------

  select
    coalesce(sum(w.estimated_loss), 0)

  into v_period_total

  from public.wastage_entries w

  where w.restaurant_id = v_restaurant_id
    and w.wastage_date >= p_start_date
    and w.wastage_date < p_end_date;


  -- -------------------------------------------------------
  -- Group by wastage reason
  -- -------------------------------------------------------

  return query

  select
    w.reason,

    round(
      sum(w.estimated_loss),
      2
    ) as estimated_loss,

    count(*)::bigint as total_entries,

    case
      when v_period_total = 0 then 0

      else round(
        (
          sum(w.estimated_loss)
          / v_period_total
        ) * 100,
        1
      )
    end as loss_share_percent

  from public.wastage_entries w

  where w.restaurant_id = v_restaurant_id
    and w.wastage_date >= p_start_date
    and w.wastage_date < p_end_date

  group by w.reason

  order by
    estimated_loss desc,
    w.reason asc;

end;
$$;


revoke all
on function public.get_wastage_by_reason(
  date,
  date
)
from public;

grant execute
on function public.get_wastage_by_reason(
  date,
  date
)
to authenticated;