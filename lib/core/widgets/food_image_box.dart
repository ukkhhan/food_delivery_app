import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class FoodImageBox extends StatelessWidget {
  final String emoji;
  final Color? tint;
  final double height;
  final double? width;
  final double radius;

  const FoodImageBox({
    super.key,
    required this.emoji,
    this.tint,
    this.height = 100,
    this.width,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: tint ?? AppColors.chipBg,
        borderRadius: BorderRadius.circular(radius),
      ),
      alignment: Alignment.center,
      child: Text(emoji, style: TextStyle(fontSize: height * 0.4)),
    );
  }
}
