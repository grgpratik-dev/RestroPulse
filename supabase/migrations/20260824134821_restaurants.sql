-- =========================================================
-- Restaurants
-- Stores the core business/restaurant information.
--
-- Ownership is NOT stored directly on this table.
-- Owners/viewers are linked through restaurant_memberships,
-- which we will create in the next migration.
-- =========================================================

create table public.restaurants (

  id uuid primary key default gen_random_uuid(),

  -- Restaurant/business display name.
  name varchar not null,

  -- Contact details for the restaurant.
  phone varchar,
  email varchar,

  -- Restaurant address/location information.
  address text,

  -- Optional logo/image path stored in Supabase Storage.
  logo_path varchar,

  -- Base currency used by the restaurant.
  -- RestroPulse currently targets Nepal, so NPR is the default.
  currency_code varchar(3) not null default 'NPR',

  -- Restaurant's permanent business timezone.
  --
  -- Store an IANA timezone name such as:
  --   Asia/Kathmandu
  --   Europe/London
  --   America/Toronto
  --
  -- This value is detected from the owner's device when the
  -- restaurant is created and becomes the source of truth for
  -- restaurant-local analytics and business-day calculations.
  timezone varchar not null,

  -- Controls whether the restaurant is currently active.
  is_active boolean not null default true,

  created_at timestamptz not null default now(),

  updated_at timestamptz not null default now()

);


-- Automatically refresh restaurants.updated_at
-- whenever restaurant information is modified.
create trigger set_restaurants_updated_at

before update on public.restaurants

for each row

execute function public.set_updated_at();