-- =========================================================
-- Storage Buckets
--
-- RestroPulse stores optimized images in three buckets:
--   - avatars
--   - restaurant-logos
--   - receipts
--
-- Images should be resized/compressed in Flutter before
-- upload. These bucket limits act as a second line of defense.
-- =========================================================


-- =========================================================
-- Profile Avatars
-- =========================================================

insert into storage.buckets (
  id,
  name,
  public,
  file_size_limit,
  allowed_mime_types
)
values (
  'avatars',
  'avatars',
  false,
  524288, -- 512 KB
  array[
    'image/jpeg',
    'image/png',
    'image/webp'
  ]
);


-- =========================================================
-- Restaurant Logos
-- =========================================================

insert into storage.buckets (
  id,
  name,
  public,
  file_size_limit,
  allowed_mime_types
)
values (
  'restaurant-logos',
  'restaurant-logos',
  false,
  524288, -- 512 KB
  array[
    'image/jpeg',
    'image/png',
    'image/webp'
  ]
);


-- =========================================================
-- Expense Receipts
-- =========================================================

insert into storage.buckets (
  id,
  name,
  public,
  file_size_limit,
  allowed_mime_types
)
values (
  'receipts',
  'receipts',
  false,
  1048576, -- 1 MB hard safety limit
  array[
    'image/jpeg',
    'image/png',
    'image/webp'
  ]
);