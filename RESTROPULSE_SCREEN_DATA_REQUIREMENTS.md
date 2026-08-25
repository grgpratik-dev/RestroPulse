# RestroPulse Screen Data Requirements

> Current-code snapshot analyzed: 2026-08-25
>
> Scope: backend-driven data displayed or selected by the currently implemented Flutter screens. This is a frontend requirements inventory, not a backend design.

## 1. Reading This Document

The executable widgets, route-mounted screens, domain models, local state, and compiled mock datasets under `lib/` are the source of truth. A field is included when the current UI displays it, uses it to populate a selector, or derives a visible value from it.

Current source labels mean:

- **Literal UI:** value is embedded directly in a widget.
- **Mock model:** value comes from a compiled Dart fixture/model.
- **Local state:** value is created or edited only within the active screen/navigation flow.
- **Real service:** value is connected to an external or durable service.
- **Placeholder:** the screen or control is visible but does not load data.

All dates and values below are the current fixed examples where the UI provides them. They are documented because they reveal field shape and presentation behavior; they are not described as live data.

## 2. Coverage Summary

| Area | Implemented screens covered | Current data source |
|---|---|---|
| Dashboard | DashboardScreen | Literal UI values |
| Sales | SalesScreen, SalesHistoryScreen, OrderEntryScreen/Batch Entry, OrderDetailsScreen | `SalesMockData`, `SalesTrendMockOrders`, local composer state |
| Expenses | ExpensesScreen, ExpenseHistoryScreen, ExpenseCategoryDetailsScreen, ExpenseDetailsScreen, ExpenseFormScreen, ExpenseCategoriesScreen | `ExpensesMockData`, local lists/forms |
| Menu/Menu Performance | MenuScreen, MenuItemDetailsScreen, MenuItemFormScreen, MenuCategoriesScreen | `MenuMockData`, calculated fields, local lists/forms |
| Wastage | WastageScreen, WastageDetailsScreen, WastageFormScreen | `WastageMockData`, local lists/forms |
| Reports | ReportsScreen | `ReportsMockData` plus report widget literals/helpers |
| Restaurant/Profile | RestaurantAccessScreen, CreateRestaurantScreen, JoinRestaurantScreen, ProfileScreen, PersonalInformationScreen, EditRestaurantScreen, ChangePasswordScreen | Literal UI and local form state; sign-out is real |
| Members/Join Requests | MembersAccessScreen and JoinRestaurantScreen pending state | Private in-memory records |
| Notifications | Profile notification row only | Placeholder; no notification data model or screen |

## 3. Dashboard

### 3.1 DashboardScreen — `/dashboard`

**Current source:** literals in `lib/src/features/dashboard/presentation/widgets/`; no dashboard domain model, repository, or active DashboardBloc data flow.

**Screen context and date scope**

- Revenue and operational metrics are labeled for **today**.
- Revenue comparison is explicitly **vs yesterday**.
- Pulse score comparison is explicitly **vs last week**.
- No date picker, period selector, restaurant selector, sort, or filter is rendered.

**Displayed fields and metrics**

| Section | Displayed field | Current loaded value | Visible comparison/context |
|---|---|---:|---|
| Restaurant Pulse | score | 84 | score is rendered inside a heart graphic |
| Restaurant Pulse | health label | Excellent Health | categorical interpretation of score |
| Restaurant Pulse | score change | +4 points | vs last week |
| Restaurant Pulse | Sales factor | Strong | health-factor label |
| Restaurant Pulse | Profitability factor | Healthy | health-factor label |
| Revenue | Today's Revenue | Rs 28,450 | +12.4% vs yesterday |
| Metric grid | Orders | 142 | +7.2% |
| Metric grid | Avg. Order | Rs 201 | +4.8% |
| Metric grid | Est. Profit | Rs 7,650 | -2.1% |
| Metric grid | Food Cost | 28.4% | Target <30% |
| Attention insight | title | Food cost is approaching your target | warning state |
| Attention insight | explanation | Food cost is currently 28.4%. Your target is below 30%. | links to Menu through “Review Costs” |

**Alternate data states**

- `DashboardViewState.loaded`: all values above.
- `empty`: Pulse invites the user to add first sales/expense data; numeric values become em dashes; attention insight is hidden.
- `partial`: revenue/orders/average order remain shown; estimated profit becomes “Not enough data” with “Add Expenses”; food cost becomes unavailable.
- `loading`: skeleton only.
- `error`: error card with Try Again callback.
- `AttentionInsightCard` also supports an `isHealthy` variant displaying “Everything looks healthy” and “No major issues need your attention today,” although DashboardScreen uses the warning variant by default.

**Aggregations and implied visible calculations**

- Average order is displayed as a metric, but Dashboard does not calculate it in code.
- Estimated profit, food-cost percentage, pulse score, comparisons, and health labels are supplied as literals; no formula is implemented on this screen.
- No chart is rendered.

**Important current inconsistency:** SalesScreen displays the same Rs 28,450 day as 42 orders and Rs 677 average order; Dashboard displays 142 orders and Rs 201.

## 4. Sales

### 4.1 Current sales models and fixtures

Primary source: `lib/src/features/sales/domain/models/sales_order.dart`.

| Model | Fields consumed by screens |
|---|---|
| `MenuItemSnapshot` | id, name, category, sellingPrice, estimatedCost, isPopular |
| `SalesOrderItem` | id, menuItemId, name, quantity, unitPrice, unitCost; derived lineTotal |
| `SalesOrder` | id, restaurantId, orderNumber, orderedAt, channel, items, discount, optional notes; derived subtotal, total, itemCount, estimatedFoodCost |

`OrderChannel` values rendered by the UI are Dine-in, Takeaway, and Delivery. `SalesMockData` supplies five order-entry menu snapshots and three recent orders.

### 4.2 SalesScreen — `/sales`

**Header/date scope**

- Header context: `Today · Aug 16`.
- Today's summary is fixed to the current fixture day.
- There is no timeline/analysis-period selector on the main Sales screen.

**Displayed summary data**

- Today's Sales: Rs 28,450.
- Change: +12.4% vs yesterday.
- Orders: 42.
- Average Order: Rs 677.

**Today's sales-by-channel aggregation**

- Dine-in: Rs 15,648 and 55%.
- Takeaway: Rs 7,113 and 25%.
- Delivery: Rs 5,689 and 20%.
- Each channel has a proportional horizontal bar.
- The amounts reconcile to today's Rs 28,450 total; Delivery receives the integer rounding remainder.

**Recent Orders list**

- Header displays Recent Orders and View History.
- Up to five records are displayed; the current fixture supplies three.
- Each card displays order number, channel, total item quantity, order total, and time.
- No channel filter is rendered on the main screen.
- No explicit sort is performed in `RecentOrdersSection`; source order is used before `.take(5)`.
- No pagination is present.
- There is no Sales Trend chart or other analytics chart on the main screen.

**Alternate data states**

- loaded, empty, partial, loading, and error.
- Partial replaces channel data with “Channel data not recorded” while retaining the other loaded sections.
- Pull-to-refresh waits 500 ms and does not reload a source.

### 4.3 SalesHistoryScreen — `/sales/history`

**Displayed data**

- Selected calendar date formatted as weekday and month/day.
- Revenue for selected day.
- Order count.
- Average order.
- Percentage change versus previous day.
- Sales-by-channel card.
- Recent orders count and selected-day total order count.
- Order cards: order number, channel, item count, total, time.

**Date scope**

- Initial/latest recorded date: 16 August 2026.
- Date picker range: 1 January 2020 through 16 August 2026.
- Mock daily snapshots exist only for:
  - 16 Aug 2026: revenue 28,450; 42 orders; average 677; change +12.4%.
  - 15 Aug 2026: revenue 25,600; 38 orders; average 674; change -4.8%.
  - 14 Aug 2026: revenue 31,200; 51 orders; average 612; change +8.6%.
- Other dates show a no-sales state.

**Grouping/sorting caveats**

- It is a single-day view, not a paginated history list.
- The same three `SalesMockData.todayOrders` are rendered for every populated date; they are not filtered by the selected date.
- Channel filters are All, Dine-in, Takeaway, and Delivery and apply to the displayed recent fixture orders.
- `SalesChannelCard` uses the selected day's snapshot revenue with the same 55%/25%/20% mock shares.

### 4.4 OrderEntryScreen — `/sales/order/add` and `/sales/batch`

This is a data-entry screen, but it also requires backend-driven menu and current order data to render its composer.

**Displayed/source data**

- Generated/displayed order number (`#0043` initially for a new order).
- Existing order number when editing.
- Channel options: Dine-in, Takeaway, Delivery; default Dine-in.
- Menu browser data per item: id, name, category, selling price, estimated cost, popularity flag.
- Current order rows: selected menu item, quantity, unit price/line values.
- Order subtotal, discount, and total.
- Optional existing note in its editor.

**Search/filter**

- Case-insensitive substring search on menu-item name.
- Category selector values: Popular, Momo, Burgers, Pizza, Drinks.
- Popular is derived from `MenuItemSnapshot.isPopular`; other categories compare exact category strings.

**Local calculations**

- Subtotal = sum of `sellingPrice × selected quantity` across all menu snapshots.
- Discount is digit-only and clamped from zero through subtotal.
- Total = subtotal - discount.
- Quantity controls increment, decrement, and remove; decrementing one removes the item.

**Batch-only displayed data**

- Number of orders saved in the active batch.
- Active batch total.
- Session order summaries with generated order number, channel, item count, and total.
- Session orders retain private composer summaries only; Finish Batch returns the count.

**Current source:** `SalesMockData.menuItems`, optional route-provided `SalesOrder`, and widget-local state. Save does not persist a `SalesOrder`.

### 4.5 OrderDetailsScreen — `/sales/order/details`

**Displayed fields**

- Screen title/order number.
- Date and time from `orderedAt`.
- Channel.
- Each order line: item name, quantity, unit price, and line total.
- Subtotal.
- Discount.
- Total.
- Estimated Food Cost.
- Optional order note.

**Scope/grouping/sorting:** one passed `SalesOrder`; item order is preserved. No filter, sort, chart, or pagination.

**Current source:** `SalesOrder` passed through route `extra`; router uses the first mock order as fallback. Edit/delete remain navigation/local UI operations.

## 5. Expenses

### 5.1 Current expense models and fixtures

Primary source: `lib/src/features/expenses/domain/models/expense.dart`.

| Model | Fields consumed by screens |
|---|---|
| `Expense` | id, amount, category, description, date, type, optional notes, optional receiptPath |
| `ExpenseCategorySummary` | name, amount, percentage, transactionCount, change |
| `ExpenseCategoryDetailsData` | category summary and period navigation context |
| `ExpenseTrendPoint` | label, tooltipLabel, amount |
| `ExpensePeriodSnapshot` | total, change, transactions, averageDaily, comparisonLabel, trend points |

Expense types are Variable and Fixed. Current default categories are Ingredients, Salaries, Rent, Utilities, Packaging, Gas, Delivery Fees, Marketing, Repairs & Maintenance, Equipment, and Miscellaneous. Analytics fixtures additionally use Other.

### 5.2 ExpensesScreen — `/expenses`

**Header/date scope**

- Header context is `This Month · August 2026`.
- The top summary is always monthly, even when the analysis period changes.
- Analysis options:

| Selector | Date label | Chart grouping |
|---|---|---|
| 1M | August 2026 | week |
| 3M | June–August 2026 | month |
| 6M | March–August 2026 | month |
| 1Y | September 2025–August 2026 | month |

`ExpensePeriod.week` (`1W`, Aug 16–22, 2026) exists in the model but is not offered by ExpensesScreen.

**Monthly summary data displayed**

- This Month's Expenses total.
- Percentage change and comparison label.
- Transaction count.
- Largest category name and amount.
- Current monthly fixture: Rs 478,300; +9.8%; 86 transactions; averageDaily exists in the model but is not rendered in the summary; Ingredients is first/largest at Rs 210,000.

**Category aggregation**

- “Where Money Went” donut chart uses category amount as each slice value.
- Center value is the sum of the supplied category amounts.
- Each category row displays name, rounded percentage of total, and amount.
- Selecting a row opens ExpenseCategoryDetailsScreen with the selected category summary and current analysis period.
- Category insight is a period-specific mock sentence from `ExpensesMockData.categoryInsight(period)`:
  - 1M: Ingredient spending is 14% higher than the previous month.
  - 3M: Ingredient spending is 11% higher than the previous 3 months.
  - 6M: Ingredient spending is 10% higher than the previous 6 months.
  - 1Y: Ingredient spending is 9% higher than the previous year.

**Expense trend chart**

- Bar chart consumes period trend points containing display label, tooltip label, and an amount expressed in thousands.
- Tooltips multiply the point by 1,000 and format it as Rs.
- Highest bar is summarized as Highest week for month and Highest month for longer periods. Week behavior exists in the widget but is not selected on this screen.

**Recent expenses**

- First five entries from the current local expense list.
- Each entry displays category/description/date/type/amount as implemented by `RecentExpensesList` and opens details.
- The list starts from `ExpensesMockData.expenses`; new entries are inserted at index zero.
- No explicit sort occurs before `.take(5)`; source/list order is used.

**Local mutation behavior affecting displayed totals**

- Add/edit/delete adjusts the displayed snapshot total and transaction count in local state.
- Change percentage, comparison, largest category, category chart, category insight, average daily, and trend are not recomputed.
- Analysis-period total receives the same local adjustment regardless of the new expense's date.

**Alternate states:** loaded, noPeriodData, empty, loading, error. No pagination is present.

### 5.3 ExpenseHistoryScreen — `/expenses/history`

**Displayed fields**

- Selected range label.
- Total amount of visible expenses.
- Count of visible transactions.
- Date-group headings.
- Per expense: category icon, description, category, expense type, amount, and route to details. Date is displayed once as the group heading rather than repeated on each row.

**Date scope**

- Initial range: 1–16 August 2026.
- Date-range picker: 1 January 2020 through 16 August 2026.
- End date is inclusive.

**Filters**

- Category: All or any `ExpenseCategories.defaults` value.
- Expense type: All, Fixed, Variable.
- Filter reset clears category/type and restores Newest.

**Sorting/grouping**

- Newest: date groups descending; records within each day descending by timestamp.
- Oldest: date groups ascending; records within each day ascending.
- Highest Amount: date groups remain descending; records within each day amount descending.
- Lowest Amount: date groups remain descending; records within each day amount ascending.
- Values outside the selected inclusive range or selected category/type are excluded before totals/grouping.
- No pagination or infinite scroll.

**Current source:** route-provided list or `ExpensesMockData.expenses`; edits/deletes update only the private list.

### 5.4 ExpenseCategoryDetailsScreen — `/expenses/category/details`

**Displayed fields**

- Category name and category icon.
- Total spent.
- Transaction count.
- Share of expenses as rounded percentage.
- Comparison direction and absolute percentage change.
- Selected period label in the trend title (`<period.label> category trend`).
- Category trend bars.
- Recent expenses matching the category name: description, date, and amount.

**Aggregation/chart behavior**

- Category trend comes from `ExpensesMockData.categoryTrend(category, period)`.
- That helper scales the overall fixture trend by category share; it does not aggregate the matching transaction records.
- Chart x-axis displays trend labels; y-axis and tooltips are not shown on this detail chart.
- Recent records are filtered by exact equality of `Expense.category` and summary name.
- No sort is performed on the matching records beyond fixture order.

**Current source:** route-provided `ExpenseCategorySummary` and `ExpensePeriod`, plus `ExpensesMockData` for trend and recent transactions.

### 5.5 ExpenseDetailsScreen — `/expenses/details`

**Displayed fields**

- Category and category icon.
- Amount.
- Description.
- Date formatted month/day/year.
- Expense type.
- Optional notes.
- Optional receipt image loaded from `receiptPath`.

**Scope/grouping/sorting:** one `Expense`; no filters, chart, sorting, or pagination.

**Current source:** route-provided `Expense`, with the first fixture expense used as router fallback. Edit/delete update only the returning navigation result.

### 5.6 ExpenseFormScreen — `/expenses/add`

This screen displays selectable reference data and existing values while creating or editing.

**Displayed/editable fields**

- Amount.
- Recent category shortcuts: Ingredients, Packaging, Utilities.
- Category dropdown containing all current local categories plus `+ Add New Category`.
- Description.
- Date.
- Expense type: Variable or Fixed.
- Notes.
- Optional receipt preview/path.

**Defaults/reference behavior**

- New date defaults to 16 August 2026; picker range is 2020–2030.
- New type defaults to Variable.
- Salaries and Rent select Fixed automatically; other categories select Variable.
- Editing initializes all fields from the passed `Expense`.
- Added custom categories exist only in this form instance.
- A large-expense warning is displayed at amount >= Rs 100,000.

**Current source:** `ExpenseCategories.defaults`, optional passed Expense, ImagePickerBloc local device path, and local form state.

### 5.7 ExpenseCategoriesScreen — `/expenses/categories`

**Displayed fields/aggregations**

- Total category count.
- Fixed-category count.
- Summary chip/copy indicating the category mix.
- List count.
- Each category's name and Fixed/Variable type.
- Whether Delete is offered is derived from private `isDefault`: built-in categories cannot be deleted; custom categories can.

**Sorting/grouping:** one list in default/insertion order; no search, filter, explicit sort, or pagination.

**Current source:** private `_CategorySetting` list recreated from `ExpenseCategories.defaults`; modifications are not shared with other screens.

## 6. Menu and Menu Performance

### 6.1 Current menu models and fixtures

Primary source: `lib/src/features/menu/domain/models/menu_item.dart`.

| Model | Fields consumed by screens |
|---|---|
| `MenuItem` | id, name, category, sellingPrice, estimatedCost, unitsSold, revenue, historicalCost, ordersContainingItem, optional notes, optional imagePath |
| `MenuItemDetailsData` | item, periodLabel, demandMultiplier |

Visible calculated properties:

- Food cost percentage = estimatedCost / sellingPrice × 100; zero when price <= 0.
- Contribution per unit = sellingPrice - estimatedCost.
- Margin percentage = contribution per unit / sellingPrice × 100; zero when price <= 0.
- Estimated historical cost = historicalCost.
- Estimated historical contribution = revenue - historicalCost.

### 6.2 MenuScreen — `/menu`

**Period/date controls**

| Selector | Date label | Fixture multiplier |
|---|---|---:|
| 1M | August 2026 | 1 |
| 3M | June–August 2026 | 2.95 |
| 6M | March–August 2026 | 5.7 |
| 1Y | September 2025–August 2026 | 10.5 |

For periods longer than one month, `MenuMockData.forPeriod` scales the item's monthly units sold, revenue, historical cost, and orders-containing-item rather than loading separate history.

**Performance highlights**

- Best Seller: item with maximum `unitsSold` among items with sales; displays item name, units, and “units sold.”
- Most Profitable: item with maximum `marginPercentage`; displays item name, rounded margin percent, and “margin.”
- Highlights are hidden when no item has units sold.

**Item breakdown fields**

- Image or placeholder.
- Item name.
- Performance status badge.
- Selling price.
- Food-cost percentage.
- Units sold for selected scaled period.
- Revenue for selected scaled period.

**Performance status displayed on cards**

- zero units: NEW.
- high sales and food cost <=40%: HIGH DEMAND (`star`).
- high sales and food cost >40%: REVIEW COST.
- low sales and food cost <=40%: PROMOTE.
- low sales and food cost >40%: TRENDING DOWN.
- High sales means unitsSold >= `50 × selected period multiplier`.

**Filter/sort**

- Category filter: All Categories plus the unique current item category strings, alphabetically sorted.
- Items are filtered by exact category equality.
- Visible items sort by revenue descending.
- No search or pagination.

**Current source:** `MenuMockData.items` and private local item list. Add/edit/delete affects only that list.

### 6.3 MenuItemDetailsScreen — `/menu/item/details`

**Displayed identity data**

- Generic menu icon placeholder; the item's `imagePath` is not used by this details header.
- Item name.
- Category.
- `notes` exists on `MenuItem` but is not rendered by MenuItemDetailsScreen.

**Pricing card**

- Selling price.
- Estimated cost.
- Food-cost percentage.
- Contribution per unit.

**Performance card**

- Selected period label, default `1M · August 2026`.
- Units sold.
- Revenue.
- Estimated historical cost.
- Estimated historical contribution.
- Orders containing item.
- Performance bar chart with four fixed unlabeled values `[24, 31, 28, 43]`; it is not generated from the selected item.
- Fixed comparison copy: `↑ 8.4% units sold compared with last month`.
- Fixed explanatory copy: calculations come from prices and costs saved on each order item.
- Empty performance message when units sold is zero.

**Classification card**

- Status label/title.
- Status description.
- Recommendation.
- Classification uses the passed period demand multiplier and the same threshold rules as MenuScreen.

**Scope/grouping/sorting:** one item and one selected-period context; no filter, sort, or pagination.

**Current source:** `MenuItemDetailsData` route extra or direct `MenuItem`; first fixture item is router fallback. Editing updates only screen state and the navigation result.

### 6.4 MenuItemFormScreen — `/menu/item/add`

**Displayed/editable fields**

- Optional item image and existing image preview.
- Item name.
- Category dropdown: Momo, Burgers, Pizza, Drinks, Snacks plus locally added category.
- Selling price.
- Estimated cost.
- Notes.
- Live food-cost percentage preview.
- Live contribution-per-unit preview.
- Warning when estimated cost exceeds selling price.
- Duplicate-name warning against `MenuMockData.items`; Save Anyway remains possible.

**Editing reference data:** existing item's id, current values, analytics fields, notes, and image path are retained. New items initialize unitsSold, revenue, historicalCost, and ordersContainingItem to zero.

**Current source:** optional passed `MenuItem`, `MenuMockData.items` for duplicate detection, local categories/form state, and local image-picker path.

### 6.5 MenuCategoriesScreen — `/menu/categories`

**Displayed fields**

- Total menu-category count.
- Category list count.
- Category name.
- Item count per category.

Current private fixtures: Momo 12, Burgers 7, Pizza 6, Drinks 9, Snacks 4.

**Sorting/grouping:** fixture/insertion order; no search, filter, sort selector, or pagination. Delete is available only when local item count is zero. Counts do not derive from `MenuMockData.items`.

**Current source:** private screen-local category records; add/rename/delete are not shared with MenuScreen or MenuItemFormScreen.

## 7. Wastage

### 7.1 Current wastage models and fixtures

Primary source: `lib/src/features/wastage/domain/models/wastage.dart`.

| Model | Fields consumed by screens |
|---|---|
| `WastageEntry` | id, itemName, estimatedLoss, reason, date, optional quantity, optional unit, optional notes; derived quantityLabel |
| `WastageTrendPoint` | label, tooltipLabel, amount |
| `WastageReasonSummary` | reason, amount, share |
| `WastedItemSummary` | name, amount, entries |
| `WastageSnapshot` | total, change, entries, comparisonLabel, trend |

Reasons: Overproduction, Expired, Preparation Mistake, Customer Return, Damaged, Staff Meal, Other. Units: kg, g, pcs, portions, litres, other.

### 7.2 WastageScreen — `/wastage`

**Date scope**

- Screen context: `This Month · August 2026`.
- `WastagePeriod.month` is a fixed private constant; there is no visible period selector.
- Week and quarter snapshots exist in `WastageMockData` but are not selectable on this screen.

**Summary fields**

- Total Wastage amount.
- Percentage change and comparison label.
- Entry count.
- Top item; currently literal Chicken.
- Main cause; currently literal Overproduction.
- Insight sentence stating whether wastage improved or increased.
- Increasing fixture sentence additionally states Rs 1,520 more loss than last month as a literal.
- Monthly fixture: Rs 12,450; +14%; 26 entries; “vs previous month.”

**Wastage trend chart**

- Monthly bars are grouped by fixture week (`W1` through `W5`).
- Each point has x-axis label, tooltip date-range label, and amount expressed in thousands.
- Tooltip and highest-period summary multiply amount by 1,000.
- Highest point is displayed as Highest wastage week with label and amount.

**Reason aggregation**

- Section “Why Wastage Happened.”
- Each row displays reason label, amount, rounded share percentage, and a proportional progress bar.
- Current rows: Overproduction, Expired, Preparation Mistake, Customer Return, Damaged, Other.
- Staff Meal is a selectable entry reason but is absent from the current reason-summary fixture.

**Most-wasted-item ranking**

- Each row displays item name, number of entries, and total estimated loss.
- Current order is fixture order: Chicken, Vegetables, Bread, Rice.
- No sort is applied in the widget.

**Recent wastage**

- Every entry in the current local list is rendered; no limit or pagination.
- Each row displays item name, reason, relative/short date, optional quantity label, and estimated loss.
- 16 August 2026 is labeled Today; 15 August is Yesterday; other values use month/day.
- New entries insert at index zero; otherwise list order is retained.

**Local mutation behavior**

- Add/edit/delete adjusts only summary total and entry count plus the recent list.
- Percentage change, trend, reasons, top items, literal top item/main cause, and insight amount are not recomputed.

**Alternate states:** loaded, noPeriodData, empty, loading, error.

### 7.3 WastageDetailsScreen — `/wastage/details`

**Displayed fields**

- Item/ingredient name.
- Estimated loss amount.
- Reason.
- Optional quantity plus unit as `quantityLabel`.
- Date.
- Time.
- Optional notes.

**Scope/grouping/sorting:** one `WastageEntry`; no filter, sort, chart, or pagination.

**Current source:** route-provided entry; first `WastageMockData.entries` record is router fallback. Edit/delete update only the navigation result/local parent list.

### 7.4 WastageFormScreen — `/wastage/record`

**Displayed/editable fields**

- Free-text item or ingredient name.
- Estimated loss.
- Quick reason chips: Overproduction, Expired, Prep Mistake, Damaged.
- Full reason dropdown containing every `WastageReason` value.
- Optional quantity.
- Optional unit containing every `WastageUnit` value.
- Date.
- Optional notes.

**Defaults/reference behavior**

- Date defaults to 16 August 2026; picker range is 2020–2030.
- Reason and unit have no new-entry default.
- Editing initializes all values from the passed entry.
- Quantity and unit are independently optional.

**Current source:** enum values, optional passed `WastageEntry`, and local form state. Save creates an in-memory timestamp-ID entry.

## 8. Reports

### 8.1 Current report model and period controls

Primary source: `lib/src/features/reports/domain/models/report_data.dart`.

`ReportSnapshot` fields rendered by ReportsScreen are period, revenue, expenses, revenueChange, expenseChange, profitChange, marginChange, foodCost, foodCostChange, chartPoints, orders, wastage, and wastageChange. It derives estimatedFoodCost, grossProfit, profit, profitMargin, and averageOrderValue.

| Selector | Report title/export label | Date scope | Comparison label |
|---|---|---|---|
| 1M | Monthly Report | August 2026 | Compared with last month |
| 3M | Three Month Report | June–August 2026 | Compared with the previous 3 months |
| 6M | Six Month Report | March–August 2026 | Compared with the previous 6 months |
| 1Y | Annual Report | September 2025–August 2026 | Compared with the previous year |

No today/week/custom-date report control is rendered.

### 8.2 ReportsScreen — `/reports`

**Performance Overview fields**

- Selected period comparison label.
- Revenue and percentage change.
- Expenses and percentage change; Unavailable in partial state.
- Estimated Profit and percentage change; Unavailable in partial state.
- Profit Margin and point change; Unavailable in partial state.
- Orders.
- Average Order.
- Food Cost percentage.
- Wastage amount.

Current snapshot headlines:

| Period | Revenue | Expenses | Revenue change | Expense change | Profit change | Margin change | Food cost | Food-cost change | Orders | Wastage | Wastage change |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 1M | 842,500 | 478,300 | +12.4% | +18.6% | -2.1% | -1.8 pts | 28.4% | -1.2 pts | 1,244 | 12,450 | +14% |
| 3M | 2,482,500 | 1,408,300 | +14.6% | +12.8% | +5.1% | +0.4 pts | 27.9% | -0.5 pts | 3,684 | 34,800 | +9.2% |
| 6M | 4,772,500 | 2,699,300 | +16.8% | +13.2% | +9.4% | +1.1 pts | 27.6% | -0.9 pts | 7,082 | 68,100 | +4.8% |
| 1Y | 8,812,500 | 4,958,300 | +21.4% | +15.7% | +13.8% | +1.9 pts | 27.2% | -1.4 pts | 13,140 | 128,400 | -3.2% |

**Revenue vs Expenses chart**

- Grouped bar chart with Revenue and Expenses for each `ReportChartPoint`.
- 1M points are W1–W4; 3M points are Jun–Aug; 6M points are Mar–Aug; 1Y points are Sep–Aug.
- Stored chart values are in thousands; tooltip multiplies each by 1,000 and labels Revenue or Expenses.
- X-axis suppresses every second label only when there are more than seven points.
- Chart is hidden in partial/no-expense state.

Current point pairs are `label: revenue/expenses`, in thousands:

- 1M: W1 178/96, W2 196/108, W3 218/128, W4 250/146.
- 3M: Jun 784/438, Jul 856/492, Aug 842.5/478.3.
- 6M: Mar 718/399, Apr 742/414, May 830/468, Jun 784/438, Jul 856/502, Aug 842.5/478.3.
- 1Y: Sep 618/348, Oct 646/361, Nov 675/378, Dec 702/392, Jan 724/406, Feb 675/392, Mar 718/399, Apr 742/414, May 830/468, Jun 784/438, Jul 856/484, Aug 842.5/478.3.

**What Changed? insights**

1. Profit/expense insight:
   - If `profitChange < 0`: “Revenue increased, but profit declined,” displaying expenseChange and revenueChange.
   - Otherwise: “Profit improved this period,” with fixed explanation that revenue growth outpaced expenses.
2. Menu insight: Chicken Burger is popular but costly; fixed explanation says its food cost reached 48%.
3. Channel insight: Delivery is growing fastest; displays period-specific delivery growth: 24%, 31%, 28%, or 35% for 1M/3M/6M/1Y.

**Financial Breakdown / Estimated Profit**

- Revenue.
- Minus Estimated food cost.
- Equals Gross profit.
- Minus Operating expenses.
- Equals Estimated net profit.
- Net margin.
- Profit percentage change.
- In partial state, the card displays that expense data is required instead of these values.

Visible formulas from `ReportSnapshot`:

- Estimated food cost = revenue × foodCost / 100.
- Gross profit = revenue - estimatedFoodCost.
- Estimated net profit = grossProfit - expenses.
- Profit margin = profit / revenue × 100; zero when revenue is zero.
- Average order value = revenue / orders; zero when orders is zero.

**Drivers & Impact / Operational Highlights**

- Food cost percentage and point change; links to Menu.
- Leading sales channel, always the first helper row (Dine-in), and share of revenue (55%); links to Sales.
- Top revenue menu item, fixed Chicken Burger, with period-specific revenue: Rs 84,300 / 246,800 / 492,600 / 968,400; links to Menu.
- Wastage loss and change; values per period are Rs 12,450/+14%, Rs 34,800/+9.2%, Rs 68,100/+4.8%, Rs 128,400/-3.2%; links to Wastage.
- Average order value and period-specific change: +6.2%, +5.6%, +7.8%, +9.1%; links to Sales.

**Export control**

- Displays selected period report label and date label.
- Options: PDF (“Easy to share and print”) and CSV (“Open report data in a spreadsheet”).
- No report file or export data is produced; selection only displays a placeholder snackbar.

**Alternate states:** loaded, partial/missing expenses, empty, loading, error. No table sorting, custom filters, drill-down parameters, or pagination.

**Current source:** `ReportsMockData.forPeriod`, literal insight/menu values, and private helper tuples in `report_sections.dart`.

### 8.3 Dormant report widgets not displayed by ReportsScreen

`FoodCostReportCard`, `ExpenseBreakdownCard`, `SalesChannelReportCard`, `MenuPerformanceReportCard`, `WastageReportCard`, and `OrderBehaviourCard` are declared in `report_sections.dart` but have no call site in the current report screen. Their additional breakdown rows are therefore not counted as currently displayed screen requirements. Some of their helper data is still used by the mounted insights/operational-highlights widgets as identified above.

## 9. Restaurant and Profile

### 9.1 RestaurantAccessScreen — `/restaurant-access`

This screen displays static access choices rather than a restaurant record.

**Displayed role/permission data**

- Owner access:
  - create a restaurant;
  - manages sales, expenses, menu items, members, and reports;
  - full access to view and manage restaurant data.
- Viewer access:
  - joins through an owner invitation;
  - can view restaurant performance;
  - cannot add, edit, or delete data.
- Copy states an owner can manage member access later.

**Filters/scopes/aggregations:** none.

**Current source:** literal UI strings. The screen is registered but is not automatically entered by the current authenticated router redirect.

### 9.2 CreateRestaurantScreen — `/restaurant/create`

**Displayed/editable restaurant fields**

- Optional restaurant logo selector/placeholder.
- Restaurant name.
- Location.
- Currency: read-only `NPR (Rs)`.
- Setup role context: Owner setup.

**Current source:** local form state and literal currency. Logo gallery/camera actions close the sheet without producing a selected image. Create navigates onward without persisting a restaurant record.

**Filters/scopes/aggregations:** none.

### 9.3 JoinRestaurantScreen — `/restaurant/join`

**Invitation input/reference data**

- Invitation code.
- Access role: Viewer/read-only.
- Explanation that restaurant owners control invitations and permissions.

**Displayed invitation preview after a valid local code**

- Restaurant name: Boys to Serve.
- Location: Pokhara, Nepal.
- Verification icon/state.
- Access role: Viewer access.
- Inviter description: Invited by owner.
- Permission summary: can view restaurant performance; cannot add, edit, or delete.

**Displayed pending-request state**

- Request sent.
- Restaurant name within approval message: Boys to Serve.
- Status: Waiting for owner approval.
- Copy says the user will be notified when approved or declined.

**Lookup/filter behavior**

- Code input permits letters, digits, and hyphens.
- Any locally valid code of at least six characters reveals the same preview.
- There is no search result list, sorting, date scope, or pagination.

**Current source:** literal preview/pending content and local booleans; no restaurant lookup or join-request model is connected.

### 9.4 ProfileScreen — `/profile`

**Profile header data**

- Restaurant name: Boys to Serve.
- Account/person name: Pratik Gurung.
- Restaurant location: Pokhara, Nepal.
- Restaurant-logo placeholder.

**Restaurant settings rows**

- Members & Access summary: 2 members · 1 pending request.
- Currency: NPR (Rs).
- Menu Categories link and descriptive label.
- Expense Categories link and descriptive label.

**Account/preference/support data**

- Personal Information link.
- Change Password link.
- Notifications label with “Reports, reminders and alerts”; placeholder only.
- Help & Support, Terms of Service, Privacy Policy.
- About RestroPulse version 1.0.0.
- Logout action; sign-out is the only real service-backed behavior on this screen.

**Currency sheet**

- Selected option: NPR (Rs).
- Description: Nepalese Rupee.
- Currency symbol: Rs.
- No other options are provided.

**Filters/scopes/aggregations:** none. Member/pending counts are literal, not derived from MembersAccessScreen's list at runtime.

**Current source:** literal ProfileHeaderCard/SettingsTile values. Sign-out uses SignOutCubit and Supabase/Google services.

### 9.5 PersonalInformationScreen — `/profile/personal-information`

**Displayed/editable profile fields**

- Profile-photo placeholder/Change profile photo affordance.
- Full name; current fixture Pratik Gurung.
- Email; current fixture pratik@example.com.
- Phone; current fixture +977 9800000000.
- Read-only restaurant access: Owner · Boys to Serve.

**Filters/scopes/aggregations:** none.

**Current source:** controller literals and local form state. Save and photo actions do not persist/update a profile source.

### 9.6 EditRestaurantScreen — `/profile/restaurant/edit`

**Displayed/editable restaurant fields**

- Restaurant-logo placeholder/Change restaurant logo affordance.
- Restaurant name: Boys to Serve.
- Business phone: +977 9800000000.
- Business email: hello@boystoserve.com.
- Address: Lakeside Road.
- City and country: Pokhara, Nepal.

**Filters/scopes/aggregations:** none.

**Current source:** controller literals and local form state. Save/logo actions do not persist/update a restaurant source.

### 9.7 ChangePasswordScreen — `/profile/change-password`

**Displayed/editable account fields**

- Current password.
- New password.
- Confirm new password.
- Live password-requirement state: at least eight characters with a letter and number.
- Copy says the email address and new password will be used to sign in.

No account identity, provider, last-password-change date, active sessions, or security history is displayed. There are no filters, date scopes, aggregations, or charts.

**Current source:** local form state and a success snackbar. No password/account service is called; this also conflicts with the implemented OTP/Google sign-in UI.

### 9.8 HelpAndSupportScreen — `/help-support`

**Displayed support/product data**

- Help header title and explanation.
- Fifteen expandable FAQ question/answer pairs covering:
  1. What is the main goal of RestroPulse?
  2. What does Restaurant Pulse actually tell me?
  3. Why isn't revenue alone enough to know if my restaurant is doing well?
  4. How can RestroPulse help me increase profit?
  5. How do I know which menu items are actually good for my business?
  6. Why should I track food cost?
  7. Why should I record wastage?
  8. What does average order value tell me?
  9. Why should I compare this month with last month?
  10. What should I look at if sales are increasing but profit is falling?
  11. How can I know what needs attention first?
  12. Does RestroPulse replace my POS system?
  13. Does RestroPulse replace accounting software?
  14. How much data do I need before RestroPulse becomes useful?
  15. Do I need to enter every customer order individually?
- The FAQ answers contain product definitions, metric lists, and the visible formula `Average order value = Total Revenue ÷ Number of Orders`.
- Version: RestroPulse v1.0.0.
- Tagline: Restaurant performance made clearer.
- Email-support and Report a Problem actions.

**Grouping/filtering:** FAQs are one insertion-ordered list under Frequently Asked Questions. Only one question is tracked as expanded at a time. There is no search, category filter, sorting, or pagination.

**Current source:** static `_Faq` records compiled into the screen. Email support is a placeholder. One FAQ says the initial version can record aggregate daily totals instead of each order, which conflicts with the executable itemized order-entry screen.

### 9.9 ReportProblemScreen — direct Material route from Help

**Displayed/editable support fields**

- Issue Category: Sales, Expenses, Menu, Reports, Restaurant Pulse, Account, Other.
- Subject.
- Description.
- Optional screenshot attachment affordance.
- Submitting state.
- Success state with Report submitted confirmation and review message.

**Filters/scopes/aggregations:** none. Category is a form classification rather than a result-list filter. No ticket ID, submission date, ticket status, assigned agent, response, or ticket history is displayed.

**Current source:** local form state and a 700 ms mock submission. Screenshot attachment is a placeholder; no support record is created.

## 10. Members and Join Requests

### 10.1 MembersAccessScreen — `/profile/members-access`

**Summary data**

- Total member count; current value 2.
- Restaurant name in summary: Boys to Serve.
- Owner count; displayed as a literal `1 Owner` rather than derived.
- Viewer count; derived from members whose role string equals Viewer; current value 1.

**Join-code data**

- One nullable active code; initial value `RP-7K9M2`.
- State label: Active until regenerated or Currently disabled.
- Code value when enabled.
- Permission copy: sharing the code allows someone to request Viewer access and requires owner approval.
- Local replacement sequence when regenerated: `RP-4N8Q6`, `RP-2M7X5`, `RP-9T3K8`.
- Copy/regenerate/disable actions; disabled state offers Generate join code.

**Pending-request data**

- Pending request count.
- Each request displays requester name and email, plus Approve and Decline actions.
- Initial request: Nisha Thapa, nisha@example.com.
- Empty state: No pending access requests.
- Approving removes the request and appends a Viewer member with the same name/email.

**Restaurant-member data**

- Member count.
- Each member displays name, email, and role badge.
- Owner: Pratik Gurung, pratik@boystoserve.com, Owner.
- Viewer: Suman Gurung, suman@example.com, Viewer.
- Remove access is offered only for role string Viewer.

**Sorting/grouping/filtering**

- Grouped into Invite viewers, Pending requests, and Restaurant members sections.
- Lists retain private insertion order.
- No search, role filter, status filter, sort control, join/request date, pagination, or history is displayed.

**Current source:** private `_RestaurantMember` and `_AccessRequest` classes and widget-local lists. No shared profile, restaurant, membership, or request model is used.

### 10.2 Join request from the viewer side

JoinRestaurantScreen displays only the local lifecycle `code entry -> invitation preview -> waiting for owner approval`. It does not display request ID, requested/updated timestamps, owner identity, rejection reason, expiration, or membership activation details. The only current status wording is Waiting for owner approval, followed by the promise of an approval/decline notification.

## 11. Notifications

### 11.1 Current rendered notification surface

ProfileScreen contains one SettingsTile:

- title: Notifications;
- subtitle: Reports, reminders and alerts;
- bell icon;
- tap result: snackbar saying notification settings are coming soon.

JoinRestaurantScreen also contains static copy saying the viewer will be notified when an owner approves or declines a request. This is product wording only.

### 11.2 Data not currently displayed or modeled

There is no notification screen, list, notification object, type, title/body, created date, read/unread state, unread count/badge, deep-link target, delivery channel, preference value, device token, pagination, filtering, grouping, or sorting. Repository search found no push/local/in-app notification implementation and no active Firebase Messaging use. Therefore, there are no current notification records or notification preference fields to inventory beyond the placeholder labels above.

## 12. Consolidated Query-Control Inventory

This table consolidates controls that change displayed backend-candidate data.

| Screen | Date/period control | Filters | Search | Sorting/grouping | Pagination |
|---|---|---|---|---|---|
| Dashboard | fixed today / yesterday / last-week labels | none | none | none | none |
| Sales | fixed Today · Aug 16 | none | none | first five recent orders in source order | none |
| Sales History | one selected date, 2020–2026-08-16 | recent orders by channel | none | single-day summary; fixture recent order order | none |
| Order Entry | implicit current order/day | channel; menu category | menu name substring | menu fixture order | none |
| Expenses | fixed monthly summary; analysis 1M, 3M, 6M, 1Y | none | none | category aggregation; trend week/month grouping; first five local entries | none |
| Expense History | inclusive date range | category; Fixed/Variable | none | newest, oldest, highest, lowest; grouped by day | none |
| Expense Category Details | period inherited from Expenses | exact category | none | period trend plus fixture-order matching records | none |
| Menu | 1M, 3M, 6M, 1Y | category | none | revenue descending | none |
| Menu Item Details | period inherited/default monthly | one item | none | item performance context | none |
| Wastage | fixed August 2026 month | none | none | trend by week; fixture reason/item ranking; recent list order | none |
| Reports | 1M, 3M, 6M, 1Y | none | none | chart by week/month; no sortable table | none |
| Restaurant/Profile | none | none | none | settings sections | none |
| Help/Report Problem | none | support issue category on form | none | FAQ insertion order | none |
| Members | none | none | none | pending and member insertion order | none |
| Notifications | none | none | none | none | none |

## 13. Current Data-Source Map

| Area | Identifiable source | Consumption status |
|---|---|---|
| Dashboard | literal widget values under `features/dashboard/presentation/widgets/` | displayed directly |
| Sales transactions/menu snapshots | `SalesMockData` in `sales_order.dart` | displayed and locally composed |
| Expense transactions/categories/periods | `ExpensesMockData` and `ExpenseCategories` in `expense.dart` | displayed and locally adjusted |
| Menu items/performance | `MenuMockData` and calculated `MenuItem` getters/classifier in `menu_item.dart` | displayed and locally adjusted/scaled |
| Wastage entries/periods/reasons/items | `WastageMockData` in `wastage.dart` | displayed and locally adjusted in part |
| Reports | `ReportsMockData` in `report_data.dart`; helpers/literals in `report_sections.dart` | displayed by mounted report components |
| Profile/restaurant | literal controllers and widget text | displayed/local edit only |
| Members/requests/join codes | private classes/lists in `members_access_screen.dart` | displayed/local mutation only |
| Notifications | Profile placeholder row | no data source/model |
| Help/support | static `_Faq` list and local report-problem form | FAQ displayed; submission/attachment placeholders |

No sales, expense, menu, wastage, report, restaurant/profile, membership, join-request, or notification screen currently reads business data from Supabase or another API. Supabase is currently used for authentication/session behavior, which is outside the operational display-data inventory above.
