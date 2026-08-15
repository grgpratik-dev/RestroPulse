enum OrderChannel { dineIn, takeaway, delivery }

extension OrderChannelLabel on OrderChannel {
  String get label => switch (this) {
    OrderChannel.dineIn => 'Dine-in',
    OrderChannel.takeaway => 'Takeaway',
    OrderChannel.delivery => 'Delivery',
  };
}

class MenuItemSnapshot {
  const MenuItemSnapshot({
    required this.id,
    required this.name,
    required this.category,
    required this.sellingPrice,
    required this.estimatedCost,
    this.isActive = true,
    this.isPopular = false,
  });

  final String id;
  final String name;
  final String category;
  final int sellingPrice;
  final int estimatedCost;
  final bool isActive;
  final bool isPopular;
}

class SalesOrderItem {
  const SalesOrderItem({
    required this.id,
    required this.menuItemId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.unitCost,
  });

  final String id;
  final String menuItemId;
  final String name;
  final int quantity;
  final int unitPrice;
  final int unitCost;

  int get lineTotal => quantity * unitPrice;
}

class SalesOrder {
  const SalesOrder({
    required this.id,
    required this.restaurantId,
    required this.orderNumber,
    required this.orderedAt,
    required this.channel,
    required this.items,
    this.discount = 0,
    this.notes,
  });

  final String id;
  final String restaurantId;
  final String orderNumber;
  final DateTime orderedAt;
  final OrderChannel channel;
  final List<SalesOrderItem> items;
  final int discount;
  final String? notes;

  int get subtotal => items.fold(0, (total, item) => total + item.lineTotal);
  int get total => subtotal - discount;
  int get itemCount => items.fold(0, (total, item) => total + item.quantity);
  int get estimatedFoodCost =>
      items.fold(0, (total, item) => total + item.unitCost * item.quantity);
}

abstract final class SalesMockData {
  static const menuItems = [
    MenuItemSnapshot(
      id: 'momo-chicken',
      name: 'Chicken Momo',
      category: 'Momo',
      sellingPrice: 180,
      estimatedCost: 82,
      isPopular: true,
    ),
    MenuItemSnapshot(
      id: 'momo-buff',
      name: 'Buff Momo',
      category: 'Momo',
      sellingPrice: 160,
      estimatedCost: 70,
      isPopular: true,
    ),
    MenuItemSnapshot(
      id: 'burger-chicken',
      name: 'Chicken Burger',
      category: 'Burgers',
      sellingPrice: 350,
      estimatedCost: 155,
      isPopular: true,
    ),
    MenuItemSnapshot(
      id: 'pizza-margherita',
      name: 'Margherita Pizza',
      category: 'Pizza',
      sellingPrice: 520,
      estimatedCost: 220,
    ),
    MenuItemSnapshot(
      id: 'drink-coke',
      name: 'Coke',
      category: 'Drinks',
      sellingPrice: 120,
      estimatedCost: 55,
      isPopular: true,
    ),
    MenuItemSnapshot(
      id: 'inactive-old-item',
      name: 'Old Special',
      category: 'Other',
      sellingPrice: 400,
      estimatedCost: 180,
      isActive: false,
    ),
  ];

  static final todayOrders = [
    SalesOrder(
      id: 'order-42',
      restaurantId: 'restaurant-1',
      orderNumber: '#0042',
      orderedAt: DateTime(2026, 8, 16, 21, 17),
      channel: OrderChannel.dineIn,
      discount: 140,
      notes: 'Extra spicy momo.',
      items: const [
        SalesOrderItem(
          id: 'oi-42-1',
          menuItemId: 'burger-chicken',
          name: 'Chicken Burger',
          quantity: 2,
          unitPrice: 350,
          unitCost: 155,
        ),
        SalesOrderItem(
          id: 'oi-42-2',
          menuItemId: 'drink-coke',
          name: 'Coke',
          quantity: 1,
          unitPrice: 120,
          unitCost: 55,
        ),
      ],
    ),
    SalesOrder(
      id: 'order-41',
      restaurantId: 'restaurant-1',
      orderNumber: '#0041',
      orderedAt: DateTime(2026, 8, 16, 21, 3),
      channel: OrderChannel.takeaway,
      discount: 30,
      items: const [
        SalesOrderItem(
          id: 'oi-41-1',
          menuItemId: 'pizza-margherita',
          name: 'Margherita Pizza',
          quantity: 2,
          unitPrice: 520,
          unitCost: 220,
        ),
        SalesOrderItem(
          id: 'oi-41-2',
          menuItemId: 'drink-coke',
          name: 'Coke',
          quantity: 2,
          unitPrice: 120,
          unitCost: 55,
        ),
      ],
    ),
    SalesOrder(
      id: 'order-40',
      restaurantId: 'restaurant-1',
      orderNumber: '#0040',
      orderedAt: DateTime(2026, 8, 16, 20, 54),
      channel: OrderChannel.delivery,
      items: const [
        SalesOrderItem(
          id: 'oi-40-1',
          menuItemId: 'momo-chicken',
          name: 'Chicken Momo',
          quantity: 2,
          unitPrice: 180,
          unitCost: 82,
        ),
        SalesOrderItem(
          id: 'oi-40-2',
          menuItemId: 'momo-buff',
          name: 'Buff Momo',
          quantity: 1,
          unitPrice: 160,
          unitCost: 70,
        ),
      ],
    ),
  ];
}
