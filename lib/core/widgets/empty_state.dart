import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'my_text.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: AppColors.textHint),
            const SizedBox(height: 16),
            MyText.title(title, align: TextAlign.center),
            const SizedBox(height: 6),
            MyText.caption(subtitle, align: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
