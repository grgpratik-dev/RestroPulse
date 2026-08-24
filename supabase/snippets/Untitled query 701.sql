
begin;

set local role authenticated;

select set_config(
  'request.jwt.claim.sub',
  '82c9f9b8-9a49-45c1-af21-f93782ee7ddd',
  true
);

select count(*) as visible_restaurants
from public.restaurants;

rollback;