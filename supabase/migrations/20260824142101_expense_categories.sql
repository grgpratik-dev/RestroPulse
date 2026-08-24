-- =========================================================
-- Expense Categories
-- Stores both:
--   1. RestroPulse default/system categories
--   2. Restaurant-specific custom categories
--
-- System categories have restaurant_id = NULL.
-- Custom categories belong to one restaurant.
-- =========================================================

create table public.expense_categories (
  id uuid primary key default gen_random_uuid(),

  -- NULL means this is a global RestroPulse system category.
  -- A UUID means this category was created for that restaurant.
  restaurant_id uuid
    references public.restaurants(id)
    on delete cascade,

  -- Category display name.
  name varchar not null,

  -- Fixed or variable expense classification.
  expense_type public.expense_type not null,

  -- System categories are provided by RestroPulse
  -- and should not normally be editable by restaurant users.
  is_system boolean not null default false,

  -- Allows custom categories to be hidden without deleting
  -- historical expense records.
  is_active boolean not null default true,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  -- A system category must not belong to a restaurant,
  -- while a custom category must belong to one.
  constraint expense_categories_valid_scope
    check (
      (is_system = true and restaurant_id is null)
      or
      (is_system = false and restaurant_id is not null)
    )
);


-- Automatically refresh updated_at.
create trigger set_expense_categories_updated_at
before update on public.expense_categories
for each row
execute function public.set_updated_at();


-- Prevent duplicate custom category names
-- within the same restaurant.
create unique index expense_categories_unique_custom_name_idx
on public.expense_categories (restaurant_id, name)
where is_system = false;


-- Prevent duplicate system category names.
create unique index expense_categories_unique_system_name_idx
on public.expense_categories (name)
where is_system = true;


-- Improves lookup of custom categories for a restaurant.
create index expense_categories_restaurant_id_idx
on public.expense_categories (restaurant_id);