create table public.profiles (
  id uuid primary key
    references auth.users(id)
    on delete cascade,

  full_name varchar,
  phone varchar,
  avatar_path varchar,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);


create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger set_profiles_updated_at
before update on public.profiles
for each row
execute function public.set_updated_at();

-- =========================================================
-- Automatically create a profile when a new auth user
-- is created in Supabase Auth.
-- =========================================================

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  -- Create the matching application profile using the same
  -- UUID generated for the user in auth.users.
  insert into public.profiles (
    id,
    full_name
  )
  values (
    new.id,

    -- Google/OAuth providers may include the user's name
    -- inside raw_user_meta_data.
    -- For OTP/email users this may be NULL initially.
    new.raw_user_meta_data ->> 'full_name'
  );

  -- Required for an AFTER INSERT trigger.
  return new;
end;
$$;


-- Run handle_new_user() every time Supabase Auth
-- successfully inserts a new user.
create trigger on_auth_user_created
after insert on auth.users
for each row
execute function public.handle_new_user();