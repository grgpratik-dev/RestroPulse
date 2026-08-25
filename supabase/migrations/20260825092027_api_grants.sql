-- =========================================================
-- API Grants
--
-- PostgreSQL privileges are required before RLS policies
-- can even be evaluated.
--
-- These grants allow authenticated users to attempt CRUD
-- operations through the Supabase API.
--
-- Row Level Security still decides whether a specific user
-- is actually allowed to perform the operation.
-- =========================================================


-- =========================================================
-- Profiles
-- =========================================================

grant select, update
on public.profiles
to authenticated;


-- =========================================================
-- Restaurants
-- =========================================================

grant select, insert, update, delete
on public.restaurants
to authenticated;

-- =========================================================
-- Restaurant Join Codes
--
-- Direct client access is read-only.
-- Owner visibility is still restricted by RLS.
-- Writes happen through controlled RPC functions.
-- =========================================================

grant select
on public.restaurant_join_codes
to authenticated;



-- =========================================================
-- Restaurant Memberships
-- =========================================================

grant select, insert, update, delete
on public.restaurant_memberships
to authenticated;


-- =========================================================
-- Restaurant Join Requests
-- =========================================================

grant select
on public.restaurant_join_requests
to authenticated;


-- =========================================================
-- Menu
-- =========================================================

grant select, insert, update, delete
on public.menu_categories
to authenticated;

grant select, insert, update, delete
on public.menu_items
to authenticated;


-- =========================================================
-- Orders
-- =========================================================

grant select, insert, update, delete
on public.orders
to authenticated;

grant select, insert, update, delete
on public.order_items
to authenticated;


-- =========================================================
-- Expenses
-- =========================================================

grant select, insert, update, delete
on public.expense_categories
to authenticated;

grant select, insert, update, delete
on public.expenses
to authenticated;


-- =========================================================
-- Wastage
-- =========================================================

grant select, insert, update, delete
on public.wastage_entries
to authenticated;


-- =========================================================
-- User Devices
-- =========================================================

grant select, insert, update, delete
on public.user_devices
to authenticated;


-- =========================================================
-- Notifications
-- =========================================================

grant select
on public.notifications
to authenticated;
