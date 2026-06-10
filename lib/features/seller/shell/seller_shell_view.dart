import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/models/notification_model.dart';
import '../../../core/widgets/notification_bell_icon.dart';
import '../../profile/views/profile_view.dart';
import '../dashboard/views/seller_dashboard_view.dart';
import '../notifications/views/seller_notifications_view.dart';
import '../products/views/seller_products_view.dart';

class SellerShellView extends StatefulWidget {
  const SellerShellView({super.key});

  @override
  State<SellerShellView> createState() => _SellerShellViewState();
}

class _SellerShellViewState extends State<SellerShellView> {
  int _index = 0;

  final _pages = const [
    SellerDashboardView(),
    SellerProductsView(),
    SellerNotificationsView(),
    ProfileView(isSeller: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard), label: AppStrings.dashboard),
          const BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu_outlined), activeIcon: Icon(Icons.restaurant_menu), label: AppStrings.products),
          BottomNavigationBarItem(
            icon: const NotificationBellIcon(audience: NotificationAudience.seller),
            activeIcon: const NotificationBellIcon(
              audience: NotificationAudience.seller,
              active: true,
            ),
            label: AppStrings.notifications,
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: AppStrings.profile),
        ],
      ),
    );
  }
}
