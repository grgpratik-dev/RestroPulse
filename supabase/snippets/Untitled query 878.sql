select *
from public.orders
where notes in (
  'Should roll back too',
  'Invalid order'
);