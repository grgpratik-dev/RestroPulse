begin;

set local role authenticated;

select set_config(
  'request.jwt.claim.sub',
  '2a056d78-89d7-421d-9f7d-3a0b32bcb3aa',
  true
);

insert into public.menu_categories (
  restaurant_id,
  name
)
values (
  '11111111-1111-1111-1111-111111111111',
  'Viewer Should Fail'
);

rollback;