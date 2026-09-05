-- The create_restaurant RPC stores the country selected during setup.
alter table public.restaurants
add column if not exists country_code varchar(2);

alter table public.restaurants
add constraint restaurants_country_code_format
check (country_code is null or country_code ~ '^[A-Z]{2}$');
