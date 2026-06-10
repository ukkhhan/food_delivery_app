import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';
import '../constants/image_refs.dart';
import '../../features/products/data/repositories/product_repository.dart';

class ProductImage extends StatefulWidget {
  final String? imageKey;
  final String? productId;
  final double height;
  final double? width;
  final double radius;
  final Uint8List? previewBytes;

  const ProductImage({
    super.key,
    this.imageKey,
    this.productId,
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

  String? get _resolvedKey {
    if (widget.imageKey != null && widget.imageKey!.isNotEmpty) {
      return widget.imageKey;
    }
    if (widget.productId != null && widget.productId!.isNotEmpty) {
      return ImageRefs.localKey(widget.productId!);
    }
    return null;
  }

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
    } else if (_resolvedKey != _resolveKey(oldWidget) && widget.previewBytes == null) {
      _load();
    }
  }

  String? _resolveKey(ProductImage w) {
    if (w.imageKey != null && w.imageKey!.isNotEmpty) return w.imageKey;
    if (w.productId != null && w.productId!.isNotEmpty) {
      return ImageRefs.localKey(w.productId!);
    }
    return null;
  }

  Future<void> _load() async {
    final bytes =
        await Get.find<ProductRepository>().getImageByRef(_resolvedKey);
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
