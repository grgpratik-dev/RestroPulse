-- =========================================================
-- Storage RLS
--
-- Path conventions:
--
-- avatars/{profile_id}/...
-- restaurant-logos/{restaurant_id}/...
-- receipts/{restaurant_id}/{expense_id}/...
--
-- Buckets are private.
-- Access is controlled through storage.objects policies.
-- =========================================================


-- =========================================================
-- AVATARS
--
-- Users can:
--   - read avatars of users in the same restaurant
--   - read their own avatar
--   - upload/update/delete only their own avatar
-- =========================================================


create policy "Users can read allowed avatars"
on storage.objects
for select
to authenticated
using (
  bucket_id = 'avatars'
  and (
    -- Own avatar.
    (storage.foldername(name))[1] = auth.uid()::text

    or

    -- Avatar belongs to a profile in the same restaurant.
    exists (
      select 1
      from public.restaurant_memberships my_membership
      join public.restaurant_memberships other_membership
        on other_membership.restaurant_id = my_membership.restaurant_id
      where my_membership.profile_id = auth.uid()
        and other_membership.profile_id::text =
          (storage.foldername(name))[1]
    )
  )
);


create policy "Users can upload own avatar"
on storage.objects
for insert
to authenticated
with check (
  bucket_id = 'avatars'
  and (storage.foldername(name))[1] = auth.uid()::text
);


create policy "Users can update own avatar"
on storage.objects
for update
to authenticated
using (
  bucket_id = 'avatars'
  and (storage.foldername(name))[1] = auth.uid()::text
)
with check (
  bucket_id = 'avatars'
  and (storage.foldername(name))[1] = auth.uid()::text
);


create policy "Users can delete own avatar"
on storage.objects
for delete
to authenticated
using (
  bucket_id = 'avatars'
  and (storage.foldername(name))[1] = auth.uid()::text
);


-- =========================================================
-- RESTAURANT LOGOS
--
-- Owner + viewers can read their restaurant logo.
-- Only the owner can upload/update/delete it.
-- =========================================================


create policy "Members can read own restaurant logo"
on storage.objects
for select
to authenticated
using (
  bucket_id = 'restaurant-logos'
  and
  (storage.foldername(name))[1]
    = public.current_user_restaurant_id()::text
);


create policy "Owners can upload restaurant logo"
on storage.objects
for insert
to authenticated
with check (
  bucket_id = 'restaurant-logos'
  and public.is_restaurant_owner()
  and
  (storage.foldername(name))[1]
    = public.current_user_restaurant_id()::text
);


create policy "Owners can update restaurant logo"
on storage.objects
for update
to authenticated
using (
  bucket_id = 'restaurant-logos'
  and public.is_restaurant_owner()
  and
  (storage.foldername(name))[1]
    = public.current_user_restaurant_id()::text
)
with check (
  bucket_id = 'restaurant-logos'
  and public.is_restaurant_owner()
  and
  (storage.foldername(name))[1]
    = public.current_user_restaurant_id()::text
);


create policy "Owners can delete restaurant logo"
on storage.objects
for delete
to authenticated
using (
  bucket_id = 'restaurant-logos'
  and public.is_restaurant_owner()
  and
  (storage.foldername(name))[1]
    = public.current_user_restaurant_id()::text
);


-- =========================================================
-- RECEIPTS
--
-- Owner + viewers can read receipts belonging to their
-- restaurant.
--
-- Only the owner can upload/update/delete receipts.
-- =========================================================


create policy "Members can read own restaurant receipts"
on storage.objects
for select
to authenticated
using (
  bucket_id = 'receipts'
  and
  (storage.foldername(name))[1]
    = public.current_user_restaurant_id()::text
);


create policy "Owners can upload receipts"
on storage.objects
for insert
to authenticated
with check (
  bucket_id = 'receipts'
  and public.is_restaurant_owner()
  and
  (storage.foldername(name))[1]
    = public.current_user_restaurant_id()::text
);


create policy "Owners can update receipts"
on storage.objects
for update
to authenticated
using (
  bucket_id = 'receipts'
  and public.is_restaurant_owner()
  and
  (storage.foldername(name))[1]
    = public.current_user_restaurant_id()::text
)
with check (
  bucket_id = 'receipts'
  and public.is_restaurant_owner()
  and
  (storage.foldername(name))[1]
    = public.current_user_restaurant_id()::text
);


create policy "Owners can delete receipts"
on storage.objects
for delete
to authenticated
using (
  bucket_id = 'receipts'
  and public.is_restaurant_owner()
  and
  (storage.foldername(name))[1]
    = public.current_user_restaurant_id()::text
);