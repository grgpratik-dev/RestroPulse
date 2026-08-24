# RestroPulse Current Frontend Application Specification

> Repository snapshot analyzed: 2026-08-24
> Primary source of truth: executable Flutter code under `lib/`
> Purpose: frontend-to-backend requirements handoff. This document intentionally does **not** design SQL tables, migrations, RLS policies, Edge Functions, or Supabase architecture.

## 1. Analysis Method and Status Vocabulary

The implemented Dart code, route graph, forms, models, state handling, services, and mock datasets were inspected. Documentation, comments, tests, and help copy were treated as secondary evidence when they conflict with executable code.

Status terms used below:

- **Implemented:** executable behavior connected to a real service or durable local store.
- **Complete frontend:** an interactive frontend flow exists, but this does not imply backend persistence.
- **Partial frontend:** meaningful UI/logic exists, with missing actions, persistence, or integration.
- **UI/mock only:** interactive local UI backed by hardcoded or in-memory data.
- **Placeholder:** visible affordance with no real operation.
- **Unclear:** the code does not establish a reliable requirement.

Current verification finding: `flutter analyze lib` has no application-library errors; full-repository analysis fails because old tests still import removed sign-in, sign-up, registration, and password-recovery classes. Those stale tests are not evidence that the removed flows still exist.

## 2. Executive Product Summary

RestroPulse is a restaurant performance and decision-support application aimed primarily at restaurant owners. It combines order sales, operating expenses, menu price/cost performance, food wastage, and period reports to answer: how healthy is the restaurant, what changed, and what needs attention.

The main implemented product surfaces are:

- onboarding;
- passwordless email OTP and Google authentication through Supabase Auth;
- a restaurant-access concept with Owner and Viewer roles;
- dashboard/“Restaurant Pulse” overview;
- per-order and batch order entry;
- expense entry, receipts, history, categories, and category analytics;
- menu item pricing/cost management and performance classifications;
- wastage recording and analytics;
- multi-period reports and insights;
- restaurant, personal profile, member access, and support screens.

### Current implementation reality

| Area | Current reality |
|---|---|
| Authentication | Real Supabase email OTP, OTP verification, Google ID-token sign-in, sign-out, and session observation. |
| Onboarding | Completion is durably stored in local shared preferences. |
| Dashboard, sales, expenses, menu, wastage, reports | Executable UI and local interactions, but almost entirely hardcoded/mock or in-memory. No repository/backend integration exists. |
| Restaurant/profile/member access | UI/mock only. Forms do not persist. Membership and invitation behavior is in-memory. |
| Notifications/export/support submission | Placeholder only. |
| Feature Blocs | Most generated feature Blocs are empty TODO shells and are not used by their screens. Auth Cubits and image-picker Bloc are the meaningful exceptions. |

### Restaurant and tenancy interpretation

The frontend is built around **one currently active restaurant**. Evidence includes one restaurant shown globally (“Boys to Serve”), one restaurant header, one currency, one member list, one join code, and no restaurant switcher. `SalesOrder` contains `restaurantId`, and owner/viewer access is described as restaurant-scoped.

The create-or-join flow implies a user-to-restaurant membership concept and could permit users to become associated with restaurants, but the frontend does not establish whether one user may own/join multiple restaurants. There is no branch/location entity or branch selector. “Location” is restaurant address/display data, not a branch model.

## 3. Complete Screen Inventory

### 3.1 Launch, onboarding, and authentication

#### SplashScreen — `/splash`

- **Purpose:** branded launch animation while app session state initializes.
- **Actions:** none.
- **Displayed data:** logo and RestroPulse name.
- **Source:** bundled assets and local animation.
- **Behavior:** independently attempts to navigate to onboarding after three seconds. `AppSessionController` is initialized after a separate two-second delay and GoRouter may override this based on session/onboarding status.
- **Status:** complete visual frontend; launch sequencing is partially duplicated between the splash screen and session router.

#### OnboardingScreen — `/onboarding`

- **Purpose:** three-step product introduction.
- **Actions:** Next; Get Started.
- **Displayed content:** “Know Your Restaurant’s Pulse,” “Track Sales & Expenses Easily,” and “Get Insights & Grow Your Business,” each with a bundled image and description.
- **Data entered:** none.
- **Source:** hardcoded `onboardingData` and bundled assets.
- **Persistence:** `has_completed_onboarding=true` in shared preferences.
- **Status:** implemented local persistence. The registered `OnboardingBloc` is an unused TODO shell.

#### AuthScreen — `/auth`

- **Purpose:** start passwordless email or Google sign-in.
- **Actions:** request email OTP; initiate Google sign-in; open Terms/Privacy footer links visually (footer behavior must be verified before relying on it).
- **Displayed data:** RestroPulse branding and authentication failure messages.
- **Input:**
  - `email`: string, logically required by Supabase, trimmed before submission; the current screen has **no form validator**, uses a text keyboard rather than email keyboard, and will submit an empty or malformed value.
- **Source:** real `AuthCubit → use case → repository → AuthRemoteDatasource → SupabaseService/GoogleService` flow.
- **Outcome:** email OTP success pushes `/verify-otp`; Google success relies on session routing rather than direct UI navigation.
- **Status:** implemented integration with frontend validation gaps.

#### VerifyOtpScreen — `/verify-otp`

- **Purpose:** verify the emailed six-digit code.
- **Actions:** enter code, verify, go back, tap Resend.
- **Displayed data:** the email retained in root-scoped `AuthCubit` state.
- **Input:**
  - `token`: numeric string, input-limited to 6 digits; submit is not disabled for incomplete input and there is no explicit form validator.
  - `email`: not re-entered; read from `AuthCubit.state.email`.
- **Source:** real Supabase `verifyOTP(type: OtpType.email)`.
- **Important behavior:** Resend has an empty callback and is a placeholder. Successful verification has no direct navigation; Supabase auth state changes cause `AppSessionController` to become authenticated, and GoRouter redirects to dashboard. The route accepts `extra: email`, but `VerifyOtpScreen` does not read it.
- **Status:** verification implemented; resend missing; state continuity depends on the app-scoped Cubit.

### 3.2 Restaurant access and setup

#### RestaurantAccessScreen — `/restaurant-access`

- **Purpose:** choose Owner setup or Viewer access.
- **Actions:** navigate to create restaurant or join restaurant.
- **Displayed data:** owner has full management access; viewer is read-only.
- **Source:** static UI.
- **Status:** UI-only and not part of the authenticated router redirect. Authenticated entry routes currently redirect directly to dashboard.

#### CreateRestaurantScreen — `/restaurant/create`

- **Purpose:** create the initial restaurant as owner.
- **Actions:** choose/take logo visually; submit restaurant; go back.
- **Inputs:**
  - `name`: string, required/nonblank.
  - `location`: string, required/nonblank.
  - `currency`: fixed read-only `NPR (Rs)`.
  - `logo`: optional affordance; gallery/camera choices only close the sheet and do not select/upload a file.
- **Relationships:** creator is strongly implied to become restaurant Owner.
- **Source:** local form only. Successful default behavior navigates to dashboard without creating data.
- **Status:** UI/mock only.

#### JoinRestaurantScreen — `/restaurant/join`

- **Purpose:** locate an invitation and request Viewer access.
- **Actions:** type/paste invitation code, preview invitation, request access.
- **Input:** `invitationCode`: string containing letters, digits, or hyphen; required; minimum length 6; no maximum or exact server format.
- **Displayed preview:** hardcoded restaurant “Boys to Serve,” “Pokhara, Nepal,” invited by owner, Viewer/read-only permission.
- **Pending view:** request sent; waiting for owner approval; says the user will be notified on approval/decline.
- **Source:** entirely in-memory. Any syntactically valid code finds the same mock restaurant.
- **Status:** UI/mock only.

### 3.3 Main application shell

#### MainScreen — stateful shell

- **Purpose:** hosts persistent bottom navigation and active feature branch.
- **Bottom tabs:** Dashboard, Sales, Expenses, Menu, Reports.
- **Global action:** restaurant-logo button opens Profile.
- **Displayed identity:** static RestroPulse branding and bundled restaurant logo.
- **Navigation behavior:** each tab is a `StatefulShellBranch`, preserving its own navigation state.
- **Absent navigation patterns:** there is no drawer, global search, or nested tab bar; most detail/form screens are pushed above the shell on the root navigator.

### 3.4 Dashboard

#### DashboardScreen — `/dashboard`

- **Purpose:** at-a-glance restaurant health and entry shortcuts.
- **Actions:** Add Order, Add Expense, Record Wastage, Review Costs (opens Menu), retry on error.
- **Displayed fields/metrics:**
  - Restaurant Pulse score `84`, status “Excellent Health,” `+4 points vs last week`;
  - health factors: Sales=Strong, Profitability=Healthy;
  - today revenue `Rs 28,450`, `+12.4% vs yesterday`;
  - orders `142`, `+7.2%`;
  - average order `Rs 201`, `+4.8%`;
  - estimated profit `Rs 7,650`, `-2.1%`;
  - food cost `28.4%`, target `<30%`;
  - attention insight: food cost is approaching the target.
- **Alternate states:** loaded, empty, partial/missing-expenses, loading, error.
- **Source:** all hardcoded widget values. There is no dashboard model or active Bloc.
- **Important inconsistency:** Sales shows 42 orders and average order Rs 677 for the same Rs 28,450 day; Dashboard shows 142 and Rs 201.

### 3.5 Sales

#### SalesScreen — `/sales`

- **Purpose:** summarize current sales, trends, channels, and recent orders.
- **Actions:** pull-to-refresh (simulated delay), select analysis period, filter recent orders by channel, open history/order details, choose Single Order or Batch Entry.
- **Displayed data:** today sales, comparison, order count, average order; channel amounts/shares; sales trend and best day/week/month; recent orders.
- **Filters:** analysis periods 1W, 1M, 3M, 6M, 1Y; recent channel All/Dine-in/Takeaway/Delivery.
- **Source:** `SalesMockData`, `SalesTrendMockOrders`, and hardcoded totals.
- **Status:** complete mock frontend.

#### OrderEntryScreen — `/sales/order/add`

- **Purpose:** create one itemized order; also used as edit screen when passed `initialOrder`.
- **Actions:** select channel; search/filter menu; increment/decrement/remove item quantities; apply/edit discount; add note; save/update.
- **Inputs:**
  - `channel`: `OrderChannel`, required by local state, default `dineIn`.
  - `items`: one or more menu snapshots; zero items blocks save with “Add at least one menu item.”
  - `quantity`: integer per item, minimum effective value 1; decrement from 1 removes item.
  - `discount`: nonnegative integer digits only, default 0, clamped to `[0, subtotal]`.
  - `notes`: optional trimmed multiline string, 3–5 lines visually; no length limit.
  - `orderedAt`: not user-editable; the UI implies the current business day.
- **Menu search:** case-insensitive substring of item name.
- **Menu category values:** Popular, Momo, Burgers, Pizza, Drinks. “Popular” uses `isPopular`.
- **Derived fields:** subtotal, total, item count, and estimated food cost.
- **Source/outcome:** save waits 650 ms and pops; it does not create or persist a `SalesOrder`.
- **Missing order fields:** payment method, tax, service charge, customer, status, external/POS reference, delivery platform, table number, server/staff, and currency are absent.

#### Batch Entry — `/sales/batch`

- **Purpose:** enter several itemized orders in one local session.
- **Actions/inputs:** same as OrderEntry; Save & Add Next; edit a session order; Finish Batch.
- **Additional local data:** generated order numbers starting `#0043`, session order count, session total.
- **Source:** private `_BatchOrderSummary` objects in widget memory. Finishing returns only the count; no orders are persisted.

#### OrderDetailsScreen — `/sales/order/details`

- **Purpose:** inspect, edit, or delete an order.
- **Displayed fields:** order number, date, time, channel, item name/quantity/unit price/line total, subtotal, discount, total, estimated food cost, optional note.
- **Actions:** edit via a direct Material route to `OrderEntryScreen`; delete after confirmation.
- **Source:** passed `SalesOrder`, otherwise router falls back to first mock order.
- **Mutation status:** edit/delete only display snackbars or pop local navigation; no shared collection/backend is changed.

#### SalesHistoryScreen — `/sales/history`

- **Purpose:** inspect a selected day.
- **Actions:** choose a date from 2020 through 2026-08-16; open recent order detail.
- **Displayed fields:** selected-day revenue, order count, average order, change vs previous day, channel breakdown, recent order cards.
- **Mock dates:** 2026-08-14, 15, and 16 have summary data; other dates show no-data UI.
- **Important limitation:** it displays the same three `todayOrders` for every populated historical date.

### 3.6 Expenses

#### ExpensesScreen — `/expenses`

- **Purpose:** monthly expense summary plus period category/trend analysis and recent transactions.
- **Actions:** add expense, select analysis period, open category details, open expense details/history.
- **Displayed data:** monthly total/change/transaction count/largest category; category pie breakdown; hardcoded category insight; trend; five recent expenses.
- **Periods offered:** 1M, 3M, 6M, 1Y. `ExpensePeriod.week` exists but is not offered on the main screen.
- **Source:** mock snapshots and local `_expenses` list. Add/edit/delete adjustments affect only widget memory and partially adjust total/transaction count, not category/trend calculations.

#### ExpenseFormScreen — `/expenses/add`

- **Purpose:** add or edit an expense.
- **Inputs:**
  - `amount`: decimal up to 2 places; required and `>0`; values `>=100000` show a confirmation warning but do not require a second confirmation.
  - `category`: required string; default choices are the encoded categories below; user can create a local category.
  - `description`: required nonblank string.
  - `date`: required local date; default 2026-08-16; picker range 2020–2030.
  - `type`: `variable` or `fixed`; default variable; Salaries/Rent auto-suggest fixed, all others variable.
  - `notes`: optional multiline string.
  - `receiptPath`: optional selected gallery image; requested maximum width 1400 and quality 85.
- **Source/outcome:** creates an in-memory `Expense` with a timestamp-derived ID; receipt remains a temporary local file path.

#### ExpenseDetailsScreen — `/expenses/details`

- **Displayed fields:** category, amount, description, date, type, optional notes, optional receipt image.
- **Actions:** edit, delete with confirmation.
- **Source:** passed expense or first mock fallback. Returns a local update/delete result to its caller.

#### ExpenseHistoryScreen — `/expenses/history`

- **Purpose:** transaction history and totals over a selectable range.
- **Actions:** select date range, filter, sort, open/edit/delete detail.
- **Displayed data:** range label, sum of matching expense amounts, count, expenses grouped by calendar date.
- **Filters:** category; type All/Fixed/Variable; sort Newest/Oldest/Highest Amount/Lowest Amount.
- **Date range:** 2020 through 2026-08-16; initial 2026-08-01–16.
- **Source:** passed list or mock list, modified in-memory.

#### ExpenseCategoryDetailsScreen — `/expenses/category/details`

- **Purpose:** show one category’s period analytics.
- **Displayed fields:** total spent, transaction count, share of expenses, comparison percentage, category trend chart, recent matching mock expenses.
- **Actions:** open expense detail.
- **Source:** passed `ExpenseCategorySummary`/period or mock fallback. Category trend is produced by multiplying overall trend points by category share, not by aggregating real expenses.

#### ExpenseCategoriesScreen — `/expenses/categories`

- **Purpose:** manage expense classifications.
- **Actions:** add, rename, change Fixed/Variable type, delete custom category.
- **Inputs:** category name required/nonblank and case-insensitively unique; type required/default Variable.
- **Rules shown:** built-in categories may be renamed but not deleted; custom categories may be deleted “when no expenses use them.” The current UI does not actually check usage.
- **Source:** local private list reset from defaults on every screen creation; not shared with ExpenseFormScreen.

### 3.7 Menu

#### MenuScreen — `/menu`

- **Purpose:** manage menu items and evaluate demand/margin performance.
- **Actions:** select period, filter category, open details, add/edit/delete item.
- **Displayed data:** best seller, most profitable item, items sorted by descending revenue, price/cost/performance status.
- **Periods:** 1M, 3M, 6M, 1Y.
- **Source:** `MenuMockData`; longer periods scale monthly aggregates by mock multipliers instead of querying history.

#### MenuItemFormScreen — `/menu/item/add`

- **Purpose:** add or edit a menu item.
- **Inputs:**
  - `name`: required/nonblank; duplicate against `MenuMockData.items` triggers a warning but Save Anyway is allowed.
  - `category`: required; choices Momo, Burgers, Pizza, Drinks, Snacks; local custom category may be added.
  - `sellingPrice`: decimal up to 2 places, required and `>0`.
  - `estimatedCost`: decimal up to 2 places, required numeric and `>=0`.
  - `notes`: optional multiline.
  - `imagePath`: optional JPG/PNG copy states; picker requests max width 1200, quality 85. MIME/type enforcement is not implemented.
- **Warnings/preview:** cost above selling price warns but is allowed; live food-cost and per-unit contribution are derived.
- **New-item defaults:** unitsSold=0, revenue=0, historicalCost=0, ordersContainingItem=0.
- **Source:** in-memory return value; local image path only.

#### MenuItemDetailsScreen — `/menu/item/details`

- **Displayed fields:** name, category, selling price, estimated cost, food-cost %, contribution/unit, units sold, revenue, historical cost, historical contribution, orders containing item, performance chart, comparison text, classification and recommendation.
- **Actions:** edit; delete while retaining historical sales according to confirmation copy.
- **Source:** passed item/period context or mock fallback.

#### MenuCategoriesScreen — `/menu/categories`

- **Purpose:** manage menu categories.
- **Actions:** add, rename, delete only when local item count is zero.
- **Input:** category name required/nonblank and case-insensitively unique.
- **Mock categories/counts:** Momo 12, Burgers 7, Pizza 6, Drinks 9, Snacks 4.
- **Source:** private screen-local data. Counts do not derive from the six `MenuMockData.items` and changes do not affect menu forms/items.

### 3.8 Wastage

#### WastageScreen — `/wastage`

- **Purpose:** summarize food-loss value, causes, and frequently wasted items.
- **Actions:** record wastage; open/edit/delete recent entry.
- **Displayed data:** total loss, change, entry count, top item, main cause, trend, reason amount/share, top items, recent entries.
- **Period:** fixed to month in the screen. Week/month/quarter snapshots exist in code but no period selector is exposed.
- **Source:** mock snapshot/reasons/items plus locally adjusted entries.

#### WastageFormScreen — `/wastage/record`

- **Inputs:**
  - `itemName`: required nonblank free text (not a menu/ingredient reference).
  - `estimatedLoss`: decimal up to 2 places, required and `>0`.
  - `reason`: required enum.
  - `quantity`: optional decimal, must be `>=0` when present.
  - `unit`: optional enum; quantity and unit are not validated as a pair.
  - `date`: required local date, default 2026-08-16, picker 2020–2030.
  - `notes`: optional multiline.
- **Source/outcome:** creates/returns an in-memory entry with timestamp-derived ID after a simulated delay.

#### WastageDetailsScreen — `/wastage/details`

- **Displayed fields:** item, estimated loss, reason, optional quantity/unit, date, time, optional notes.
- **Actions:** edit; delete with confirmation.
- **Source:** passed entry or first mock fallback.

### 3.9 Reports

#### ReportsScreen — `/reports`

- **Purpose:** multi-period financial and operational analytics.
- **Actions:** choose period; navigate to sales/expenses/menu/wastage; select PDF/CSV export.
- **Periods:** 1M, 3M, 6M, 1Y. No week or custom range.
- **Displayed sections:** Performance Overview, Revenue vs Expenses chart, What Changed insights, Estimated Profit decomposition, and Operational Highlights.
- **Alternate states:** loaded, partial/no expenses, empty, loading, error.
- **Export:** PDF/CSV selection only shows “ready for integration”; no file is produced.
- **Source:** `ReportsMockData` and hardcoded helper datasets.

### 3.10 Profile, access, and support

#### ProfileScreen — `/profile`

- **Purpose:** restaurant/account settings hub and logout.
- **Displayed identity:** Boys to Serve, Pratik Gurung, Pokhara Nepal, 2 members/1 pending, NPR, version 1.0.0.
- **Actions:** edit restaurant; members; currency; menu/expense categories; personal information; change password; notification placeholder; help; Terms/Privacy placeholders; About dialog; logout.
- **Source:** static UI except real Supabase/Google sign-out.

#### PersonalInformationScreen — `/profile/personal-information`

- **Inputs:** full name required; email required with simple `@` and `.` validation; phone required; profile photo affordance; restaurant access is read-only “Owner · Boys to Serve.”
- **Mock defaults:** Pratik Gurung, pratik@example.com, +977 9800000000.
- **Source:** form local only; Save shows snackbar and does not persist. Image actions do not pick a file.

#### EditRestaurantScreen — `/profile/restaurant/edit`

- **Inputs:** restaurant name, business phone, business email, address, city/country—all required; email uses simple `@` and `.` validation; restaurant logo affordance.
- **Mock defaults:** Boys to Serve; +977 9800000000; hello@boystoserve.com; Lakeside Road; Pokhara, Nepal.
- **Source:** local form only; Save does not persist. Image actions do not pick a file.

#### ChangePasswordScreen — `/profile/change-password`

- **Inputs:** current password required; new password required, minimum 8 characters with at least one letter and number, and different from current; confirmation required and equal to new password.
- **Source:** UI-only snackbar; it never calls Supabase. This screen conflicts with the current OTP/Google-only login UI and may be legacy.

#### MembersAccessScreen — `/profile/members-access`

- **Purpose:** owner management of Viewer invitations and members.
- **Actions:** copy, disable/generate, or regenerate the single restaurant join code; approve/decline pending request; remove Viewer access.
- **Displayed/mock data:** join code `RP-7K9M2`; Owner Pratik Gurung; Viewer Suman Gurung; pending Viewer Nisha Thapa.
- **Rules:** one active code per restaurant; regeneration invalidates old code immediately but preserves pending requests; only Viewer can be removed in current UI; every join request requires owner approval.
- **Source:** private in-memory lists and replacement codes.

#### HelpAndSupportScreen — `/help-support`

- **Purpose:** static product FAQ and support entry.
- **Actions:** expand FAQs; email-support placeholder; open ReportProblemScreen.
- **Important conflict:** FAQ copy says initial sales can be aggregate daily totals and need not contain individual customer orders. Executable sales UI currently implements itemized individual orders (including batch entry), not aggregate daily totals.

#### ReportProblemScreen — direct Material route, no named GoRoute

- **Inputs:** issue category required (`Sales`, `Expenses`, `Menu`, `Reports`, `Restaurant Pulse`, `Account`, `Other`); subject required/nonblank; description required/nonblank; optional screenshot affordance.
- **Source:** submission is a 700 ms mock delay; screenshot attachment and support backend are placeholders.

## 4. Navigation and User-Flow Map

### 4.1 Route source of truth

Named paths are declared in `lib/src/app/router/app_route.dart`; route construction and redirects are in `lib/src/app/router/app_router.dart`. `MainScreen` is a `StatefulShellRoute.indexedStack` with five persistent branches:

| Branch | Root | Tab |
|---|---|---|
| 0 | `/dashboard` | Dashboard |
| 1 | `/sales` | Sales |
| 2 | `/expenses` | Expenses |
| 3 | `/menu` | Menu |
| 4 | `/reports` | Reports |

Profile is opened from the shell header rather than a bottom tab. Wastage is reachable from dashboard/profile-related affordances, not a primary branch. Nested detail/form routes are placed on the root navigator where the router explicitly supplies `parentNavigatorKey`, so they cover the shell.

### 4.2 Startup and redirect flow

```text
main()
  -> bootstrap()
     -> load .env
     -> initialize Supabase
     -> configure dependency injection
     -> App.initState()
        -> create AppSessionController
        -> create GoRouter listening to that controller
        -> after 2 seconds, initialize controller
           -> read onboarding completion
           -> inspect current Supabase session
           -> subscribe to Supabase auth-state changes
           -> status = onboarding | unauthenticated | authenticated
        -> router redirect selects /onboarding, /auth, or /dashboard
```

The session controller is the navigation authority. The AuthCubit reports request/verification operation state but does not navigate after a successful OTP verification. Supabase emits the authenticated session, the controller notifies GoRouter, and the redirect moves the user to `/dashboard`. UI code must not also pop or push the dashboard at that moment; the previously observed `GoRouterDelegate._findCurrentNavigators` null-check failure came from attempting to pop a route already displaced by the session redirect.

The splash screen also runs its own three-second timer and attempts to navigate to onboarding. That duplicates session routing and can race with the controller's two-second initialization. The redirect usually corrects the requested destination, but startup currently has two competing orchestration mechanisms.

### 4.3 Redirect rules

- `initializing` always redirects to `/splash`.
- `onboarding` always redirects to `/onboarding` unless already there.
- `unauthenticated` allows `/auth` and `/verify-otp`; all other routes redirect to `/auth`.
- `authenticated` redirects entry routes `/splash`, `/onboarding`, `/auth`, and `/verify-otp` to `/dashboard`.
- Authenticated users may navigate to every other registered route.
- Restaurant access is **not** part of authenticated redirect logic. There is no check for restaurant membership, restaurant setup, suspended membership, or pending join approval.
- Unknown paths receive GoRouter's default failure behavior; no product-specific not-found screen is defined.

### 4.4 Principal user journeys

1. **First launch:** splash -> onboarding pages -> mark completion locally -> auth.
2. **Returning signed-out user:** splash/controller initialization -> auth.
3. **Email OTP:** enter email -> request link/code -> verify screen -> enter six-digit code -> Supabase session event -> dashboard.
4. **Google:** tap Google -> native Google authentication -> exchange ID/access tokens with Supabase -> Supabase session event -> dashboard.
5. **Restaurant setup:** currently a manual/non-enforced path: restaurant access -> create or join. Create saves only locally and pops; join shows a mock preview and pending approval.
6. **Daily operation:** bottom-tab shell -> dashboard/sales/expenses/menu/reports -> root-level forms or details -> return to branch.
7. **Sign out:** profile -> confirmation -> SignOutCubit -> Supabase and Google sign-out -> session event -> router redirects to auth.

### 4.5 Route-argument contracts

- Verify OTP route accepts an email `extra`, but `VerifyOtpScreen` currently reads email from the app-scoped AuthCubit and ignores the route extra.
- Sales order details require a `SalesOrder` in `state.extra`.
- Expense details require an `Expense`; category details require `ExpenseCategoryDetailsData`.
- Menu details/edit require `MenuItem`; wastage details require `WastageEntry`.
- These are in-memory object contracts, not stable deep-link identifiers. Opening such routes without the expected extra can throw a cast/null error and cannot be restored safely after process death.

## 5. Authentication and Account Lifecycle

### 5.1 Implemented authentication boundary

The real boundary is Supabase Auth. The dependency chain follows:

```text
AuthScreen / VerifyOtpScreen
  -> AuthCubit
  -> RequestOtpUsecase | VerifyOtpUsecase | SignInWithGoogleUsecase
  -> AuthRepository
  -> AuthRepositoryImpl
  -> AuthRemoteDataSource
  -> SupabaseService + GoogleService
  -> Supabase Auth / Google Sign-In SDK
```

Repository results use `Either<Failure, T>`. Known SDK/infrastructure errors are converted before presentation. Session observation is separate in `AppSessionController`, which reads `SupabaseService.authStateChanges` and `isAuthenticated`/`currentSession`.

### 5.2 Email OTP fields and transitions

| Step | Input/state | Behavior | Status |
|---|---|---|---|
| Request | email string | Trim email; call `signInWithOtp`; preserve normalized email in AuthState | Implemented |
| Request success | `otpSent` | UI navigates to `/verify-otp` | Implemented |
| Verify | email + token | Call Supabase `verifyOTP` with email OTP type | Implemented |
| Verify success | authenticated Supabase session | Session controller triggers router redirect | Implemented |
| Resend | existing email | Visible affordance has no callback implementation | Placeholder |
| Recovery/deep link | route email or persisted challenge | No implementation | Missing |

There is no explicit email validator in AuthScreen and no `Form`. The verify input is numeric and capped at six characters, but submission is not guarded by an exact-six-character rule in the UI. Supabase remains the effective validator.

Supabase `signInWithOtp` is called without disabling user creation. Consequently a previously unseen email may create an account, subject to project-side Supabase configuration. The frontend therefore implements a combined sign-in/sign-up flow even though it is labeled sign-in.

### 5.3 Google authentication

- Google scopes: `email` and `profile`.
- Google Sign-In initializes with environment-provided web and iOS client IDs.
- Native authentication yields an ID token and authorization access token.
- Tokens are exchanged via Supabase `signInWithIdToken(provider: OAuthProvider.google, ...)`.
- Missing/invalid environment client IDs, provider configuration, bundle/URL scheme setup, simulator limitations, or local Supabase redirect/provider configuration can surface as the generic UI message “This sign-in method is currently unavailable.”
- Google sign-out and Supabase sign-out are both attempted by the sign-out flow.

### 5.4 Account/profile lifecycle gaps

- No explicit registration screen, terms acceptance record, profile-completion step, account deletion, email change, or reauthentication flow.
- No backend profile entity is read after auth.
- The name, phone, avatar, and restaurant membership shown in Profile are mock presentation data and are not derived from Supabase user metadata.
- Change Password is disconnected and inconsistent with OTP/Google-only login.
- No link/unlink-provider flow, merge policy, disabled-user handling, session-expiry explanation, or offline-session UX exists.
- No post-auth requirement ensures that a user owns or belongs to a restaurant before reaching operational data.

### 5.5 Session ownership and lifecycle risks

`AppSessionController` is created once in `App.initState`, passed to the router, and disposed by `App`; this is appropriate ownership for an app-lifetime notifier. It subscribes once during initialization and cancels that subscription on dispose. The main weaknesses are the duplicated splash timer, the delayed initialization, lack of restaurant-membership state, and the coarse three-state authenticated model. Authenticated does not mean authorized for any restaurant.

## 6. Business and Restaurant Model

### 6.1 Current conceptual model

The UI models RestroPulse as a restaurant-owner performance workspace. A user authenticates, creates or joins a restaurant, then records sales, expenses, menu economics, and wastage; reports aggregate those inputs into profit and operational advice.

The executable app behaves as if there is one active restaurant:

- “Boys to Serve” is displayed globally.
- Profile, members, join code, dashboard, and operational tabs have no restaurant selector.
- Currency is fixed to NPR/Rs.
- There is one owner/member list and one active join code.
- No branch/location entity or branch picker exists.

`SalesOrder` uniquely contains `restaurantId`; Expense, MenuItem, WastageEntry, and report models do not. The backend must still tenant all operational records by restaurant even where current DTOs omit the field.

### 6.2 User/restaurant relationship inferred from UI

The create/join flow and roles imply a membership relation rather than a restaurant field directly on a user. A robust conceptual relationship is user <-> restaurant through membership, with at least `owner` and `viewer` roles and an approval status. However, whether one user may belong to multiple restaurants is **unclear**. Current UX provides no switching mechanism, so either only one active membership is supported or an active-restaurant concept is missing.

### 6.3 Create restaurant

Required UI data:

- restaurant name;
- location/address text;
- currency, currently read-only `NPR (Rs)`;
- optional logo affordance, currently nonfunctional.

Creation currently performs a fake delay and returns. It does not create a restaurant, establish owner membership, initialize categories/settings, upload a logo, or route reliably into the operational workspace.

### 6.4 Join restaurant and access control

- Input is a join code accepting letters, digits, and hyphens; minimum length six.
- Any syntactically valid value produces the same mock restaurant preview.
- Submission becomes a pending request; current copy says owner approval is required.
- Members UI defines Owner and Viewer. Viewer is described as read-only.
- There is no route guard or widget-level permission enforcement for Viewer; all edit/add/delete controls remain frontend constructs without a shared authorization layer.
- One join code is active at a time; regenerating invalidates the old code immediately while pending requests remain.
- Missing states: invalid/revoked/expired code, already a member, duplicate request, owner self-join, removed/suspended membership, restaurant deleted, last-owner protection, transfer ownership.

### 6.5 Missing restaurant settings

No executable configuration exists for tax/VAT, service charge, timezone, locale, fiscal day cutoff, opening hours, week start, measurement defaults, costing method, inventory, branch, target food-cost threshold, or report currency. The UI hardcodes a `<30%` food-cost target and August 2026 dates.

## 7. Dashboard and Restaurant Pulse

Dashboard is fully presentation-driven; it does not query any repository or state manager. Values are hardcoded in widgets under `lib/src/features/dashboard/presentation/widgets/`.

| Metric | Current value | Change/target | Required backend meaning |
|---|---:|---:|---|
| Pulse score | 84/100 | +4, “Excellent” | Undefined composite score and prior-period comparison |
| Today revenue | Rs 28,450 | +12.4% | Sum of finalized sales for restaurant business day |
| Orders | 142 | +7.2% | Count of included orders |
| Average order value | Rs 201 | +4.8% | revenue / orders |
| Estimated profit | Rs 7,650 | -2.1% | Exact cost/expense allocation undefined |
| Food cost | 28.4% | target <30% | Estimated food cost / revenue |

The pulse card summarizes “Sales strong” and “Profit healthy.” A cost warning is shown when costs need attention. No source formula, weight, minimum-data rule, confidence indicator, or missing-data behavior is present for the 84 score. Backend work cannot implement a compatible pulse algorithm without a product decision.

Dashboard inconsistencies that need resolution:

- Sales screen uses 42 orders and an average order value of Rs 677 for its “Today” block, while dashboard uses 142 and Rs 201.
- “Estimated profit” is not aligned with the reports formula or a defined daily-expense allocation method.
- Date/business-day and timezone boundaries are undefined.
- Changes do not state whether comparison is yesterday, equivalent prior weekday, or previous period.
- No loading, empty, partial-data, stale-data, or error state is implemented.

## 8. Sales Domain

### 8.1 Entry model

The primary sales workflow records itemized orders. Order entry selects a channel, adds current menu-item snapshots, optionally applies a whole-order discount and notes, then calculates:

```text
line total = quantity * unit price
subtotal = sum(line totals)
total = subtotal - discount
item count = sum(quantities)
estimated food cost = sum(quantity * unit cost)
```

All money on sales models uses integer NPR values. Discount accepts digits and is clamped to `[0, subtotal]`. At least one item is required. There is no tax, service charge, tip, payment method/status, customer, table, waiter, order status, refund, cancellation, complimentary item, split payment, or external order source.

Menu selection supports case-insensitive name search and the local category chips `Popular`, `Momo`, `Burgers`, `Pizza`, and `Drinks`. These UI categories do not align perfectly with the default menu-category management list and are generated from mock snapshot data.

### 8.2 Batch entry

Batch mode repeatedly creates the same itemized order form and accumulates private order summaries, starting after mock order number `#0042`. Finishing returns an order count only. It does not persist a batch entity or its orders. Despite support FAQ copy suggesting aggregate daily-total entry, no executable aggregate record with total revenue/order count exists.

### 8.3 History, filters, and details

- Sales top-level period chips: `1W`, `1M`, `3M`, `6M`, `1Y`.
- Channel filter uses All, Dine-in, Takeaway, Delivery.
- Sales history exposes a date picker bounded from 2020 through 16 August 2026.
- Only 14–16 August have mock daily summaries, and identical “today” orders are reused rather than selected by date.
- Order details display immutable snapshot data; edit/delete actions only change navigation/local presentation.
- Pull-to-refresh is a fake delay.
- No pagination, server sorting, cursor, duplicate-submit protection, or idempotency key exists.

### 8.4 Sales analytics currently displayed

Sales and reports display revenue, order count, average order value, estimated food cost, channel share, trends, and menu contribution. Backend definitions must decide which order statuses count, whether discounts reduce revenue, and how cancellations/refunds affect historical metrics. The frontend currently treats `total` after discount as the natural revenue amount, although report values are independent hardcoded snapshots.

## 9. Expense Domain

### 9.1 Expense capture

An expense contains amount, category, description, date, fixed/variable type, optional notes, and optional receipt path.

- Amount is required, must be greater than zero, and allows at most two decimal places.
- UI warns at `>= Rs 100,000` but does not block submission.
- Category is required and can be selected or created locally.
- Description is required/nonblank.
- Date defaults to 16 August 2026 and is bounded from 2020 through 2030.
- Receipt uses gallery selection, max width 1400 and image quality 85; no upload occurs.
- Saving/editing/deleting modifies only screen-local state or returns an object to the prior screen.

Money here uses `double`, unlike integer sales amounts. A backend contract should choose one consistent minor-unit/decimal strategy.

### 9.2 Categories

Default categories, in UI order:

1. Ingredients
2. Salaries
3. Rent
4. Utilities
5. Packaging
6. Gas
7. Delivery Fees
8. Marketing
9. Repairs & Maintenance
10. Equipment
11. Miscellaneous

Salaries and Rent are suggested as fixed; all others are suggested variable. Custom category names are required and unique case-insensitively within local state. Built-in categories can be renamed but not deleted in the current UI. Copy says custom categories cannot be deleted when expenses use them, but executable code does not enforce that dependency. Analytics also introduces an `Other` category absent from the default list.

### 9.3 Expense summaries and analytics

ExpensesScreen's headline is always a monthly summary. Its analytics selector exposes month, quarter, six months, and year; the domain enum also has week. Snapshots contain total, change percentage, transaction count, average daily, comparison label, trend points, category shares, and category change values.

Category detail supplies total spend, share, transaction count, change, average transaction, trend, and transactions. Expense history supports filters for period/date/category/type and sort by newest, oldest, highest, or lowest. All are in-memory operations over mock data.

Backend calculations must define:

- whether expenses are cash/accrual and which date controls reports;
- how average daily handles partial periods and days with no spend;
- category percentage denominator and rounding;
- comparison periods and treatment of zero prior values;
- fixed/variable type ownership—on the transaction, category default, or both;
- receipt retention, access, MIME/size limits, and orphan cleanup.

### 9.4 Known state-consistency problem

Adding/deleting an expense may update a local list, but the hardcoded total, trend, and category analytics do not recompute from that list. Different expense screens can therefore disagree immediately. The backend-integrated UI needs a single query/cache invalidation strategy rather than independent screen mocks.

## 10. Menu Domain

### 10.1 Menu-item inputs

Menu item fields are name, category, selling price, estimated cost, optional notes, optional image, and historical analytics fields (`unitsSold`, `revenue`, `historicalCost`, `ordersContainingItem`).

- Name is required/nonblank.
- Category is required.
- Selling price must be greater than zero with up to two decimals.
- Estimated cost must be zero or greater with up to two decimals.
- The form calculates food-cost percentage and contribution per unit live.
- It warns when estimated cost exceeds selling price and when food-cost percentage is high; warnings do not necessarily block save.
- Image picker uses gallery, max width 1200 and quality 85. Copy claims JPG/PNG but no MIME validation or upload exists.

### 10.2 Derived economics

```text
food cost % = estimated cost / selling price * 100, or 0 if price is 0
contribution per unit = selling price - estimated cost
margin % = contribution per unit / selling price * 100, or 0 if price is 0
historical contribution = revenue - historical cost
```

Current price/cost represents the editable menu item. Historical revenue/cost is stored as already-aggregated model data, not derived from sales at runtime. To keep old orders stable, order lines already snapshot item name, unit price, and unit cost. Backend analytics should derive historical metrics from order-line snapshots rather than mutable current menu pricing.

### 10.3 Performance classification

For the selected analysis period:

```text
high sales = units sold >= 50 * period demand multiplier
high margin = food cost percentage <= 40
0 units -> Not enough data
high sales + high margin -> Star
high sales + low margin -> Review Cost
low sales + high margin -> Promote
low sales + low margin -> Low Performer
```

Period multipliers are month `1`, quarter `2.95`, six months `5.7`, and year `10.5`. This is a frontend heuristic, not a statistical or restaurant-relative threshold. Exact status labels are `Star`, `Review Cost`, `Promote`, `Low Performer`, and `Not enough data`.

### 10.4 Category and item management limitations

- Menu list supports period and category filtering and sorts by revenue descending.
- Add/edit/delete are local; deletion has no protection for historical references.
- Category screen has mocked counts such as Momo `12`, inconsistent with the six-item mock menu.
- No availability, sold-out, modifier/add-on, variant, recipe/ingredient, portion, tax class, display order, SKU, prep time, archived state, channel price, or effective-dated price exists.
- Historical order lines should not be deleted with a menu item; an archive policy is required.

## 11. Wastage Domain

### 11.1 Wastage capture

A wastage entry records item name, estimated loss, reason, date, and optional quantity, unit, and notes.

- Item name is required/nonblank.
- Estimated loss is required and greater than zero, with up to two decimals.
- Reason is required.
- Date is selected locally.
- Quantity and unit are optional, but validation of their pair is weak; a quantity can be semantically incomplete without a unit and vice versa.
- Records are free-text items, not linked to menu items, ingredients, expense purchases, or inventory.
- Save/edit/delete are local only; no image/evidence capture exists.

Exact reason labels: Overproduction, Expired, Preparation Mistake, Customer Return, Damaged, Staff Meal, Other. Exact unit labels: kg, g, pcs, portions, litres, other.

### 11.2 Wastage analytics

Period enum supports week, month, and quarter. Snapshots display total estimated loss, percentage change, entry count, comparison label, trend, breakdown by reason, and top wasted items. The screen itself defaults to/focuses on monthly presentation.

Reason-share mocks include Overproduction 46%, Expired 22%, Preparation mistake 16%, Customer return 8%, Damaged 5%, and Other 3%; Staff meal is omitted despite being a valid capture reason. Top-item summaries are separately hardcoded and not derived from the entries list.

Backend definitions must decide whether estimated loss is entered manually or calculated from quantity and cost, what cost basis applies, whether staff meals count as wastage, and how item aliases/free text are grouped.

## 12. Reports and Analytics

### 12.1 Report periods and metrics

Supported report periods are month, quarter, six months, and year. Each snapshot carries revenue, expenses, change percentages, food-cost percentage, chart points, orders, wastage, and comparison labels. Reports derive:

```text
estimated food cost = revenue * food cost percentage / 100
gross profit = revenue - estimated food cost
profit = gross profit - expenses
profit margin = profit / revenue * 100, or 0 if revenue is 0
average order value = revenue / orders, or 0 if orders is 0
```

There is a likely accounting ambiguity: expenses include an Ingredients category while report profit also subtracts estimated food cost. If ingredient purchases are included in `expenses` and food cost is subtracted separately, profit may double-count food costs. Product/accounting rules must decide whether “expenses” on the report excludes COGS categories or whether profit should simply be revenue minus all expenses.

### 12.2 Report components

- Revenue/expense chart uses points whose values are represented in thousands for display.
- Expense breakdown displays category totals/shares/changes.
- Sales channels are hardcoded at 55% Dine-in, 25% Takeaway, 20% Delivery across periods, with period-dependent growth.
- Menu performance, wastage insights, and order behavior are hardcoded summaries.
- Export action is a placeholder; no CSV/PDF generation, download/share, job status, or audit record exists.
- There is no custom date range, day/week report, branch comparison, tax report, cash reconciliation, or drill-through query contract.

### 12.3 Exact mock period totals

| Period | Revenue | Expenses | Food cost | Orders | Wastage |
|---|---:|---:|---:|---:|---:|
| Month | 842,500 | 478,300 | 28.4% | 1,244 | 12,450 |
| Quarter | 2,482,500 | 1,408,300 | 27.9% | 3,684 | 34,800 |
| Six months | 4,772,500 | 2,699,300 | 27.6% | 7,082 | 68,100 |
| Year | 8,812,500 | 4,958,300 | 27.2% | 13,140 | 128,400 |

These snapshots are independent fixtures and cannot be reconciled to the small mock order/expense/wastage collections.

## 13. Business Insights and Recommendations

Current “insights” are deterministic presentation strings rather than stored or generated entities:

- profit-versus-expense messaging conditional on report changes;
- Chicken Burger is popular but has approximately 48% food cost, suggesting cost/price review;
- Delivery is described as the fastest-growing channel;
- dashboard pulse labels sales/profit health and cost warnings;
- menu performance classification supplies a title, explanation, and recommended action.

The backend needs a decision on whether insights are computed synchronously from metrics, generated periodically and stored, or produced by an analytics/AI service. Every insight should have a period, restaurant, rule/version, supporting metric values, severity, generated timestamp, and optional dismissal/action state if it is to behave consistently. Current UI has no confidence, provenance, dismissal, notification, or tracking behavior.

## 14. Profile and Settings

### 14.1 Personal profile

Displayed identity fields are full name, email, phone, and avatar. Personal Information allows editing name and phone; email appears as account identity. All values are mock/local. No repository, Supabase user-metadata update, phone verification, email-change flow, or avatar upload is connected.

### 14.2 Restaurant profile

Edit Restaurant exposes name, business phone, business email, address, city/country, and logo. Required validation is local; business email only checks for `@` and `.`. There is no address structure/geocoding, country/currency coupling, uniqueness rule, audit log, or persistence.

### 14.3 Members and permissions

Current visible roles are Owner and Viewer. Viewer is intended to be read-only. Owners can approve/decline pending join requests, remove a viewer, and rotate a join code in the mock UI. There is no centralized authorization API, permission matrix, route enforcement, optimistic-concurrency handling, or last-owner policy.

### 14.4 Settings not currently modeled

There are no notification settings, locale/timezone, theme, currency change, tax/service-charge settings, data export/delete, privacy consent history, connected providers, security/session list, or accessibility preferences. “Change password” is present but disconnected from the actual auth model.

## 15. Notifications

Notifications are a **placeholder only**. Profile contains a notifications row/affordance and the asset set includes a bell icon, but there is no notification screen, model, unread count, preference screen, token registration, Firebase Messaging usage, local-notification package integration, Supabase realtime notification subscription, or backend endpoint.

Possible future triggers suggested by current workflows—but not implemented—include join-request decisions, new join requests, high-cost warnings, menu/wastage insights, report readiness, and account/security events. The product must decide channels (in-app, push, email), per-event preferences, read/dismiss semantics, recipient role, and deep-link targets before backend implementation.

## 16. Search, Filtering, Sorting, and Pagination

| Area | Search | Filters | Sort | Pagination |
|---|---|---|---|---|
| Order entry menu | Case-insensitive item-name substring | category, Popular | fixed mock order | none |
| Sales | none | period, channel | implicit recent-first | none |
| Sales history | none | selected date | implicit | none |
| Expenses | none | analysis period | implicit | none |
| Expense history | none | date/period, category, type | newest, oldest, highest, lowest | none |
| Menu | none | period, category | revenue descending | none |
| Wastage | none | period | implicit recent-first | none |
| Reports | none | report period | N/A | none |
| Members | none | none | role/mock order | none |

A shared pagination-footer widget exists but is not wired to these feature queries. No cursor/page contract, total count, page size, debounce, server query syntax, or global search exists. Data volumes are presently assumed to be small in memory.

## 17. Data Model Inventory

The table below reflects executable Dart models, not a proposed database schema.

| Model | Exact fields | Derived behavior | Source/status |
|---|---|---|---|
| `MenuItemSnapshot` | `id:String`, `name:String`, `category:String`, `sellingPrice:int`, `estimatedCost:int`, `isPopular:bool=false` | none | sales domain; mock |
| `SalesOrderItem` | `id:String`, `menuItemId:String`, `name:String`, `quantity:int`, `unitPrice:int`, `unitCost:int` | `lineTotal` | sales domain; mock/local |
| `SalesOrder` | `id:String`, `restaurantId:String`, `orderNumber:String`, `orderedAt:DateTime`, `channel:OrderChannel`, `items:List<SalesOrderItem>`, `discount:int=0`, `notes:String?` | subtotal, total, itemCount, estimatedFoodCost | sales domain; mock/local |
| `Expense` | `id:String`, `amount:double`, `category:String`, `description:String`, `date:DateTime`, `type:ExpenseType`, `notes:String?`, `receiptPath:String?` | none | expense domain; mock/local |
| `ExpenseCategorySummary` | `name:String`, `amount:double`, `percentage:double`, `transactionCount:int`, `change:double` | percentage expected 0–1 | mock analytics |
| `ExpenseCategoryDetailsData` | category summary/detail fields, trend and transaction collections | presentation aggregation | mock analytics |
| `ExpenseTrendPoint` | `label:String`, `tooltipLabel:String`, `amount:double` | none | mock analytics |
| `ExpensePeriodSnapshot` | `total`, `change`, `transactions`, `averageDaily`, `comparisonLabel`, `trend` | none | mock analytics |
| `MenuItem` | `id:String`, `name:String`, `category:String`, `sellingPrice:double`, `estimatedCost:double`, `unitsSold:int`, `revenue:double`, `historicalCost:double`, `ordersContainingItem:int`, `notes:String?`, `imagePath:String?` | `foodCostPercentage`, `contributionPerUnit`, `marginPercentage`, `estimatedHistoricalCost`, `estimatedHistoricalContribution` | menu domain; mock/local |
| `MenuItemDetailsData` | `item:MenuItem`, `periodLabel:String`, `demandMultiplier:double` | navigation/presentation wrapper | menu detail route data |
| `WastageEntry` | `id:String`, `itemName:String`, `estimatedLoss:double`, `reason:WastageReason`, `date:DateTime`, `quantity:double?`, `unit:WastageUnit?`, `notes:String?` | quantityLabel | wastage domain; mock/local |
| `WastageTrendPoint` | label/date display plus amount | none | mock analytics |
| `WastageReasonSummary` | `reason`, `amount`, `share` | none | mock analytics |
| `WastedItemSummary` | `name`, `amount`, `entries` | none | mock analytics |
| `WastageSnapshot` | `total`, `change`, `entries`, `comparisonLabel`, `trend` | none | mock analytics |
| `ReportChartPoint` | `label:String`, `revenue:double`, `expenses:double` | values used as thousands | mock analytics |
| `ReportSnapshot` | `period`, `revenue`, `expenses`, `revenueChange`, `expenseChange`, `profitChange`, `marginChange`, `foodCost`, `foodCostChange`, `chartPoints`, `orders`, `wastage`, `wastageChange` | food cost amount, gross profit, profit, margin, AOV | mock analytics |
| `AuthState` | `status:AuthStatus`, `email:String?`, `message:String?` | operation state only | real AuthCubit |
| `AppSessionController` state | `status:AppStatus`; session/user remain available from SupabaseService | navigation/session authority | real |

There is no Dart domain model for UserProfile, Restaurant, Membership, JoinRequest, JoinCode, MenuCategory, ExpenseCategory, Notification, SupportTicket, UploadedAsset, ReportExport, or DashboardPulse. Those concepts exist only as widget-local values or prose.

### 17.1 Modeling inconsistencies

- Sales money is `int`; menu/expense/wastage/report money is `double`.
- Category relationships are names/strings rather than identifiers.
- Wastage uses free-text item name.
- Only SalesOrder carries restaurant tenancy.
- Analytics models mix stored-looking fields with values that should be derived.
- Image/receipt fields are local filesystem paths, unsuitable as durable cross-device references.
- IDs are arbitrary fixture strings; creation commonly uses timestamp-like local values rather than server IDs.
- Report chart values use display-scaled units while headline totals use currency units.

### 17.2 Field nullability registry

| Entity | Non-null fields | Nullable fields |
|---|---|---|
| `MenuItemSnapshot` | id, name, category, sellingPrice, estimatedCost, isPopular | none |
| `SalesOrderItem` | id, menuItemId, name, quantity, unitPrice, unitCost | none |
| `SalesOrder` | id, restaurantId, orderNumber, orderedAt, channel, items, discount | notes |
| `Expense` | id, amount, category, description, date, type | notes, receiptPath |
| `ExpenseCategorySummary` | name, amount, percentage, transactionCount, change | none |
| `ExpenseCategoryDetailsData` | category, period | none |
| `ExpenseTrendPoint` | label, tooltipLabel, amount | none |
| `ExpensePeriodSnapshot` | total, change, transactions, averageDaily, comparisonLabel, trend | none |
| `MenuItem` | id, name, category, sellingPrice, estimatedCost, unitsSold, revenue, historicalCost, ordersContainingItem | notes, imagePath |
| `MenuItemDetailsData` | item, periodLabel, demandMultiplier | none |
| `WastageEntry` | id, itemName, estimatedLoss, reason, date | quantity, unit, notes |
| `WastageTrendPoint` | label, tooltipLabel, amount | none |
| `WastageReasonSummary` | reason, amount, share | none |
| `WastedItemSummary` | name, amount, entries | none |
| `WastageSnapshot` | total, change, entries, comparisonLabel, trend | none |
| `ReportChartPoint` | label, revenue, expenses | none |
| `ReportSnapshot` | period, revenue, expenses, revenueChange, expenseChange, profitChange, marginChange, foodCost, foodCostChange, chartPoints, orders, wastage, wastageChange | none |

## 18. Enums and Fixed-Value Catalog

### 18.1 Authentication/session

- Session statuses: initializing, onboarding, unauthenticated, authenticated.
- `AuthStatus`: `initial`, `requestingOtp`, `otpSent`, `otpRequestFailure`, `verifyingOtp`, `otpVerified`, `otpVerificationFailure`, `googleSignInInProgress`, `googleSignInSuccess`, `googleSignInFailure`, `googleSignInCancelled`.

### 18.2 Sales

- `OrderChannel`: `dineIn` (“Dine-in”), `takeaway` (“Takeaway”), `delivery` (“Delivery”).

### 18.3 Expenses

- `ExpenseType`: `variable` (“Variable”), `fixed` (“Fixed”).
- `ExpensePeriod`: `week` (`1W`), `month` (`1M`), `quarter` (`3M`), `sixMonths` (`6M`), `year` (`1Y`).
- `ExpenseSort`: newest, oldest, highest, lowest.
- Category values are editable strings, not an enum; defaults are listed in section 9.2.

### 18.4 Menu

- `MenuPerformanceStatus`: `star`, `reviewCost`, `promote`, `lowPerformer`, `notEnoughData`.
- `MenuAnalysisPeriod`: month (`1M`), quarter (`3M`), sixMonths (`6M`), year (`1Y`).
- Menu categories are strings/local values.

### 18.5 Wastage

- `WastagePeriod`: week, month, quarter.
- `WastageReason`: overproduction, expired, preparationMistake, customerReturn, damaged, staffMeal, other.
- `WastageUnit`: kg, grams, pieces, portions, litres, other.

### 18.6 Reports/access/support

- `ReportPeriod`: month, quarter, sixMonths, year.
- Visible roles: Owner, Viewer; no shared domain enum exists.
- Membership/request statuses inferred from UI: active and pending; approval/decline/removal actions exist, but no domain enum.
- Support categories: Sales, Expenses, Menu, Reports, Restaurant Pulse, Account, Other.
- Currency is fixed `NPR` / `Rs`; no currency enum or setting.

Fixed labels/date ranges are presentation assumptions. Backend enums should use stable machine values while the client owns localized labels.

## 19. Entity Relationships Inferred from the UI

```text
Auth User
  -> Personal Profile (missing model)
  -> Restaurant Membership (missing model: role/status)
       -> Restaurant (missing model)
            -> Join Code / Join Requests (widget-local)
            -> Menu Categories -> Menu Items
            -> Expense Categories -> Expenses -> Receipt Asset
            -> Sales Orders -> Sales Order Items -> menu-item snapshot/reference
            -> Wastage Entries
            -> Derived Dashboard / Report / Insight projections
            -> Members / Notification recipients
```

Relationship requirements:

- Every operational entity must be restaurant-scoped, even if its current Dart model omits `restaurantId`.
- An order has one or more order lines; a line may reference a menu item but must preserve historical name/price/cost snapshots.
- Expense and menu category deletion/rename must preserve historical records; stable IDs are preferable to name joins.
- Uploaded assets belong to a restaurant and a logical owner record, with access rules and cleanup behavior.
- Membership determines authorization. A user identity alone is insufficient.
- Report/dashboard/insight values are projections over source transactions, not independent editable truths.
- If multi-restaurant membership is allowed, every request and cache key needs an explicit active restaurant.

## 20. Derived Fields and Formula Registry

| Derived field | Current formula/logic | Open issue |
|---|---|---|
| Order line total | quantity × unit price | money type/rounding |
| Order subtotal | sum line totals | included line states |
| Order total | subtotal − discount | cannot go below zero due UI clamp |
| Order item count | sum quantity | whether “items” means units or lines |
| Order estimated food cost | sum quantity × snapshotted unit cost | costing method/effective date |
| Average order value | revenue / order count | counted order statuses |
| Menu food-cost % | cost / selling price × 100 | zero price and precision |
| Menu contribution/unit | selling price − cost | taxes/fees excluded |
| Menu margin % | contribution / selling price × 100 | gross vs contribution terminology |
| Historical contribution | revenue − historical cost | source period and included orders |
| Report estimated food cost | revenue × food-cost % | should instead derive from order lines |
| Report gross profit | revenue − estimated food cost | accounting definition |
| Report profit | gross profit − expenses | risk of ingredient/COGS double count |
| Report margin | profit / revenue × 100 | zero revenue => 0 in UI |
| Expense category share | category amount / period total | zero denominator |
| Wastage reason share | reason loss / total loss | manual vs calculated loss |
| Period change | `(current-prior)/prior × 100` inferred | frontend stores values; zero-prior behavior undefined |
| Menu status | demand threshold + <=40% food cost | multipliers/threshold are heuristic |
| Pulse score | unknown | product definition required |

Unless there is a specific offline UX need, backend responses should be authoritative for aggregate figures and should include raw numerator/denominator or definitions where reconciliation matters. The client may calculate immediate form previews but should not independently redefine report formulas.

## 21. Local Storage, Cache, and Device State

### 21.1 Actually used

- A shared-preferences service persists onboarding completion. This is the only explicit product preference currently stored locally.
- Supabase Auth manages its own client session persistence; AppSessionController reads the restored session through SupabaseService.
- Image picker returns device-local temporary paths during the active form flow.

### 21.2 Present but unused/legacy

- A secure-storage abstraction is registered in dependency injection but no current feature reads or writes business/auth data through it.
- Network service and API endpoint abstractions exist but current operational features do not call them.
- Firebase configuration exists in the repository, but no current notification/business flow uses Firebase.

### 21.3 Missing cache semantics

There is no offline database, stale-while-revalidate policy, mutation queue, optimistic update reconciliation, cache versioning, logout cleanup of business data, per-restaurant cache separation, or conflict resolution. Mock collections are rebuilt in memory and disappear on restart. Durable image paths are not copied into application storage or uploaded.

Backend integration should explicitly decide whether RestroPulse is online-only. If caching is introduced, switching/signing out must prevent one restaurant's data from appearing under another session.

### 21.4 File and image requirements

| Asset purpose | UI location | Accepted/visible constraint | Current behavior | Durable storage need |
|---|---|---|---|---|
| User avatar | Personal Information/Profile | no executable type/size rule | affordance does not pick/upload | likely persistent if feature retained |
| Restaurant logo | Create/Edit Restaurant, shell header | gallery/camera choices shown; no enforced limits | chooser closes without selection | persistent restaurant-scoped image |
| Menu-item image | Menu item form/details | copy says JPG/PNG; picker max width 1200, quality 85 | local temporary path only; MIME not checked | persistent item image with replacement/deletion semantics |
| Expense receipt | Expense form/details | picker max width 1400, quality 85; no MIME/size check | local temporary path only | private restaurant financial attachment |
| Support screenshot | Report Problem | optional screenshot affordance | not wired | persistent/private only if tickets are implemented |
| Report PDF/CSV | Reports export | PDF or CSV selected | no output generated | generated downloadable object if export retained |

Bundled logos, onboarding art, and menu fixture images under `assets/` are application resources, not user uploads. The backend contract will need a durable asset identifier/URL rather than `imagePath`/`receiptPath` device paths, plus upload progress, replacement, failed-upload recovery, access, retention, and orphan-cleanup behavior.

## 22. Realtime Requirements

Only authentication state is realtime today. `AppSessionController` listens to Supabase auth events and refreshes GoRouter.

No operational realtime subscriptions exist. Potential needs inferred from UI:

- owner sees a new join request;
- requester sees approval/decline/removal;
- multiple restaurant devices see new/edited/deleted sales, expenses, menu items, wastage, categories, and member changes;
- dashboard/report caches invalidate after mutations;
- notification unread state updates.

Realtime is not automatically required for all of these; refetch-on-focus or explicit refresh may be sufficient for an initial release. If enabled, events need restaurant scoping, deduplication with optimistic writes, ordering/version semantics, delete handling, reconnection recovery, and permission revalidation after membership removal.

## 23. Mock Data and Placeholder Audit

### 23.1 Real integrations

- Supabase initialization and Auth session operations.
- Email OTP request/verification.
- Google native sign-in token acquisition and Supabase token exchange, subject to environment/platform configuration.
- Onboarding completion in shared preferences.
- Gallery image selection where wired.

### 23.2 Mock/in-memory business data

- Dashboard pulse and all dashboard metrics.
- All sales orders, history summaries, menu snapshots, and save/edit/delete behavior.
- All expenses, categories, trends, summaries, history, and receipts after selection.
- All menu items, categories, performance analytics, and image persistence.
- All wastage entries and analytics.
- Every report number/chart/breakdown/insight.
- Profile and restaurant identity.
- Members, roles, join code, requests, approval/removal.
- Restaurant creation/join preview/submission.

### 23.3 Explicit placeholders

- OTP resend.
- Report export.
- Support email action, screenshot attachment, and report submission.
- Notification destination/behavior.
- Restaurant/profile logo and avatar selection on several screens.
- Password change backend.
- Most refresh animations use fixed delays.

### 23.4 Important fixture inconsistencies

- Dashboard says 142 orders/Rs 201 AOV today; Sales says 42/Rs 677.
- Tiny transaction fixture lists cannot produce report totals.
- Expense local mutation does not update analytics fixtures.
- Menu category counts do not match the six menu fixtures.
- Wastage reason summaries/top items do not derive from the three entries, and Staff meal is absent.
- All report periods reuse fixed channel proportions.
- Dates and labels are pinned around August 2026 rather than current/runtime time.

### 23.5 Mock dataset source map

| Location | Dataset/entity | Representative fields/values | Principal consumers |
|---|---|---|---|
| `lib/src/features/sales/domain/models/sales_order.dart` | `SalesMockData.menuItems`, `todayOrders` | five menu snapshots; three restaurant-1 orders `#0040`–`#0042`, item snapshots, channel, discount, notes | OrderEntry, SalesScreen, SalesHistory, OrderDetails fallback |
| `lib/src/features/sales/presentation/widgets/sales_trend_data.dart` | `SalesTrendMockOrders` | generated order-level timestamps/totals for trend periods | Sales trend/chart widgets |
| `lib/src/features/expenses/domain/models/expense.dart` | `ExpensesMockData`, `ExpenseCategories.defaults` | five expenses; period totals/trends; category totals/shares/change; eleven default categories | Expenses, history, details, category breakdown/detail/forms |
| `lib/src/features/menu/domain/models/menu_item.dart` | `MenuMockData.items`, period scaling | six items with current price/cost and historical units/revenue/cost/orders; period multipliers | Menu list, details, forms, performance widgets |
| `lib/src/features/wastage/domain/models/wastage.dart` | `WastageMockData` | three entries, reason summaries, four top items, week/month/quarter snapshots | Wastage list, form/detail fallback, charts |
| `lib/src/features/reports/domain/models/report_data.dart` | `ReportsMockData` | four report snapshots with totals, changes, food cost, orders, wastage, chart points | ReportsScreen and report widgets |
| `lib/src/features/dashboard/presentation/widgets/` | literal dashboard values | pulse 84, Rs 28,450 revenue, 142 orders, 28.4% food cost | DashboardScreen |
| `lib/src/features/profile/presentation/` | widget-private profile/restaurant/member fixtures | Boys to Serve, Pratik Gurung, members, join code | Profile and settings screens |
| `lib/src/features/restaurant_access/presentation/` | restaurant setup/join fixtures | NPR, Boys to Serve preview, pending-request content | create/join/access screens |

Mock values are compiled Dart fixtures rather than JSON. No seed/sample JSON or local business database was found in the active feature flow.

## 24. Backend Dependency Matrix

Priority uses **P0** for authentication/tenancy and source transactions, **P1** for essential product completion, and **P2** for later/optional capabilities.

| Frontend area | Required backend capability | Read | Write | Realtime | Files | Priority | Notes |
|---|---|:---:|:---:|:---:|:---:|:---:|---|
| Startup/session | restore session, user authorization/membership bootstrap | Yes | No | Auth | No | P0 | Must distinguish authenticated from restaurant-authorized |
| Email OTP | request and verify OTP | Minimal | Yes | Auth | No | P0 | Already Supabase-backed |
| Google auth | provider token exchange | Minimal | Yes | Auth | No | P0 | Already Supabase-backed; configure each environment |
| User profile | load/update profile metadata | Yes | Yes | Optional | Avatar | P1 | Missing domain model |
| Restaurant access | list/create restaurant, active restaurant selection | Yes | Yes | Optional | Logo | P0 | Multi-restaurant decision required |
| Join flow | resolve code, request membership, status | Yes | Yes | Useful | No | P0/P1 | Avoid leaking private restaurant data during preview |
| Members | list members/requests, approve/decline/remove, rotate code | Yes | Yes | Useful | No | P1 | Owner authorization and race handling |
| Dashboard | period-aware aggregate endpoint | Yes | No | Optional | No | P1 | Pulse algorithm unresolved |
| Sales | order CRUD, history/query, order numbering | Yes | Yes | Optional | No | P0 | Idempotent create and immutable snapshots |
| Menu | item/category CRUD, performance query | Yes | Yes | Optional | Item image | P0/P1 | Archive rather than destructive historical delete |
| Expenses | expense/category CRUD, history/analytics | Yes | Yes | Optional | Receipt | P0 | Decimal/minor-unit policy |
| Wastage | entry CRUD, history/analytics | Yes | Yes | Optional | Optional future | P0/P1 | Free-text versus catalog linkage |
| Reports | aggregate snapshots and drilldowns | Yes | No | No | Export output | P1 | Accounting definitions are prerequisite |
| Insights | calculate/list insight rules/results | Yes | Optional | Optional | No | P2 | Can initially derive in report response |
| Notifications | events, inbox, read state, preferences, push registration | Yes | Yes | Yes | No | P2 | No current UI implementation |
| Support | create support ticket | Yes | Yes | No | Screenshot | P2 | Need lifecycle/contact semantics |
| Export | generate/download/share report | Yes | Yes/job | Optional job | PDF/CSV | P2 | Placeholder only |

### 24.1 CRUD-oriented dependency view

| Feature | Reads | Creates | Updates | Deletes | Derived/Analytics | File Storage | Realtime |
|---|---|---|---|---|---|---|---|
| Authentication | session/user/provider state | auth user/session via OTP or Google | session refresh/provider state | sign-out session; account deletion absent | none | none | auth-state listener implemented |
| Profile | personal profile | profile on first use, implied | name/phone/avatar, implied | not implemented | none | avatar | optional |
| Restaurant | active restaurant/details/settings | restaurant + owner relation | business details/settings | not implemented | member counts | logo | optional |
| Membership/join | members, requests, code preview/status | join request/code | approval/status/role/code rotation | decline/remove/revoke | member/request counts | none | useful |
| Menu | items/categories/performance | item/category | item/category/archive | UI offers delete | margins, units, revenue, status | item image | optional |
| Sales | orders/lines/history/menu snapshots | single/batch order | order editing | UI offers delete | revenue, counts, AOV, channel/trends/cost | none | optional |
| Expenses | expenses/categories/history | expense/category | expense/category | expense/custom category | totals, trends, shares, comparisons | receipt | optional |
| Wastage | entries/reasons/top items | entry | entry | entry | totals, trends, shares, comparisons | none currently | optional |
| Dashboard | source aggregates | none | none | none | pulse and daily KPIs | none | refresh/invalidation useful |
| Reports | cross-domain aggregates | export job only, future | none | none | all report calculations/insights | PDF/CSV output | generally unnecessary |
| Notifications | inbox/preferences/device state | device registration/event delivery state | read/preferences/token | dismiss/token removal | unread counts | none | expected if implemented |
| Support | FAQ/ticket status, future | support ticket | ticket lifecycle, likely backend-side | none exposed | none | screenshot | not required |

## 25. Backend Data Required by Screen

| Screen | Data/query required | Mutation required | Current fallback |
|---|---|---|---|
| Splash/Onboarding | onboarding local flag; session + memberships | mark onboarding locally | shared preference + session controller |
| Auth | auth provider configuration/error mapping | OTP request; Google sign-in | real Supabase/Google |
| Verify OTP | email/challenge context, resend cooldown | verify/resend | verify real; resend absent |
| Restaurant Access | current memberships and pending requests | none | static options |
| Create Restaurant | currencies/settings defaults | create restaurant + owner membership + optional logo | fake save |
| Join Restaurant | safe code preview/status | create/cancel join request | one static preview |
| Dashboard | today/prior metrics, food-cost target, pulse/insights | none | hardcoded |
| Sales | period totals, trends, recent/history orders, channels | create/edit/delete/cancel order | mock orders/local |
| Order Entry/Batch | active menu snapshots/categories, next numbering policy | create one/many orders | local basket/fake save |
| Order Details | order with line snapshots | edit/delete | route extra/local |
| Expense screens | expenses, categories, period analytics | CRUD expense | mock/local |
| Expense Categories | categories and usage counts | create/rename/delete/archive | private list |
| Menu screens | items/categories, analytics by period | CRUD/archive items/categories | mock/local |
| Wastage screens | entries and aggregates by period/reason/item | CRUD entry | mock/local |
| Reports | snapshot, chart, breakdowns, comparisons, definitions | request export | fixture/export placeholder |
| Profile | authenticated profile, active restaurant, role | update profile/avatar, sign out | mock + real signout |
| Edit Restaurant | restaurant details | update details/logo | mock form |
| Members Access | code, members, pending requests | rotate code, decision, remove | private lists |
| Change Password | provider capabilities/session recency | password update | snackbar only |
| Help/Report Problem | FAQ/config and ticket history | create ticket/attachment | static FAQ/fake submit |

## 26. Validation and Business-Rule Catalog

### 26.1 Frontend-enforced today

- Email is trimmed before OTP request; format is not formally validated.
- OTP field is numeric and at most six characters; exact length is not enforced before request.
- Restaurant name/location are required; join code is allowed-character filtered and minimum six.
- Order requires at least one item; quantity is positive through controls; discount is digit-only and at most subtotal.
- Expense amount >0, maximum two decimals; high-value warning at Rs 100,000; category and description required.
- Custom expense category nonblank and case-insensitively unique locally.
- Menu name/category required; price >0; cost >=0; price/cost allow two decimals.
- Wastage item/reason/loss required and loss >0; quantity/unit pairing is incomplete.
- Personal/restaurant form fields are locally required as described; restaurant email has a minimal shape check.
- New password minimum eight with at least one letter/number, differs from current, and confirmation matches—but mutation is absent.
- Support category/subject/description required.

### 26.2 Must also be server-enforced

- Tenant membership and role on every operation; frontend visibility is never authorization.
- Nonnegative/precision/currency constraints and valid enum values.
- At least one order line, positive quantities, consistent totals, discount limits, and menu snapshot ownership.
- Idempotent submission for orders/expenses/wastage and conflict/version handling for edits.
- Category uniqueness within a restaurant and safe archive/delete dependencies.
- Join-code validity, expiration/revocation, duplicate request/member detection, and owner-only decisions.
- File type, size, ownership, malware/content policy as appropriate, and association authorization.
- Date validity under restaurant timezone and no reliance on hardcoded frontend maximum dates.
- Report inputs derived from authorized source records rather than client-supplied aggregates.

### 26.3 Rules requiring product decisions

- Tax/service charge/refunds/cancellations and what constitutes revenue.
- Cash versus accrual expense accounting and COGS treatment.
- Whether viewers can export, inspect members, see receipts, or see all financial details.
- Restaurant and membership multiplicity.
- Order-number uniqueness/reset scheme.
- Deletion versus archival and retention.
- Wastage cost basis and staff-meal treatment.
- Pulse score and comparison-period definitions.

## 27. Edge Cases and Failure Modes

### Authentication/session

- OTP email may be lost if AuthCubit is recreated, app restarts, or verify route is deep-linked; route extra is ignored.
- Wrong OTP may be reported by Supabase as `otp_expired`; frontend intentionally maps this to “incorrect or expired,” because the provider does not reliably distinguish them.
- Rapid success navigation plus a dialog/route pop can pop a route already removed by GoRouter.
- AuthCubit can emit after close if a long-running request completes after its provider is disposed; app-scoping avoids the normal auth->verify case, but async methods should still guard lifecycle where ownership can change.
- Splash timer and session redirect can race.
- Authenticated users without a restaurant reach dashboard.
- Google failures are overly generic and hard to diagnose in UI.

### Authorization/data isolation

- Viewer read-only status is not enforced.
- Route extras may contain objects from a prior restaurant/session unless caches/navigation stacks are cleared.
- Membership revocation while app is open has no operational subscription/guard.
- Join-code preview could expose restaurant metadata if backend returns too much.

### Transactions and analytics

- Double taps can duplicate a save; no idempotency token.
- Concurrent edits/deletes have no version conflict behavior.
- Menu price/cost changes must not rewrite historical order economics.
- Expense category rename/delete can orphan string-based history.
- Local totals and report aggregates can diverge due independent fixtures/caches.
- Zero prior totals make percentage change undefined; current behavior is unspecified.
- Currency rounding differs because models mix int/double.
- Restaurant timezone/day cutoff can move orders between “today” and period reports.
- Report profit may double-count ingredient costs.
- Empty, partial, very large, negative/refund, and future-dated datasets are not represented.

### Files/device/network

- Temporary local image paths can disappear and cannot sync across devices.
- Picker cancellation/recovery is partly supported centrally, but uploads/retries/progress are absent.
- No offline mutation policy or error recovery beyond feature messages.
- Sign-out cache cleanup is undefined.

### Navigation

- Detail routes require typed `extra`; browser/deep links/state restoration cannot reconstruct them.
- No explicit error/not-found screen.
- Repeated redirect logs are expected when the notifier/router reevaluates, but competing manual navigation can make it unsafe.

## 28. Implementation Status and Architecture Audit

### 28.1 Layer status

| Concern | Status | Evidence |
|---|---|---|
| Bootstrap/config | Implemented | `lib/bootstrap.dart`, `.env` loading, Supabase initialization |
| Dependency injection | Implemented for auth/core | `lib/src/core/di/`; operational features have no repositories |
| Auth data/domain/presentation | Implemented | service -> datasource -> repository -> use case -> AuthCubit -> UI |
| Session/navigation | Implemented with noted races/gaps | `AppSessionController`, `app_router.dart` |
| Onboarding preference | Implemented | local preference service |
| Sales domain/backend | Models and UI only | mock data + local form state |
| Expenses domain/backend | Models and UI only | mock data + local form state |
| Menu domain/backend | Models and UI only | mock data + local form state |
| Wastage domain/backend | Models and UI only | mock data + local form state |
| Reports/dashboard | Presentation fixtures | no query/use case/repository |
| Restaurant/profile/members | Presentation fixtures | widget-local models/values |
| File storage | Picker only | no durable upload/reference layer |
| Notifications/support/export | Placeholder | no backend/domain implementation |

### 28.2 State management status

- AuthCubit is app-scoped and contains the meaningful authentication operation flow.
- SignOutCubit is route/profile scoped.
- ImagePickerBloc is a reusable event-driven picker abstraction.
- AppSessionController is an app-lifetime ChangeNotifier used by GoRouter.
- Feature Blocs for dashboard, main, profile, splash, reports, menu, expenses, sales, and onboarding are largely empty TODO shells and are not evidence of implemented business state.
- Most operational screens use `StatefulWidget`, private lists, direct fixture imports, and fixed delays.

### 28.3 Static-analysis state at audit time

The current `lib/` source has no known compile-stopping analyzer errors from the reviewed run, but includes low-level lint warnings such as an unused AuthCubit import in the router and placeholder Blocs importing `bloc` directly without declaring it as a direct dependency. A full-repository `flutter analyze` reports approximately 128 issues primarily because stale tests reference removed legacy auth classes/screens and older state APIs. Those tests are not aligned with the current OTP-only flow and should not be treated as proof that the executable app layer is broken, but they do mean the repository is not analysis-clean.

### 28.4 Architectural assessment

The authentication slice follows the project's pragmatic Clean Architecture correctly. Extending the same boundary to operational features is appropriate where real persistence begins: UI -> Cubit/Bloc -> use case -> repository -> datasource. Do not create separate layers merely for static labels or trivial derived display logic. Aggregation-heavy dashboard/report queries can use purpose-built read models rather than loading every transaction into the client.

The largest delivery risk is not missing Flutter scaffolding; it is unresolved business semantics. Tenancy/role enforcement, accounting definitions, historical costing, period/timezone rules, and aggregate consistency must be settled before API contracts.

### 28.5 Feature-level status audit

| Feature | Status | Evidence | Backend Needed |
|---|---|---|---|
| Launch/onboarding | Complete frontend | animations/routes; shared preference completion | only if onboarding becomes account-scoped |
| Email OTP auth | Complete frontend | real AuthCubit/use cases/repository/Supabase calls | Supabase project/email configuration |
| OTP resend/recovery | Placeholder | visible resend callback is empty; no restart recovery | resend policy/challenge continuity |
| Google auth | Complete frontend | Google SDK tokens exchanged with Supabase | provider/platform/environment configuration |
| Session/auth guard | Partial frontend | app-lifetime controller and redirects work | authorized membership bootstrap missing |
| Restaurant create/join | UI/mock only | validated forms, delays, static preview | restaurant/membership/join persistence |
| Member access/roles | UI/mock only | private lists/code/request actions | authorization and membership lifecycle |
| Dashboard | UI/mock only | all values literal widget data | aggregate query and pulse definition |
| Sales/order entry | UI/mock only | itemized composer and local fixtures | order/menu reads and CRUD/history |
| Expense management | UI/mock only | forms/local fixtures/local mutation | category/expense CRUD, receipts, analytics |
| Menu management | UI/mock only | forms/fixtures/calculations | category/item CRUD, image, sales-derived performance |
| Wastage | UI/mock only | form/fixtures/local mutation | entry CRUD and analytics |
| Reports | UI/mock only | complete fixture-driven report UI | authoritative aggregate queries |
| Report export | Placeholder | PDF/CSV sheet only | generation/delivery if retained |
| Personal/restaurant settings | UI/mock only | local forms/snackbar | profile/restaurant read/update and assets |
| Change password | Placeholder | validation and snackbar only | product decision first; auth flow is passwordless |
| Notifications | Not implemented | only row/icon/wording | full notification capability if in scope |
| Help FAQ | Complete frontend | static expandable copy | none unless CMS desired |
| Report a problem | Placeholder | validated form and fake delay | ticket/attachment handling |
| Search/filter/sort | Partial frontend | local controls in selected screens | server queries/index-aware contracts |
| Pagination/offline sync | Not implemented | footer unused; no durable business cache | decide based on scale/offline scope |

## 29. Backend Design Questions Requiring Answers

### Identity and tenancy

1. Can a user own/join multiple restaurants? If yes, how is the active restaurant selected and persisted? **Why:** this determines membership cardinality and the tenant context of every query.
2. Must every authenticated user complete a profile, and which auth-provider metadata seeds it? **Why:** auth identity currently does not supply all displayed profile fields.
3. Can a restaurant have multiple owners? How are ownership transfer and last-owner removal handled? **Why:** owner lifecycle must not leave a restaurant unmanaged.
4. Are roles only Owner/Viewer, or will manager/cashier/accountant/custom permissions exist? **Why:** the role model controls authorization granularity and future compatibility.
5. Exactly what may a Viewer read: revenue, profit, receipts, members, restaurant settings, exports? **Why:** “read-only” defines mutation rights but not sensitive-data visibility.
6. Can a pending/removed/suspended member retain any cached or historical access? **Why:** revocation and cache cleanup must enforce the same access lifecycle.
7. What join-code format, expiration, rate limits, rotation, and preview data are allowed? **Why:** these rules affect abuse prevention and restaurant-information exposure.

### Restaurant configuration

8. Is currency permanently NPR or configurable per restaurant? Can it ever change after transactions exist? **Why:** money interpretation and historical reporting require an immutable currency context.
9. What timezone, week start, and business-day cutoff define “today” and report periods? **Why:** every date filter, total, and comparison depends on identical boundaries.
10. Are branches/locations required now or expected later? **Why:** retrofitting branch tenancy after transactions exist is structurally significant.
11. Are tax/VAT, service charge, tips, and inclusive/exclusive pricing in scope? **Why:** the current order total cannot represent or report them.
12. Is the food-cost target fixed at 30% or restaurant-configurable? **Why:** dashboard warnings and performance classification need one authoritative threshold.

### Sales

13. Are entries actual customer orders, aggregate daily totals, or both? The FAQ and executable UI disagree. **Why:** these require different source entities and analytics capabilities.
14. Which order lifecycle states exist, and which count toward revenue/orders? **Why:** totals cannot be reconciled without inclusion rules.
15. How do refunds, cancellations, voids, discounts, complimentary items, and corrections work? **Why:** each changes revenue, audit history, and report interpretation.
16. Is order numbering global, per restaurant, per day, or per device, and can offline devices create orders? **Why:** uniqueness and concurrency behavior depend on its scope.
17. Must order lines snapshot price, cost, name, category, and tax at creation? **Why:** mutable menu data must not rewrite historical sales.
18. What costing method determines unit cost: manually estimated, recipe-standard, average inventory cost, or another method? **Why:** food cost, profit, and menu performance all depend on that value.

### Expenses and accounting

19. Are expenses cash-based or accrual-based? Is there a paid/approved/vendor status? **Why:** period attribution and workflow fields differ materially.
20. Are Ingredients expenses part of report operating expenses, COGS, or excluded when estimated food cost is subtracted? **Why:** current report math otherwise appears to double-count food cost.
21. Are expense types properties of transactions, category defaults, or immutable categories? **Why:** the UI currently lets category suggestions and transaction choices coexist.
22. Can categories be archived/merged, and what happens to historical labels? **Why:** name-based current models can break historical grouping.
23. Are recurring expenses, vendors, payment methods, taxes, and receipt OCR required? **Why:** none exists in the current model, so adding them later changes capture and reporting.
24. What precision and storage representation should all money use? **Why:** current `int`/`double` inconsistency risks rounding and reconciliation errors.

### Menu and wastage

25. Is a menu item deletable or only archivable once referenced by an order? **Why:** historical line references and analytics must survive catalog removal.
26. Are recipes/ingredients, modifiers, variants, availability, channel pricing, and effective-dated prices in scope? **Why:** each changes the menu/order boundary beyond the current flat item.
27. Should menu performance thresholds remain fixed or be relative/configurable? **Why:** persisted/generated classifications need stable, explainable rules.
28. Should wastage link to ingredients, menu items, inventory, or remain free text? **Why:** this determines grouping quality and referential relationships.
29. Is estimated loss manual or computed; which cost basis and units/conversions apply? **Why:** analytics cannot compare losses consistently without a valuation rule.
30. Does Staff meal count as wastage and as an expense/benefit elsewhere? **Why:** the enum and current breakdown already disagree about its treatment.

### Analytics, operations, and platform

31. What is the exact Restaurant Pulse formula, weighting, minimum-data behavior, and versioning policy? **Why:** the headline score has no inferable implementation.
32. What are exact comparison periods and zero-baseline percentage-change semantics? **Why:** all growth/change labels need consistent calculation.
33. Must dashboards be realtime, eventually consistent, or generated on demand? **Why:** freshness expectations determine loading, invalidation, and cost constraints.
34. Are reports computed directly, from maintained aggregates, or asynchronously materialized? **Why:** data volume and acceptable freshness affect the contract exposed to Flutter.
35. Which export formats, contents, permissions, retention, and delivery methods are required? **Why:** the visible PDF/CSV choice currently has no defined artifact lifecycle.
36. Which notification events/channels/preferences are required for the first release? **Why:** no notification domain exists and each channel needs different user/device data.
37. What file size/types/retention/access rules apply to logos, avatars, item images, receipts, and support screenshots? **Why:** current pickers enforce almost none of the durable-storage contract.
38. Is offline read/write required? If yes, what conflict and idempotency strategy is acceptable? **Why:** current app has no business cache or mutation queue.
39. What audit history is required for financial edits, deletes, access changes, and join-code rotation? **Why:** destructive and security-sensitive actions are currently modeled without history.
40. What data retention, account deletion, restaurant deletion, backup, and regulatory requirements apply? **Why:** deletion behavior and dependencies cannot be safely inferred from screens.

## 30. Source-of-Truth Entity List

This is a conceptual ownership list for backend planning—not a generated schema.

### Definitely persistent

- Auth identity/session (managed by the authentication provider).
- User profile if the displayed name/phone/avatar are retained.
- Restaurant and restaurant membership.
- Join code/request while the current approval UX exists.
- Menu category/item, sales order/line, expense category/expense, and wastage entry.
- Durable metadata for every uploaded asset actually associated with those records.

### Probably persistent

- Notification inbox/preferences/device registrations if notifications ship.
- Support tickets and screenshot references if in-app support submission ships.
- Export job/output records if report generation is asynchronous.
- Insight dismissal/action history if insights become interactive.

### Derived / should likely be computed

- Dashboard summaries, Restaurant Pulse, report snapshots, trend/chart points, changes, category/channel shares, AOV, profit/margin, food-cost metrics, top/ranked items, menu status, and insight text/supporting evidence.

### UI-only / temporary state

- Form drafts unless draft recovery is explicitly added; current filters/tabs; loading/error state; local picker result before upload; transient confirmation-dialog state; batch-entry composer state before submission.

### Authoritative source entities

- **Auth identity/session:** external auth provider/Supabase Auth remains authoritative for authentication identifiers and sessions.
- **User profile:** product identity fields not guaranteed by auth provider (display name, phone, avatar reference, onboarding/profile-completion state as needed).
- **Restaurant:** business identity and settings, including currency/timezone once decided.
- **Restaurant membership:** user-restaurant relation, role, lifecycle status, timestamps, inviter/approver.
- **Join code and join request:** restaurant invitation mechanism and approval workflow.
- **Menu category and menu item:** current operational catalog; use stable IDs and archival semantics.
- **Sales order and order line:** transactional sales source; line snapshots preserve historical economics.
- **Expense category and expense:** transactional operating-cost source.
- **Wastage entry:** transactional loss source, with linkage strategy still to decide.
- **Stored asset metadata:** durable references for images/receipts/attachments; object storage owns bytes.
- **Support ticket:** only if in-app reporting is a supported product workflow.
- **Notification/preference/device registration:** only when notification behavior is implemented.

### Derived/read-model entities or responses

- Dashboard summary and Restaurant Pulse.
- Sales/expense/menu/wastage period summaries and trend points.
- Report snapshot, channel breakdown, category breakdown, and comparisons.
- Business insight/recommendation.
- Category usage counts, top items, average order value, margins, changes.
- Export job/output metadata if exports are asynchronous.

Derived responses should carry a restaurant ID, period boundaries, timezone/currency, generated/as-of time, and metric-definition version when relevant. They must reconcile to authoritative transactions under documented inclusion rules.

### Client-local-only state

- Unsaved form values, current picker result, tab/filter selections, transient loading/error flags.
- Onboarding completion may remain device-local if product intentionally wants per-install onboarding; otherwise it belongs to user preferences.
- Do not treat current fixture totals, August 2026 labels, local file paths, or widget-private member/category lists as authoritative.

## Backend Handoff Summary

RestroPulse currently has a coherent, real authentication/session slice and an extensive high-fidelity operational frontend driven almost entirely by fixtures. The intended product records restaurant sales, expenses, menu economics, and wastage, then turns them into dashboard/report metrics and recommendations. The backend should be designed around restaurant-scoped source transactions and membership-based authorization, with aggregate read models derived consistently from those sources.

### Build first

1. Resolve single-versus-multi-restaurant behavior, Owner/Viewer authorization, active restaurant bootstrap, and join approval semantics.
2. Define money representation, timezone/business-day boundaries, sales inclusion rules, expense/COGS accounting, historical item costing, and deletion/archive policies.
3. Implement restaurant/profile/membership and the P0 source domains: menu catalog, sales orders/lines, expense categories/expenses, and wastage entries.
4. Replace route-object extras with identifier-based loading for durable detail/deep-link flows.
5. Provide period-aware aggregate read contracts used consistently by dashboard, histories, and reports.
6. Add file upload contracts for the specific screens that actually need durable assets.

### Do not infer from the current fixtures

- The pulse score formula.
- That a user can have only one restaurant forever.
- That NPR and a 30% target are permanent global constants.
- That hardcoded August 2026 ranges/comparisons are product rules.
- That report totals can be stored independently without reconciliation.
- That Viewer visibility equals backend authorization.
- That item/category names are safe relational identifiers.
- That temporary device paths are durable file references.

### Integration sequencing recommendation

After the foundational decisions, integrate one vertical source domain at a time using the existing project flow (`Widget -> Cubit/Bloc -> Use Case -> Repository -> Data Source`). Menu should precede order entry because sales lines depend on menu snapshots; restaurant/membership must precede every business feature. Expenses and wastage can follow independently. Dashboard/reports should be integrated only after their source data and accounting definitions are stable. Notifications, support tickets, and exports are later capabilities because the current frontend exposes them only as placeholders.

This document deliberately stops at frontend-derived requirements and conceptual sources of truth. It does not prescribe Supabase tables, SQL, migrations, RLS policies, storage buckets, indexes, triggers, functions, or RPCs.
