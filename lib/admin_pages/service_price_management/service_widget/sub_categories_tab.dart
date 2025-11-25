// lib/widgets/sub_categories_tab.dart
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
    final allSubCategories =
    categories.expand((cat) => cat.subCategories).toList();

    if (allSubCategories.isEmpty) {
      return _buildEmptyState(
        icon: Icons.list_alt_outlined,
        title: 'No Sub-categories Yet',
        subtitle: 'Add sub-categories under existing categories',
        hintColor: hintColor,
      );
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

  Widget _buildSubCategoryCard(
      SubCategory subCategory,
      ServiceCategory parentCategory,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSubCategoryImage(subCategory),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          subCategory.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        color: primaryColor,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => onEditSubCategory(subCategory),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Under: ${parentCategory.name}',
                    style: TextStyle(
                      fontSize: 12,
                      color: hintColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '₹${subCategory.fixedPrice.toStringAsFixed(0)} • ₹${subCategory.visitPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: Colors.red,
              onPressed: () => onDeleteSubCategory(subCategory),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubCategoryImage(SubCategory subCategory) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 50,
        height: 50,
        color: primaryColor.withOpacity(0.08),
        child: subCategory.imagePath != null
            ? Image.file(
          File(subCategory.imagePath!),
          fit: BoxFit.cover,
        )
            : Icon(
          Icons.article_rounded,
          color: primaryColor,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color hintColor,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: hintColor.withOpacity(0.7)),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: TextStyle(fontSize: 13, color: hintColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}