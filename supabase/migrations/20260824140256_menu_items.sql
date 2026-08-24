-- =========================================================
-- Menu Items
-- Stores individual food/drink items sold by a restaurant.
--
-- Each menu item belongs to one restaurant and can optionally
-- belong to one menu category.
-- =========================================================

create table public.menu_items (
  id uuid primary key default gen_random_uuid(),

  -- Restaurant this menu item belongs to.
  restaurant_id uuid not null
    references public.restaurants(id)
    on delete cascade,

  -- Optional category for organizing the item.
  -- If a category is deleted, the menu item remains
  -- but becomes uncategorized.
  category_id uuid
    references public.menu_categories(id)
    on delete set null,

  -- Item display name.
  name varchar not null,

  -- Optional description shown in the app.
  description text,

  -- Selling price charged to the customer.
  selling_price numeric(12,2) not null,

  -- Estimated cost to prepare/procure one unit of the item.
  -- Used later for menu profitability analytics.
  cost_price numeric(12,2),

  -- Optional image path in Supabase Storage.
  image_path varchar,

  -- Controls whether the item is currently available for sale.
  is_available boolean not null default true,

  -- Allows an item to be archived/hidden without deleting
  -- its historical sales references.
  is_active boolean not null default true,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  -- Prices cannot be negative.
  constraint menu_items_selling_price_non_negative
    check (selling_price >= 0),

  constraint menu_items_cost_price_non_negative
    check (cost_price is null or cost_price >= 0),

  -- Prevent duplicate active menu item names
  -- within the same restaurant.
  constraint menu_items_unique_name_per_restaurant
    unique (restaurant_id, name)
);


-- Automatically refresh updated_at whenever
-- a menu item is modified.
create trigger set_menu_items_updated_at
before update on public.menu_items
for each row
execute function public.set_updated_at();


-- Improves lookup of all menu items for a restaurant.
create index menu_items_restaurant_id_idx
  on public.menu_items (restaurant_id);


-- Improves lookup/filtering by menu category.
create index menu_items_category_id_idx
  on public.menu_items (category_id);