import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/my_button.dart';
import '../../../core/widgets/my_text.dart';
import '../../auth/controllers/auth_controller.dart';

class ProfileView extends GetView<AuthController> {
  final bool isSeller;

  const ProfileView({super.key, required this.isSeller});

  @override
  Widget build(BuildContext context) {
    final user = controller.currentUser;
    final name = user?.name ?? 'User';
    final email = user?.email ?? '';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

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
                  backgroundImage:
                      user?.photoUrl != null ? NetworkImage(user!.photoUrl!) : null,
                  child: user?.photoUrl == null
                      ? Text(
                          initial,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText.title(name),
                      const SizedBox(height: 4),
                      MyText.caption(email),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const MyText.subtitle(AppStrings.account),
          const SizedBox(height: 12),
          _infoTile(Icons.person_outline, AppStrings.name, name),
          _infoTile(Icons.email_outlined, AppStrings.email, email),
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
            onSelectionChanged: (set) => controller.switchRole(set.first),
          ),
          const SizedBox(height: 32),
          MyButton(
            label: AppStrings.signOut,
            outlined: true,
            color: AppColors.error,
            onTap: controller.signOut,
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
