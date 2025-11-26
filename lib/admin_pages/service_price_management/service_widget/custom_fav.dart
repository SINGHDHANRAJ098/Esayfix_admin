// lib/service_widget/custom_fav.dart
import 'package:flutter/material.dart';
import '../service_model/service_category.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final List<ServiceCategory> categories;
  final VoidCallback onAddCategory;
  final VoidCallback onAddSubCategory;

  const CustomFloatingActionButton({
    super.key,
    required this.categories,
    required this.onAddCategory,
    required this.onAddSubCategory,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        final defaultTabController = DefaultTabController.of(context);
        if (defaultTabController != null) {
          final currentIndex = defaultTabController.index;
          if (currentIndex == 0 || categories.isEmpty) {
            onAddCategory();
          } else {
            onAddSubCategory();
          }
        }
      },
      backgroundColor: Colors.redAccent,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.add, size: 22),
      label: const Text(
        'Add',
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}