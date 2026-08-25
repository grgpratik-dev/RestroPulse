-- =========================================================
-- Restaurant Join Codes
--
-- Stores the active viewer-access code for a restaurant.
--
-- Flow:
--   Owner generates/shares code
--       ↓
--   User enters code
--       ↓
--   Code resolves to restaurant
--       ↓
--   Pending join request is created
--
-- Business rules:
--   - One active code per restaurant.
--   - Code can be regenerated.
--   - Code can be disabled.
--   - Codes are used only to request Viewer access.
-- =========================================================

create table public.restaurant_join_codes ( 
  id uuid primary key default gen_random_uuid(),

  -- Restaurant this join code belongs to.
  restaurant_id uuid not null
    references public.restaurants(id)
    on delete cascade,

  -- Human-readable code shared by the owner.
  -- Example: RP-7K9M2
  code varchar(20) not null,

  -- Whether this code can currently be used.
  is_active boolean not null default true,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  -- A code must be globally unique.
  constraint restaurant_join_codes_unique_code
    unique (code),

  -- A restaurant keeps only one join-code record.
  constraint restaurant_join_codes_unique_restaurant
    unique (restaurant_id)
);


-- =========================================================
-- Automatically maintain updated_at.
-- =========================================================

create trigger set_restaurant_join_codes_updated_at
before update on public.restaurant_join_codes
for each row
execute function public.set_updated_at();


-- =========================================================
-- Index
-- Useful when resolving a code entered by a user.
-- =========================================================

create index restaurant_join_codes_active_code_idx
  on public.restaurant_join_codes (code)
  where is_active = true;