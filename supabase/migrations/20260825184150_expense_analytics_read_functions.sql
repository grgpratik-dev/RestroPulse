-- =========================================================
-- Expense Analytics Read Functions
--
-- Contains ONLY calculated / aggregated Expense reads.
--
-- Raw expense lists, history, details, and normal CRUD
-- should use standard Supabase queries + RLS.
-- =========================================================


-- =========================================================
-- 1. Get Expense Summary
--
-- Reusable by:
--   - Expenses Main
--   - Expense History
--
-- Current period:
--   [p_start_at, p_end_at)
--
-- Previous period:
--   [p_previous_start_at, p_start_at)
--
-- Returns:
--   - total expenses
--   - transaction count
--   - previous-period expenses
--   - percentage change
--   - largest expense category
-- =========================================================

create or replace function public.get_expense_summary(
  p_start_at timestamptz,
  p_end_at timestamptz,
  p_previous_start_at timestamptz
)
returns table (
  total_expenses numeric,
  total_transactions bigint,
  previous_expenses numeric,
  expense_change_percent numeric,

  largest_category_id uuid,
  largest_category_name varchar,
  largest_category_amount numeric
)
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_user_id uuid;
  v_restaurant_id uuid;

  v_total_expenses numeric := 0;
  v_total_transactions bigint := 0;
  v_previous_expenses numeric := 0;
  v_expense_change numeric;

  v_largest_category_id uuid;
  v_largest_category_name varchar;
  v_largest_category_amount numeric := 0;

begin

  -- -------------------------------------------------------
  -- Authentication
  -- -------------------------------------------------------

  v_user_id := auth.uid();

  if v_user_id is null then
    raise exception 'Authentication required';
  end if;


  -- -------------------------------------------------------
  -- Resolve restaurant
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

    raise exception 'Expense period boundaries are required';

  end if;

  if p_start_at >= p_end_at then
    raise exception 'Start must be before end';
  end if;

  if p_previous_start_at >= p_start_at then
    raise exception 'Previous period must begin before current period';
  end if;


  -- -------------------------------------------------------
  -- Current-period totals
  -- -------------------------------------------------------

  select
    coalesce(sum(e.amount), 0),
    count(*)

  into
    v_total_expenses,
    v_total_transactions

  from public.expenses e

  where e.restaurant_id = v_restaurant_id
    and e.expense_at >= p_start_at
    and e.expense_at < p_end_at;


  -- -------------------------------------------------------
  -- Previous-period total
  -- -------------------------------------------------------

  select
    coalesce(sum(e.amount), 0)

  into v_previous_expenses

  from public.expenses e

  where e.restaurant_id = v_restaurant_id
    and e.expense_at >= p_previous_start_at
    and e.expense_at < p_start_at;


  -- -------------------------------------------------------
  -- Percentage comparison
  -- -------------------------------------------------------

  if v_previous_expenses = 0 then

    v_expense_change := null;

  else

    v_expense_change :=
      round(
        (
          (v_total_expenses - v_previous_expenses)
          / v_previous_expenses
        ) * 100,
        1
      );

  end if;


  -- -------------------------------------------------------
  -- Largest category by total expense amount
  -- -------------------------------------------------------

  select
    ec.id,
    ec.name,
    sum(e.amount)

  into
    v_largest_category_id,
    v_largest_category_name,
    v_largest_category_amount

  from public.expenses e

  join public.expense_categories ec
    on ec.id = e.category_id

  where e.restaurant_id = v_restaurant_id
    and e.expense_at >= p_start_at
    and e.expense_at < p_end_at

  group by
    ec.id,
    ec.name

  order by
    sum(e.amount) desc,
    ec.name asc

  limit 1;


  if not found then
    v_largest_category_id := null;
    v_largest_category_name := null;
    v_largest_category_amount := 0;
  end if;


  -- -------------------------------------------------------
  -- Return summary
  -- -------------------------------------------------------

  return query
  select
    round(v_total_expenses, 2),
    v_total_transactions,
    round(v_previous_expenses, 2),
    v_expense_change,

    v_largest_category_id,
    v_largest_category_name,
    round(v_largest_category_amount, 2);

end;
$$;


revoke all
on function public.get_expense_summary(
  timestamptz,
  timestamptz,
  timestamptz
)
from public;

grant execute
on function public.get_expense_summary(
  timestamptz,
  timestamptz,
  timestamptz
)
to authenticated;



-- =========================================================
-- 2. Get Expenses By Category
--
-- Reusable by:
--   - Expenses Main
--   - any period-based expense analytics
--
-- Returns:
--   - category
--   - expense type
--   - total amount
--   - transaction count
--   - percentage share of period expenses
--
-- Only categories that actually have expenses in the
-- selected period are returned.
-- =========================================================

create or replace function public.get_expenses_by_category(
  p_start_at timestamptz,
  p_end_at timestamptz
)
returns table (
  category_id uuid,
  category_name varchar,
  expense_type public.expense_type,
  total_amount numeric,
  transaction_count bigint,
  expense_share_percent numeric
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
  -- Resolve restaurant
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

  if p_start_at is null or p_end_at is null then
    raise exception 'Expense period boundaries are required';
  end if;

  if p_start_at >= p_end_at then
    raise exception 'Start must be before end';
  end if;


  -- -------------------------------------------------------
  -- Total expenses for percentage calculation
  -- -------------------------------------------------------

  select
    coalesce(sum(e.amount), 0)

  into v_period_total

  from public.expenses e

  where e.restaurant_id = v_restaurant_id
    and e.expense_at >= p_start_at
    and e.expense_at < p_end_at;


  -- -------------------------------------------------------
  -- Group by category
  -- -------------------------------------------------------

  return query

  select
    ec.id,
    ec.name,
    ec.expense_type,

    round(
      sum(e.amount),
      2
    ) as total_amount,

    count(*)::bigint as transaction_count,

    case
      when v_period_total = 0 then 0

      else round(
        (
          sum(e.amount)
          / v_period_total
        ) * 100,
        1
      )
    end as expense_share_percent

  from public.expenses e

  join public.expense_categories ec
    on ec.id = e.category_id

  where e.restaurant_id = v_restaurant_id
    and e.expense_at >= p_start_at
    and e.expense_at < p_end_at

  group by
    ec.id,
    ec.name,
    ec.expense_type

  order by
    total_amount desc,
    ec.name asc;

end;
$$;


revoke all
on function public.get_expenses_by_category(
  timestamptz,
  timestamptz
)
from public;

grant execute
on function public.get_expenses_by_category(
  timestamptz,
  timestamptz
)
to authenticated;