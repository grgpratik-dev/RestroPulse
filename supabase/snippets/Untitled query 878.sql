select
  status,
  reviewed_by_profile_id,
  reviewed_at
from public.restaurant_join_requests
where id = '32064b83-2a48-41da-8697-0ca146447469'::uuid;