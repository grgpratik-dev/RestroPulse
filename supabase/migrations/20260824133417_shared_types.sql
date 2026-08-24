create type public.restaurant_role as enum (
  'owner',
  'viewer'
);

create type public.join_request_status as enum (
  'pending',
  'approved',
  'declined'
);

create type public.order_channel as enum (
  'dine_in',
  'takeaway',
  'delivery'
);

create type public.expense_type as enum (
  'fixed',
  'variable'
);

create type public.wastage_reason as enum (
  'overproduction',
  'expired',
  'preparation_mistake',
  'customer_return',
  'damaged',
  'other'
);

create type public.wastage_unit as enum (
  'kg',
  'g',
  'pcs',
  'portions',
  'litres',
  'other'
);

create type public.device_platform as enum (
  'ios',
  'android'
);

create type public.notification_type as enum (
  'join_request_received',
  'join_request_approved',
  'join_request_declined',
  'viewer_removed'
);