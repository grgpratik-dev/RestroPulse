begin;

set local role authenticated;

select set_config(
  'request.jwt.claim.sub',
  'cccccccc-cccc-cccc-cccc-cccccccccccc',
  true
);

select public.create_restaurant(
  p_name := 'Outsider Test Restaurant',
  p_description := 'Created through RPC test'
);

rollback;