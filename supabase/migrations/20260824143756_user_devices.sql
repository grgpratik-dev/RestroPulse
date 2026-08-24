-- =========================================================
-- User Devices
-- Stores push-notification device registrations for users.
--
-- A user may have multiple devices, and each device has its
-- own push token.
-- =========================================================

create table public.user_devices (
  id uuid primary key default gen_random_uuid(),

  -- User/profile this device belongs to.
  -- If the user account is deleted, the device registration
  -- is removed automatically.
  profile_id uuid not null
    references public.profiles(id)
    on delete cascade,

  -- Push-notification token issued for this device.
  push_token text not null,

  -- Device operating system.
  -- Uses the shared enum:
  --   ios
  --   android
  platform public.device_platform not null,

  -- Allows us to deactivate an old token without deleting
  -- the record immediately.
  is_active boolean not null default true,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  -- The same push token should not be registered twice.
  constraint user_devices_unique_push_token
    unique (push_token)
);


-- =========================================================
-- Automatically refresh updated_at whenever
-- the device registration changes.
-- =========================================================

create trigger set_user_devices_updated_at
before update on public.user_devices
for each row
execute function public.set_updated_at();


-- =========================================================
-- Index
-- Useful when loading all active devices belonging
-- to a particular user before sending push notifications.
-- =========================================================

create index user_devices_profile_id_idx
  on public.user_devices (profile_id);