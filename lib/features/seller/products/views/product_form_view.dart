import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/food_item.dart';
import '../../../../core/widgets/my_button.dart';
import '../../../../core/widgets/my_text_field.dart';
import '../../../../core/widgets/my_text.dart';

class ProductFormView extends StatefulWidget {
  const ProductFormView({super.key});

  @override
  State<ProductFormView> createState() => _ProductFormViewState();
}

class _ProductFormViewState extends State<ProductFormView> {
  final _nameFocus = FocusNode();
  final _priceFocus = FocusNode();
  final _categoryFocus = FocusNode();
  final _descFocus = FocusNode();

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descController = TextEditingController();

  bool get _isEdit => Get.arguments != null;

  @override
  void initState() {
    super.initState();
    final item = Get.arguments;
    if (item is FoodItem) {
      _nameController.text = item.name;
      _priceController.text = item.price.toStringAsFixed(2);
      _categoryController.text = item.category;
      _descController.text = item.description;
    }
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    _priceFocus.dispose();
    _categoryFocus.dispose();
    _descFocus.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText.title(_isEdit ? AppStrings.editProduct : AppStrings.addProduct),
        actions: [
          if (_isEdit)
            TextButton(
              onPressed: () => Get.back(),
              child: const MyText.caption(AppStrings.delete, color: AppColors.error),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.chipBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_photo_alternate_outlined, color: AppColors.textHint),
                SizedBox(height: 6),
                MyText.caption('Image saved locally in next step'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          MyTextField(
            label: AppStrings.productName,
            controller: _nameController,
            focusNode: _nameFocus,
            nextFocus: _priceFocus,
          ),
          const SizedBox(height: 16),
          MyTextField(
            label: AppStrings.price,
            controller: _priceController,
            focusNode: _priceFocus,
            nextFocus: _categoryFocus,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefix: '\$ ',
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
          ),
          const SizedBox(height: 16),
          MyTextField(
            label: AppStrings.category,
            controller: _categoryController,
            focusNode: _categoryFocus,
            nextFocus: _descFocus,
          ),
          const SizedBox(height: 16),
          MyTextField(
            label: AppStrings.description,
            controller: _descController,
            focusNode: _descFocus,
            textInputAction: TextInputAction.done,
            maxLines: 3,
          ),
          const SizedBox(height: 28),
          MyButton(
            label: AppStrings.save,
            onTap: () => Get.back(),
          ),
        ],
      ),
    );
  }
}
