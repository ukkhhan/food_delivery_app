import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/my_button.dart';
import '../../../core/widgets/my_text.dart';

class ProfileView extends StatelessWidget {
  final bool isSeller;

  const ProfileView({super.key, required this.isSeller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const MyText.title(AppStrings.profile)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.chipBg,
                  child: Text(
                    'A',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      MyText.title('Alex Morgan'),
                      SizedBox(height: 4),
                      MyText.caption('alex@email.com'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const MyText.subtitle(AppStrings.account),
          const SizedBox(height: 12),
          _infoTile(Icons.person_outline, AppStrings.name, 'Alex Morgan'),
          _infoTile(Icons.email_outlined, AppStrings.email, 'alex@email.com'),
          const SizedBox(height: 24),
          const MyText.subtitle(AppStrings.switchRole),
          const SizedBox(height: 8),
          MyText.caption(
            isSeller ? AppStrings.currentlySeller : AppStrings.currentlyBuyer,
          ),
          const SizedBox(height: 12),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: false, label: Text(AppStrings.buyerMode)),
              ButtonSegment(value: true, label: Text(AppStrings.sellerMode)),
            ],
            selected: {isSeller},
            onSelectionChanged: (set) {
              final seller = set.first;
              if (seller == isSeller) return;
              Get.offAllNamed(seller ? AppRoutes.sellerShell : AppRoutes.buyerShell);
            },
          ),
          const SizedBox(height: 32),
          MyButton(
            label: AppStrings.signOut,
            outlined: true,
            color: AppColors.error,
            onTap: () => Get.offAllNamed(AppRoutes.login),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textHint),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText.caption(label),
                MyText.body(value),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
