import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../service_model/service_category.dart';
import '../service_widget/categories_tab.dart';
import '../service_widget/category_form.dart';
import '../service_widget/custom_fav.dart';
import '../service_widget/sub_categories_tab.dart';
import '../service_widget/sub_category_form.dart';

class ServiceManagementScreen extends StatefulWidget {
  const ServiceManagementScreen({super.key});

  @override
  State<ServiceManagementScreen> createState() =>
      _ServiceManagementScreenState();
}

class _ServiceManagementScreenState extends State<ServiceManagementScreen> {
  final List<ServiceCategory> _categories = [];
  final ImagePicker _picker = ImagePicker();

  // Color scheme
  final Color _primaryColor = Colors.redAccent;
  final Color _backgroundColor = const Color(0xFFF4F5F7);
  final Color _cardColor = Colors.white;
  final Color _textColor = Colors.black87;
  final Color _hintColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: _backgroundColor,
        appBar: AppBar(
          leading: Container(),
          automaticallyImplyLeading: false,
          elevation: 0.5,
          backgroundColor: Colors.white,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black87),
          title: const Text(
            'Service Management',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          bottom: const TabBar(
            labelColor: Colors.redAccent,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.redAccent,
            indicatorWeight: 3,
            labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            unselectedLabelStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            tabs: [
              Tab(text: 'Categories'),
              Tab(text: 'Sub-categories'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CategoriesTab(
              categories: _categories,
              primaryColor: _primaryColor,
              backgroundColor: _backgroundColor,
              cardColor: _cardColor,
              textColor: _textColor,
              hintColor: _hintColor,
              onEditCategory: (category) =>
                  _showCategoryForm(category: category),
              onDeleteCategory: _deleteCategory,
            ),
            SubCategoriesTab(
              categories: _categories,
              primaryColor: _primaryColor,
              backgroundColor: _backgroundColor,
              cardColor: _cardColor,
              textColor: _textColor,
              hintColor: _hintColor,
              onEditSubCategory: (subCategory) =>
                  _showSubCategoryForm(subCategory: subCategory),
              onDeleteSubCategory: _deleteSubCategory,
            ),
          ],
        ),
        floatingActionButton: CustomFloatingActionButton(
          categories: _categories,
          onAddCategory: _showCategoryForm,
          onAddSubCategory: _showSubCategoryForm,
        ),
      ),
    );
  }

  //  CATEGORY FORM
  void _showCategoryForm({ServiceCategory? category}) {
    final nameController = TextEditingController(text: category?.name ?? '');

    String? currentImagePath = category?.imagePath;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return CategoryForm(
              category: category,
              nameController: nameController,
              imagePath: currentImagePath,
              primaryColor: _primaryColor,
              onImagePick: () async {
                final image = await _pickImage();
                if (image != null) {
                  setModalState(() {
                    currentImagePath = image;
                  });
                }
              },
              onSave: () {
                _saveCategory(
                  category: category,
                  name: nameController.text.trim(),
                  imagePath: currentImagePath,
                  context: context,
                );
              },
            );
          },
        );
      },
    );
  }

  void _saveCategory({
    ServiceCategory? category,
    required String name,
    required String? imagePath,
    required BuildContext context,
  }) {
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a category name'),
          backgroundColor: _primaryColor,
        ),
      );
      return;
    }

    setState(() {
      if (category == null) {
        _categories.add(
          ServiceCategory(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: name,
            imagePath: imagePath,
            createdAt: DateTime.now(),
          ),
        );
      } else {
        final index = _categories.indexWhere((c) => c.id == category.id);
        _categories[index] = category.copyWith(
          name: name,
          imagePath: imagePath,
        );
      }
    });
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          category == null ? 'Category added!' : 'Category updated!',
        ),
        backgroundColor: _primaryColor,
      ),
    );
  }

  // SUB-CATEGORY FORM
  void _showSubCategoryForm({SubCategory? subCategory}) {
    if (_categories.isEmpty && subCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please create a category first'),
          backgroundColor: _primaryColor,
        ),
      );
      return;
    }

    final nameController = TextEditingController(text: subCategory?.name ?? '');
    final priceController = TextEditingController(
      text: subCategory?.price.toString() ?? '',
    );

    String? currentImagePath = subCategory?.imagePath;

    ServiceCategory? selectedCategory = subCategory != null
        ? _categories.firstWhere(
          (cat) => cat.subCategories.contains(subCategory),
    )
        : (_categories.isNotEmpty ? _categories.first : null);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SubCategoryForm(
              subCategory: subCategory,
              categories: _categories,
              selectedCategory: selectedCategory,
              nameController: nameController,
              priceController: priceController,
              imagePath: currentImagePath,
              primaryColor: _primaryColor,
              onCategoryChange: (category) {
                setModalState(() {
                  selectedCategory = category;
                });
              },
              onImagePick: () async {
                final image = await _pickImage();
                if (image != null) {
                  setModalState(() {
                    currentImagePath = image;
                  });
                }
              },
              onSave: () {
                _saveSubCategory(
                  subCategory: subCategory,
                  name: nameController.text.trim(),
                  price: double.tryParse(priceController.text) ?? 0,
                  imagePath: currentImagePath,
                  selectedCategory: selectedCategory,
                  context: context,
                );
              },
            );
          },
        );
      },
    );
  }

  void _saveSubCategory({
    SubCategory? subCategory,
    required String name,
    required double price,
    required String? imagePath,
    required ServiceCategory? selectedCategory,
    required BuildContext context,
  }) {
    if (name.isEmpty || selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill all required fields'),
          backgroundColor: _primaryColor,
        ),
      );
      return;
    }

    setState(() {
      final categoryIndex = _categories.indexWhere(
            (c) => c.id == selectedCategory.id,
      );
      final updatedSubCategories = List<SubCategory>.from(
        _categories[categoryIndex].subCategories,
      );

      if (subCategory == null) {
        updatedSubCategories.add(
          SubCategory(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: name,
            imagePath: imagePath,
            price: price,
            createdAt: DateTime.now(),
          ),
        );
      } else {
        final subIndex = updatedSubCategories.indexWhere(
              (s) => s.id == subCategory.id,
        );
        updatedSubCategories[subIndex] = subCategory.copyWith(
          name: name,
          imagePath: imagePath,
          price: price,
        );
      }

      _categories[categoryIndex] = _categories[categoryIndex].copyWith(
        subCategories: updatedSubCategories,
      );
    });
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          subCategory == null ? 'Sub-category added!' : 'Sub-category updated!',
        ),
        backgroundColor: _primaryColor,
      ),
    );
  }

  // IMAGE PICKER
  Future<String?> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
      );
      return image?.path;
    } catch (e) {
      debugPrint('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }
  }

  //  DELETE OPERATIONS
  void _deleteCategory(ServiceCategory category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: const Text(
          'This will also delete all sub-categories under this category.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _categories.removeWhere((c) => c.id == category.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Category "${category.name}" deleted'),
                  backgroundColor: _primaryColor,
                ),
              );
            },
            child: Text('Delete', style: TextStyle(color: _primaryColor)),
          ),
        ],
      ),
    );
  }

  void _deleteSubCategory(SubCategory subCategory) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Sub-category'),
        content: const Text(
          'Are you sure you want to delete this sub-category?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                for (int i = 0; i < _categories.length; i++) {
                  final category = _categories[i];
                  if (category.subCategories.contains(subCategory)) {
                    final updatedSubs = category.subCategories
                        .where((s) => s.id != subCategory.id)
                        .toList();
                    _categories[i] = category.copyWith(
                      subCategories: updatedSubs,
                    );
                    break;
                  }
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Sub-category "${subCategory.name}" deleted'),
                  backgroundColor: _primaryColor,
                ),
              );
            },
            child: Text('Delete', style: TextStyle(color: _primaryColor)),
          ),
        ],
      ),
    );
  }
}