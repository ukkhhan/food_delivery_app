import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_categories.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/food_item.dart';
import '../../../../core/widgets/my_button.dart';
import '../../../../core/widgets/my_dropdown.dart';
import '../../../../core/widgets/my_text_field.dart';
import '../../../../core/widgets/my_text.dart';
import '../../../../core/widgets/product_image.dart';
import '../../../products/controllers/product_controller.dart';

class ProductFormView extends StatefulWidget {
  const ProductFormView({super.key});

  @override
  State<ProductFormView> createState() => _ProductFormViewState();
}

class _ProductFormViewState extends State<ProductFormView> {
  final _controller = Get.find<ProductController>();
  final _picker = ImagePicker();

  final _nameFocus = FocusNode();
  final _priceFocus = FocusNode();
  final _descFocus = FocusNode();

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();

  FoodItem? _existing;
  Uint8List? _imageBytes;
  String? _selectedCategory;
  late List<String> _categoryOptions;

  bool get _isEdit => _existing != null;

  @override
  void initState() {
    super.initState();
    _categoryOptions = List<String>.from(AppCategories.options);

    final args = Get.arguments;
    if (args is FoodItem) {
      _existing = args;
      _nameController.text = args.name;
      _priceController.text = args.price.toStringAsFixed(2);
      _descController.text = args.description;
      _selectedCategory = _resolveCategory(args.category);
    }
  }

  String? _resolveCategory(String category) {
    if (category.isEmpty) return null;
    if (!_categoryOptions.contains(category)) {
      _categoryOptions = [category, ..._categoryOptions];
    }
    return category;
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    _priceFocus.dispose();
    _descFocus.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      imageQuality: 85,
    );
    if (file == null) return;

    final bytes = await file.readAsBytes();
    setState(() => _imageBytes = bytes);
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final category = _selectedCategory?.trim() ?? '';
    final description = _descController.text.trim();
    final price = double.tryParse(_priceController.text.trim());

    if (name.isEmpty || category.isEmpty || description.isEmpty || price == null) {
      Get.snackbar(
        AppStrings.saveFailed,
        AppStrings.fillAllFields,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    if (!_isEdit && _imageBytes == null) {
      Get.snackbar(
        AppStrings.saveFailed,
        AppStrings.addImage,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    final ok = await _controller.saveProduct(
      existing: _existing,
      name: name,
      description: description,
      price: price,
      category: category,
      imageBytes: _imageBytes,
    );

    if (!ok || !mounted) return;

    await _controller.refreshProducts();
    Get.back();
    Get.snackbar(
      AppStrings.save,
      AppStrings.productSaved,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText.title(_isEdit ? AppStrings.editProduct : AppStrings.addProduct),
        actions: [
          if (_isEdit)
            TextButton(
              onPressed: () => _controller.deleteProduct(_existing!),
              child: const MyText.caption(AppStrings.delete, color: AppColors.error),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: _existing != null && _imageBytes == null
                ? ProductImage(
                    productId: _existing!.id,
                    height: 160,
                    radius: 12,
                  )
                : Container(
                    height: 160,
                    decoration: BoxDecoration(
                      color: AppColors.chipBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: _imageBytes != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(_imageBytes!, fit: BoxFit.cover),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add_photo_alternate_outlined,
                                  color: AppColors.textHint),
                              const SizedBox(height: 6),
                              MyText.caption(
                                _isEdit ? AppStrings.changeImage : AppStrings.pickImage,
                              ),
                            ],
                          ),
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
            nextFocus: _descFocus,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefix: '\$ ',
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
          ),
          const SizedBox(height: 16),
          MyDropdown(
            label: AppStrings.category,
            value: _selectedCategory,
            items: _categoryOptions,
            onChanged: (value) => setState(() => _selectedCategory = value),
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
          Obx(
            () => MyButton(
              label: AppStrings.save,
              isLoading: _controller.isSaving.value,
              onTap: _save,
            ),
          ),
        ],
      ),
    );
  }
}
