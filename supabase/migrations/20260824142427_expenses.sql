-- =========================================================
-- Expenses
-- Stores individual expense records for a restaurant.
--
-- Each expense belongs to one restaurant and one
-- expense category.
-- =========================================================

create table public.expenses (
  id uuid primary key default gen_random_uuid(),

  -- Restaurant this expense belongs to.
  restaurant_id uuid not null
    references public.restaurants(id)
    on delete cascade,

  -- Category used to classify this expense.
  --
  -- Can reference either:
  --   - a RestroPulse system category
  --   - a restaurant-specific custom category
  category_id uuid not null
    references public.expense_categories(id),

  -- User who recorded the expense.
  -- Historical expense data remains even if that user's
  -- account is deleted later.
  recorded_by_profile_id uuid
    references public.profiles(id)
    on delete set null,

  -- Amount spent.
  amount numeric(12,2) not null,

  -- Date/time when the expense actually occurred.
  expense_at timestamptz not null default now(),

  description varchar not null,

  -- Optional description/note about the expense.
  notes text,

  -- Optional receipt image/document stored in Supabase Storage.
  -- Stores the storage object path, not the actual file.
  receipt_path varchar,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  -- Expense amount must be greater than zero.
  constraint expenses_amount_positive
    check (amount > 0)
);


-- =========================================================
-- Automatically refresh updated_at whenever
-- an expense record is modified.
-- =========================================================

create trigger set_expenses_updated_at
before update on public.expenses
for each row
execute function public.set_updated_at();


-- =========================================================
-- Indexes
-- =========================================================

-- Important for loading all expenses belonging
-- to a restaurant.
create index expenses_restaurant_id_idx
  on public.expenses (restaurant_id);


-- Important for daily, monthly and yearly expense reports.
create index expenses_restaurant_expense_at_idx
  on public.expenses (restaurant_id, expense_at);


-- Useful for filtering/reporting expenses by category.
create index expenses_category_id_idx
  on public.expenses (category_id);


-- Useful when auditing expenses entered by a user.
create index expenses_recorded_by_profile_id_idx
  on public.expenses (recorded_by_profile_id);