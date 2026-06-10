import '../models/food_item.dart';
import '../models/notification_model.dart';
import '../models/order_model.dart';

class MockData {
  static const categories = ['All', 'Burger', 'Pizza', 'Drinks', 'Dessert'];

  static const foods = [
    FoodItem(
      id: '1',
      name: 'Classic Burger',
      description: 'Juicy beef patty, cheddar, lettuce and house sauce.',
      price: 8.99,
      category: 'Burger',
      emoji: '🍔',
    ),
    FoodItem(
      id: '2',
      name: 'Margherita Pizza',
      description: 'Fresh mozzarella, basil and tomato on thin crust.',
      price: 11.50,
      category: 'Pizza',
      emoji: '🍕',
    ),
    FoodItem(
      id: '3',
      name: 'Iced Latte',
      description: 'Cold brew espresso with milk over ice.',
      price: 4.25,
      category: 'Drinks',
      emoji: '🥤',
    ),
    FoodItem(
      id: '4',
      name: 'Chocolate Brownie',
      description: 'Warm fudge brownie with dark chocolate chunks.',
      price: 3.99,
      category: 'Dessert',
      emoji: '🍫',
    ),
    FoodItem(
      id: '5',
      name: 'Spicy Chicken Wrap',
      description: 'Grilled chicken, jalapeño mayo and crunchy veggies.',
      price: 7.49,
      category: 'Burger',
      emoji: '🌯',
    ),
    FoodItem(
      id: '6',
      name: 'Pepperoni Feast',
      description: 'Double pepperoni with extra cheese.',
      price: 13.99,
      category: 'Pizza',
      emoji: '🍕',
    ),
  ];

  static final orders = [
    OrderModel(
      id: 'ORD-1042',
      lines: [
        OrderLine(item: foods[0], quantity: 2),
        OrderLine(item: foods[2], quantity: 1),
      ],
      status: OrderStatus.preparing,
      createdAt: DateTime.now().subtract(const Duration(minutes: 25)),
      buyerName: 'Alex',
    ),
    OrderModel(
      id: 'ORD-1038',
      lines: [OrderLine(item: foods[1], quantity: 1)],
      status: OrderStatus.delivered,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      buyerName: 'Alex',
    ),
  ];

  static final buyerNotifications = [
    NotificationModel(
      id: 'n1',
      title: 'Order received',
      body: 'ORD-1042 is confirmed. Kitchen started preparing.',
      time: DateTime.now().subtract(const Duration(minutes: 20)),
    ),
    NotificationModel(
      id: 'n2',
      title: 'Out for delivery',
      body: 'Your pizza is on the way.',
      time: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
    ),
  ];

  static final sellerNotifications = [
    NotificationModel(
      id: 's1',
      title: 'New order',
      body: 'ORD-1042 from Alex — 2 items.',
      time: DateTime.now().subtract(const Duration(minutes: 25)),
    ),
    NotificationModel(
      id: 's2',
      title: 'Order delivered',
      body: 'ORD-1038 marked as delivered.',
      time: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
  ];

  static FoodItem? foodById(String id) {
    for (final item in foods) {
      if (item.id == id) return item;
    }
    return null;
  }
}
