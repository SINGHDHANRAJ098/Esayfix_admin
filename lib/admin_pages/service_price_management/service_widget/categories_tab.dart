import 'dart:io';
import 'package:flutter/material.dart';
import '../service_model/service_category.dart';

class CategoriesTab extends StatelessWidget {
  final List<ServiceCategory> categories;
  final Color primaryColor;
  final Color backgroundColor;
  final Color cardColor;
  final Color textColor;
  final Color hintColor;
  final Function(ServiceCategory) onEditCategory;
  final Function(ServiceCategory) onDeleteCategory;

  const CategoriesTab({
    super.key,
    required this.categories,
    required this.primaryColor,
    required this.backgroundColor,
    required this.cardColor,
    required this.textColor,
    required this.hintColor,
    required this.onEditCategory,
    required this.onDeleteCategory,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategoryCard(category);
      },
    );
  }

  Widget _buildCategoryCard(ServiceCategory category) {
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
            _buildCategoryImage(category),
            const SizedBox(width: 16),

            // Category Name and Sub-categories count
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Name
                  Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Total sub-categories
                  Text(
                    '${category.subCategories.length} sub-categories',
                    style: TextStyle(fontSize: 13, color: hintColor),
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
                  icon: Icon(
                    Icons.edit_outlined,
                    size: 22,
                    color: primaryColor,
                  ),
                  onPressed: () => onEditCategory(category),
                ),

                // Delete Button
                IconButton(
                  icon: Icon(Icons.delete_outline, size: 22, color: Colors.red),
                  onPressed: () => onDeleteCategory(category),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryImage(ServiceCategory category) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: primaryColor.withOpacity(0.1),
      ),
      child:
      category.imagePath != null && File(category.imagePath!).existsSync()
          ? ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          File(category.imagePath!),
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
      child: Icon(Icons.category_rounded, size: 28, color: primaryColor),
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
              Icons.category_outlined,
              size: 64,
              color: hintColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No Categories Yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to add your first category',
              style: TextStyle(fontSize: 14, color: hintColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}