/// Routes available in the application.
///
/// The enum value's [name] is used as the GoRouter route name, while [path]
/// defines its URL location.
enum AppRoute {
  onboarding('/onboarding'),
  splash('/splash'),
  auth('/auth'),
  verifyOTP('/verify-otp'),
  restaurantAccess('/restaurant-access'),
  createRestaurant('/restaurant/create'),
  joinRestaurant('/restaurant/join'),
  main('/main'),
  dashboard('/dashboard'),
  profile('/profile'),
  editRestaurant('/profile/restaurant/edit'),
  personalInformation('/profile/personal-information'),
  changePassword('/profile/change-password'),
  membersAccess('/profile/members-access'),
  helpSupport('/help-support'),
  expenses('/expenses'),
  expenseHistory('/expenses/history'),
  addExpense('/expenses/add'),
  expenseDetails('/expenses/details'),
  expenseCategoryDetails('/expenses/category/details'),
  expenseCategories('/expenses/categories'),
  wastage('/wastage'),
  wastageHistory('/wastage/history'),
  recordWastage('/wastage/record'),
  wastageDetails('/wastage/details'),
  menu('/menu'),
  addMenuItem('/menu/item/add'),
  menuItemDetails('/menu/item/details'),
  menuCategories('/menu/categories'),
  reports('/reports'),
  sales('/sales'),
  addOrder('/sales/order/add'),
  batchEntry('/sales/batch'),
  orderDetails('/sales/order/details'),
  salesHistory('/sales/history');

  const AppRoute(this.path);

  final String path;
}
