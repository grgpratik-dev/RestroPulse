-- =========================================================
-- Storage Functions
--
-- Database-side helpers for clearing stored object paths.
--
-- Actual file deletion from Supabase Storage should happen
-- through the Storage API / trusted backend flow.
-- These functions only keep database references consistent.
-- =========================================================


-- =========================================================
-- Clear Profile Avatar Path
-- =========================================================

create or replace function public.clear_own_avatar_path()
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id uuid;
begin
  v_user_id := auth.uid();

  if v_user_id is null then
    raise exception 'Authentication required';
  end if;

  update public.profiles
  set avatar_path = null
  where id = v_user_id;
end;
$$;

revoke all
on function public.clear_own_avatar_path()
from public;

grant execute
on function public.clear_own_avatar_path()
to authenticated;


-- =========================================================
-- Clear Restaurant Logo Path
-- =========================================================

create or replace function public.clear_restaurant_logo_path()
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_restaurant_id uuid;
begin
  -- Only the current restaurant owner can clear the logo.
  if not public.is_restaurant_owner() then
    raise exception 'Only the restaurant owner can remove the logo';
  end if;

  v_restaurant_id := public.current_user_restaurant_id();

  if v_restaurant_id is null then
    raise exception 'Restaurant not found';
  end if;

  update public.restaurants
  set logo_path = null
  where id = v_restaurant_id;
end;
$$;

revoke all
on function public.clear_restaurant_logo_path()
from public;

grant execute
on function public.clear_restaurant_logo_path()
to authenticated;


-- =========================================================
-- Clear Expense Receipt Path
-- =========================================================

create or replace function public.clear_expense_receipt_path(
  p_expense_id uuid
)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_restaurant_id uuid;
begin
  if not public.is_restaurant_owner() then
    raise exception 'Only the restaurant owner can remove receipts';
  end if;

  v_restaurant_id := public.current_user_restaurant_id();

  update public.expenses
  set receipt_path = null
  where id = p_expense_id
    and restaurant_id = v_restaurant_id;

  if not found then
    raise exception 'Expense not found';
  end if;
end;
$$;

revoke all
on function public.clear_expense_receipt_path(uuid)
from public;

grant execute
on function public.clear_expense_receipt_path(uuid)
to authenticated;