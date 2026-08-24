-- =========================================================
-- Menu Categories
-- Groups menu items inside a restaurant.
--
-- Examples:
--   - Momo
--   - Drinks
--   - Main Course
--   - Snacks
--
-- Each category belongs to exactly one restaurant.
-- =========================================================

create table public.menu_categories (
  id uuid primary key default gen_random_uuid(),

  -- Restaurant this category belongs to.
  restaurant_id uuid not null
    references public.restaurants(id)
    on delete cascade,

  -- Category display name.
  name varchar not null,

  -- Optional ordering value for controlling how categories
  -- appear in the app.
  sort_order integer not null default 0,

  -- Allows categories to be hidden without deleting them.
  is_active boolean not null default true,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  -- Prevent duplicate category names within the same restaurant.
  constraint menu_categories_unique_name_per_restaurant
    unique (restaurant_id, name)
);


-- Automatically refresh updated_at whenever
-- a menu category is modified.
create trigger set_menu_categories_updated_at
before update on public.menu_categories
for each row
execute function public.set_updated_at();


-- Improves lookups for all categories belonging
-- to a particular restaurant.
create index menu_categories_restaurant_id_idx
  on public.menu_categories (restaurant_id);