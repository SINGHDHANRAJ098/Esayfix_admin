// lib/widgets/categories_tab.dart
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
      return _buildEmptyState(
        icon: Icons.category_outlined,
        title: 'No Categories Yet',
        subtitle: 'Tap the + button to add your first category',
        hintColor: hintColor,
      );
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
      margin: const EdgeInsets.only(bottom: 14),
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
            _buildCategoryImage(category),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          category.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        color: primaryColor,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => onEditCategory(category),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${category.subCategories.length} sub-services',
                    style: TextStyle(
                      fontSize: 12,
                      color: hintColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7F7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _priceColumn(
                            label: 'Fixed Price',
                            value: '₹${category.fixedPrice.toStringAsFixed(0)}',
                            hintColor: hintColor,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 24,
                          color: Colors.grey.shade300,
                        ),
                        Expanded(
                          child: _priceColumn(
                            label: 'Visit Price',
                            value: '₹${category.visitPrice.toStringAsFixed(0)}',
                            alignEnd: true,
                            hintColor: hintColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: Colors.red,
              onPressed: () => onDeleteCategory(category),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryImage(ServiceCategory category) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 56,
        height: 56,
        color: primaryColor.withOpacity(0.08),
        child: category.imagePath != null
            ? Image.file(
          File(category.imagePath!),
          fit: BoxFit.cover,
        )
            : Icon(
          Icons.home_repair_service_rounded,
          color: primaryColor,
          size: 28,
        ),
      ),
    );
  }

  Widget _priceColumn({
    required String label,
    required String value,
    bool alignEnd = false,
    required Color hintColor,
  }) {
    return Column(
      crossAxisAlignment:
      alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: hintColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
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