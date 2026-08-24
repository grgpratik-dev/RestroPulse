-- =========================================================
-- Notifications
-- Stores in-app notifications for RestroPulse users.
--
-- Push delivery is handled separately through user_devices.
-- This table stores the actual notification record that can
-- be shown inside the app.
-- =========================================================

create table public.notifications (
  id uuid primary key default gen_random_uuid(),

  -- User who should receive the notification.
  recipient_profile_id uuid not null
    references public.profiles(id)
    on delete cascade,

  -- Restaurant related to the notification.
  restaurant_id uuid
    references public.restaurants(id)
    on delete cascade,

  -- Notification event type.
  type public.notification_type not null,

  -- Notification title shown to the user.
  title varchar not null,

  -- Notification message/body.
  message text not null,

  -- Type of entity that caused or is related to
  -- this notification.
  --
  -- Example:
  --   restaurant_join_request
  related_entity_type varchar,

  -- ID of the related entity.
  --
  -- Example:
  --   ID of the restaurant_join_requests row
  related_entity_id uuid,

  -- Whether the recipient has read/opened the notification.
  is_read boolean not null default false,

  created_at timestamptz not null default now()
);


-- =========================================================
-- Indexes
-- =========================================================

-- Used when loading all notifications for a user.
create index notifications_recipient_profile_id_idx
  on public.notifications (recipient_profile_id);


-- Important for loading a user's notification history
-- ordered/filterable by creation time.
create index notifications_recipient_created_at_idx
  on public.notifications (
    recipient_profile_id,
    created_at
  );


-- Useful for quickly finding unread notifications.
create index notifications_unread_recipient_idx
  on public.notifications (recipient_profile_id)
  where is_read = false;


-- Useful for restaurant-related notification queries.
create index notifications_restaurant_id_idx
  on public.notifications (restaurant_id);


-- Useful when locating notifications related to a
-- particular entity such as a join request.
create index notifications_related_entity_idx
  on public.notifications (
    related_entity_type,
    related_entity_id
  );