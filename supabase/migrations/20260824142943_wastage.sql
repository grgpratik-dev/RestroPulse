-- =========================================================
-- Wastage Entries
-- Stores operational food/ingredient wastage for a restaurant.
--
-- Wastage uses a free-text item name rather than menu_item_id
-- because wastage may involve raw ingredients or other items
-- that are not part of the restaurant menu.
-- =========================================================

create table public.wastage_entries (
  id uuid primary key default gen_random_uuid(),

  -- Restaurant this wastage entry belongs to.
  restaurant_id uuid not null
    references public.restaurants(id)
    on delete cascade,

  -- Free-text item or ingredient name.
  -- Examples: Tomatoes, Cooking Oil, Chicken Momo.
  item_name varchar not null,

  -- Estimated financial loss caused by the wastage.
  estimated_loss numeric(14,3) not null,

  -- Reason for the wastage.
  reason public.wastage_reason not null,

  -- Optional quantity wasted.
  quantity numeric(14,3),

  -- Optional unit for the quantity.
  unit public.wastage_unit,

  -- Business date when the wastage occurred.
  wastage_date date not null,

  -- Optional additional information.
  notes text,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  -- Estimated loss must be greater than zero.
  constraint wastage_entries_estimated_loss_positive
    check (estimated_loss > 0),

  -- Quantity, when provided, must be greater than zero.
  constraint wastage_entries_quantity_positive
    check (quantity is null or quantity > 0),

  -- Quantity and unit must either both be provided
  -- or both be left NULL.
  constraint wastage_entries_quantity_unit_pair
    check (
      (quantity is null and unit is null)
      or
      (quantity is not null and unit is not null)
    )
);


-- =========================================================
-- Automatically refresh updated_at whenever
-- a wastage entry is modified.
-- =========================================================

create trigger set_wastage_entries_updated_at
before update on public.wastage_entries
for each row
execute function public.set_updated_at();


-- =========================================================
-- Indexes
-- =========================================================

-- Improves loading wastage entries for a restaurant.
create index wastage_entries_restaurant_id_idx
  on public.wastage_entries (restaurant_id);


-- Important for daily and historical wastage reporting.
create index wastage_entries_restaurant_date_idx
  on public.wastage_entries (
    restaurant_id,
    wastage_date
  );