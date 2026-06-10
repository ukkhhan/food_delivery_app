import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../profile/views/profile_view.dart';
import '../cart/views/cart_view.dart';
import '../home/views/buyer_home_view.dart';
import '../notifications/views/buyer_notifications_view.dart';
import '../orders/views/orders_view.dart';

class BuyerShellView extends StatefulWidget {
  const BuyerShellView({super.key});

  @override
  State<BuyerShellView> createState() => _BuyerShellViewState();
}

class _BuyerShellViewState extends State<BuyerShellView> {
  int _index = 0;

  final _pages = const [
    BuyerHomeView(),
    CartView(),
    OrdersView(),
    BuyerNotificationsView(),
    ProfileView(isSeller: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: AppStrings.home),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), activeIcon: Icon(Icons.shopping_bag), label: AppStrings.cart),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), activeIcon: Icon(Icons.receipt_long), label: AppStrings.orders),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), activeIcon: Icon(Icons.notifications), label: AppStrings.notifications),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: AppStrings.profile),
        ],
      ),
    );
  }
}
