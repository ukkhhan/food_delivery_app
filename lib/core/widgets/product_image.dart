import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';
import '../../features/products/data/repositories/product_repository.dart';

class ProductImage extends StatefulWidget {
  final String productId;
  final double height;
  final double? width;
  final double radius;
  final Uint8List? previewBytes;

  const ProductImage({
    super.key,
    required this.productId,
    this.height = 100,
    this.width,
    this.radius = 12,
    this.previewBytes,
  });

  @override
  State<ProductImage> createState() => _ProductImageState();
}

class _ProductImageState extends State<ProductImage> {
  Uint8List? _bytes;

  @override
  void initState() {
    super.initState();
    if (widget.previewBytes != null) {
      _bytes = widget.previewBytes;
    } else {
      _load();
    }
  }

  @override
  void didUpdateWidget(ProductImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.previewBytes != null && widget.previewBytes != _bytes) {
      setState(() => _bytes = widget.previewBytes);
    } else if (widget.productId != oldWidget.productId && widget.previewBytes == null) {
      _load();
    }
  }

  Future<void> _load() async {
    final bytes = await Get.find<ProductRepository>().getImage(widget.productId);
    if (mounted) setState(() => _bytes = bytes);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.radius),
      child: Container(
        height: widget.height,
        width: widget.width ?? double.infinity,
        color: AppColors.chipBg,
        child: _bytes != null
            ? Image.memory(_bytes!, fit: BoxFit.cover)
            : const Icon(Icons.restaurant, color: AppColors.textHint),
      ),
    );
  }
}
