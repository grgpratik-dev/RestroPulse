insert into public.restaurants (
  id,
  name
)
values (
  '22222222-2222-2222-2222-222222222222',
  'RLS Test Restaurant B'
);

insert into public.restaurant_memberships (
  restaurant_id,
  profile_id,
  role
)
values (
  '22222222-2222-2222-2222-222222222222',
  '60fdcda0-fb0a-49e6-9f0d-9e8ed6b6d4dc',
  'owner'
);