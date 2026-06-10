import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

enum MyTextVariant { display, title, subtitle, body, caption, label }

class MyText extends StatelessWidget {
  final String text;
  final MyTextVariant variant;
  final Color? color;
  final FontWeight? weight;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;

  const MyText(
    this.text, {
    super.key,
    this.variant = MyTextVariant.body,
    this.color,
    this.weight,
    this.align,
    this.maxLines,
    this.overflow,
  });

  const MyText.display(
    this.text, {
    super.key,
    this.color,
    this.weight,
    this.align,
    this.maxLines,
    this.overflow,
  }) : variant = MyTextVariant.display;

  const MyText.title(
    this.text, {
    super.key,
    this.color,
    this.weight,
    this.align,
    this.maxLines,
    this.overflow,
  }) : variant = MyTextVariant.title;

  const MyText.subtitle(
    this.text, {
    super.key,
    this.color,
    this.weight,
    this.align,
    this.maxLines,
    this.overflow,
  }) : variant = MyTextVariant.subtitle;

  const MyText.body(
    this.text, {
    super.key,
    this.color,
    this.weight,
    this.align,
    this.maxLines,
    this.overflow,
  }) : variant = MyTextVariant.body;

  const MyText.caption(
    this.text, {
    super.key,
    this.color,
    this.weight,
    this.align,
    this.maxLines,
    this.overflow,
  }) : variant = MyTextVariant.caption;

  const MyText.label(
    this.text, {
    super.key,
    this.color,
    this.weight,
    this.align,
    this.maxLines,
    this.overflow,
  }) : variant = MyTextVariant.label;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
      style: _styleFor(variant).copyWith(
        color: color ?? _defaultColor(variant),
        fontWeight: weight,
      ),
    );
  }

  TextStyle _styleFor(MyTextVariant v) {
    switch (v) {
      case MyTextVariant.display:
        return GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w700);
      case MyTextVariant.title:
        return GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600);
      case MyTextVariant.subtitle:
        return GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500);
      case MyTextVariant.body:
        return GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400);
      case MyTextVariant.caption:
        return GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400);
      case MyTextVariant.label:
        return GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500);
    }
  }

  Color _defaultColor(MyTextVariant v) {
    switch (v) {
      case MyTextVariant.caption:
      case MyTextVariant.label:
        return AppColors.textSecondary;
      default:
        return AppColors.textPrimary;
    }
  }
}
