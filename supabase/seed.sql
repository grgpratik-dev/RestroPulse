-- =========================================================
-- RestroPulse Local Development Seed
--
-- These users use fixed UUIDs so database resets always
-- recreate the same predictable test environment.
--
-- NOTE:
-- These are database test identities for SQL/RLS testing.
-- They are not password-login users.
-- =========================================================


-- =========================================================
-- Test Auth Users
-- =========================================================

insert into auth.users (
  id,
  email,
  raw_user_meta_data
)
values
  (
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
    'owner@test.com',
    '{"full_name":"Test Owner"}'
  ),
  (
    'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
    'viewer@test.com',
    '{"full_name":"Test Viewer"}'
  ),
  (
    'cccccccc-cccc-cccc-cccc-cccccccccccc',
    'outsider@test.com',
    '{"full_name":"Test Outsider"}'
  ),
  (
    'dddddddd-dddd-dddd-dddd-dddddddddddd',
    'owner2@test.com',
    '{"full_name":"Test Owner 2"}'
  );


-- =========================================================
-- Test Restaurants
-- =========================================================

insert into public.restaurants (
  id,
  name
)
values
  (
    '11111111-1111-1111-1111-111111111111',
    'RLS Test Restaurant A'
  ),
  (
    '22222222-2222-2222-2222-222222222222',
    'RLS Test Restaurant B'
  );


-- =========================================================
-- Restaurant Memberships
--
-- Restaurant A:
--   Owner  -> owner@test.com
--   Viewer -> viewer@test.com
--
-- Restaurant B:
--   Owner  -> owner2@test.com
--
-- outsider@test.com intentionally has no membership.
-- =========================================================

insert into public.restaurant_memberships (
  restaurant_id,
  profile_id,
  role
)
values
  (
    '11111111-1111-1111-1111-111111111111',
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
    'owner'
  ),
  (
    '11111111-1111-1111-1111-111111111111',
    'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
    'viewer'
  ),
  (
    '22222222-2222-2222-2222-222222222222',
    'dddddddd-dddd-dddd-dddd-dddddddddddd',
    'owner'
  );