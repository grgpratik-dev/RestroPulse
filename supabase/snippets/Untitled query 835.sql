-- =========================================================
-- TEST DATA: Restaurant + memberships
-- =========================================================

insert into public.restaurants (
  id,
  name
)
values (
  '11111111-1111-1111-1111-111111111111',
  'RLS Test Restaurant'
);


-- Owner membership.
insert into public.restaurant_memberships (
  restaurant_id,
  profile_id,
  role
)
values (
  '11111111-1111-1111-1111-111111111111',
  'bd583d5a-f3c4-4276-bc7a-a68679537ce3',
  'owner'
);


-- Viewer membership.
insert into public.restaurant_memberships (
  restaurant_id,
  profile_id,
  role
)
values (
  '11111111-1111-1111-1111-111111111111',
  '2a056d78-89d7-421d-9f7d-3a0b32bcb3aa',
  'viewer'
);