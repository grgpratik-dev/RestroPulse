begin;

set local role authenticated;

select set_config(
  'request.jwt.claim.sub',
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
  true
);

-- =========================================================
-- Aug 25
--
-- Boundary order MUST NOT appear here.
-- Expected sales remain 3300.
-- =========================================================

select *
from public.get_sales_summary(
  '2026-08-25'::date,
  '2026-08-26'::date,
  '2026-08-24'::date
);


-- =========================================================
-- Aug 26
--
-- Boundary order MUST appear here.
-- Expected sales = 500
-- Expected orders = 1
-- =========================================================


rollback;