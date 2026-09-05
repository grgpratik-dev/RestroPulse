begin;
create extension if not exists pgtap with schema extensions;
set local search_path = public, extensions;
select plan(10);

insert into auth.users (id, email, raw_user_meta_data) values
  ('00000000-0000-4000-8000-000000009101', 'owner-access-test@example.com', '{"full_name":"Test Owner"}'),
  ('00000000-0000-4000-8000-000000009102', 'applicant-access-test@example.com', '{"full_name":"Test Applicant"}');
insert into public.restaurants (id, name, currency_code, timezone, country_code)
values ('00000000-0000-4000-8000-000000009103', 'Access Test Restaurant', 'NPR', 'Asia/Kathmandu', 'NP');
insert into public.restaurant_memberships (restaurant_id, profile_id, role)
values ('00000000-0000-4000-8000-000000009103', '00000000-0000-4000-8000-000000009101', 'owner');

set local role authenticated;
select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-000000009101', true);
select set_config('test.join_code', public.generate_restaurant_join_code(), true);
select is(public.get_restaurant_members_access()->>'join_code', current_setting('test.join_code'), 'owner sees generated code');

select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-000000009102', true);
select is((select restaurant_name::text from public.resolve_restaurant_join_code(current_setting('test.join_code'))), 'Access Test Restaurant', 'applicant previews restaurant');
select set_config('test.request_id', public.request_restaurant_join_by_code(current_setting('test.join_code'))::text, true);
select is(public.request_restaurant_join_by_code(current_setting('test.join_code'))::text, current_setting('test.request_id'), 'repeat join request is idempotent');
select throws_ok('select public.get_restaurant_members_access()', '42501', 'Restaurant membership required', 'pending applicant cannot see member data');

select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-000000009101', true);
select is(public.get_restaurant_members_access()->'requests'->0->>'email', 'applicant-access-test@example.com', 'owner can identify pending applicant');
select public.approve_join_request(current_setting('test.request_id')::uuid);
select is(jsonb_array_length(public.get_restaurant_members_access()->'members'), 2, 'approval creates viewer membership');
select is(jsonb_array_length(public.get_restaurant_members_access()->'requests'), 0, 'approved request leaves pending list');

select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-000000009102', true);
select ok(
  public.get_restaurant_members_access()->>'join_code' is null
  and public.get_restaurant_members_access()->'members'->0->>'email' is null
  and public.get_restaurant_members_access()->'requests' = '[]'::jsonb,
  'viewer cannot see invitation code, private email or applicants'
);
select throws_ok('select public.generate_restaurant_join_code()', 'P0001', 'Only a restaurant owner can manage join codes', 'viewer cannot regenerate code');

select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-000000009101', true);
select public.remove_restaurant_viewer('00000000-0000-4000-8000-000000009102');
select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-000000009102', true);
select throws_ok('select public.get_restaurant_members_access()', '42501', 'Restaurant membership required', 'removed viewer loses access');

select * from finish();
rollback;
