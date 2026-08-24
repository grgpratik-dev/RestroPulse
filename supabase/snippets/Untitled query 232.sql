begin;

set local role authenticated;

select set_config(
  'request.jwt.claim.sub',
  '2a056d78-89d7-421d-9f7d-3a0b32bcb3aa',
  true
);

update public.profiles
set full_name = 'Should Not Work'
where id = 'bd583d5a-f3c4-4276-bc7a-a68679537ce3';

rollback;