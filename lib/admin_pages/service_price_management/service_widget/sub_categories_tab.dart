// lib/service_widget/sub_categories_tab.dart
import 'dart:io';
import 'package:flutter/material.dart';
import '../service_model/service_category.dart';

class SubCategoriesTab extends StatelessWidget {
  final List<ServiceCategory> categories;
  final Color primaryColor;
  final Color backgroundColor;
  final Color cardColor;
  final Color textColor;
  final Color hintColor;
  final Function(SubCategory) onEditSubCategory;
  final Function(SubCategory) onDeleteSubCategory;

  const SubCategoriesTab({
    super.key,
    required this.categories,
    required this.primaryColor,
    required this.backgroundColor,
    required this.cardColor,
    required this.textColor,
    required this.hintColor,
    required this.onEditSubCategory,
    required this.onDeleteSubCategory,
  });

  @override
  Widget build(BuildContext context) {
    final allSubCategories = categories.expand((cat) => cat.subCategories).toList();

    if (allSubCategories.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: allSubCategories.length,
      itemBuilder: (context, index) {
        final subCategory = allSubCategories[index];
        final parentCategory = categories.firstWhere(
              (cat) => cat.subCategories.contains(subCategory),
        );
        return _buildSubCategoryCard(subCategory, parentCategory);
      },
    );
  }

  Widget _buildSubCategoryCard(SubCategory subCategory, ServiceCategory parentCategory) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Image
            _buildSubCategoryImage(subCategory),
            const SizedBox(width: 16),

            // Sub-category Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sub-category Name
                  Text(
                    subCategory.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Parent Category
                  Text(
                    'Under: ${parentCategory.name}',
                    style: TextStyle(
                      fontSize: 13,
                      color: hintColor,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Price
                  Text(
                    'Price: \$${subCategory.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            // Action Buttons
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Edit Button
                IconButton(
                  icon: Icon(Icons.edit_outlined, size: 22, color: primaryColor),
                  onPressed: () => onEditSubCategory(subCategory),
                ),

                // Delete Button
                IconButton(
                  icon: Icon(Icons.delete_outline, size: 22, color: Colors.red),
                  onPressed: () => onDeleteSubCategory(subCategory),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubCategoryImage(SubCategory subCategory) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: primaryColor.withOpacity(0.1),
      ),
      child: subCategory.imagePath != null && File(subCategory.imagePath!).existsSync()
          ? ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          File(subCategory.imagePath!),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholderIcon();
          },
        ),
      )
          : _buildPlaceholderIcon(),
    );
  }

  Widget _buildPlaceholderIcon() {
    return Center(
      child: Icon(
        Icons.article_rounded,
        size: 28,
        color: primaryColor,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.list_alt_outlined,
              size: 64,
              color: hintColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No Sub-categories Yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Add sub-categories under existing categories',
              style: TextStyle(
                fontSize: 14,
                color: hintColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}