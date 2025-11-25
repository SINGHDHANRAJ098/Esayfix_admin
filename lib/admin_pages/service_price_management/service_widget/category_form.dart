// lib/widgets/category_form.dart
import 'dart:io';
import 'package:flutter/material.dart';

import '../service_model/service_category.dart';


class CategoryForm extends StatefulWidget {
  final ServiceCategory? category;
  final TextEditingController nameController;
  final TextEditingController fixedPriceController;
  final TextEditingController visitPriceController;
  final String? imagePath;
  final Color primaryColor;
  final VoidCallback onImagePick;
  final VoidCallback onSave;

  const CategoryForm({
    super.key,
    this.category,
    required this.nameController,
    required this.fixedPriceController,
    required this.visitPriceController,
    required this.imagePath,
    required this.primaryColor,
    required this.onImagePick,
    required this.onSave,
  });

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      duration: const Duration(milliseconds: 100),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Title
              Center(
                child: Text(
                  widget.category == null ? 'Add Category' : 'Edit Category',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Image picker section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add a category image (optional)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: widget.onImagePick,
                    child: Container(
                      width: double.infinity,
                      height: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: widget.primaryColor.withOpacity(0.05),
                        border: Border.all(
                          color: widget.primaryColor.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: widget.imagePath != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          File(widget.imagePath!),
                          fit: BoxFit.cover,
                        ),
                      )
                          : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo_rounded,
                            size: 40,
                            color: widget.primaryColor.withOpacity(0.7),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Tap to add image',
                            style: TextStyle(
                              fontSize: 15,
                              color: widget.primaryColor.withOpacity(0.8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Category Name section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Category Name',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: widget.nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter category name',
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8F9FA),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: widget.primaryColor,
                          width: 2,
                        ),
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Pricing section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pricing',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fixed Price (\$)',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: widget.fixedPriceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                prefixText: '\$ ',
                                prefixStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                                hintText: '0',
                                hintStyle: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 15,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF8F9FA),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: widget.primaryColor,
                                    width: 2,
                                  ),
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Visit Price (\$)',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: widget.visitPriceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                prefixText: '\$ ',
                                prefixStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                                hintText: '0',
                                hintStyle: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 15,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF8F9FA),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: widget.primaryColor,
                                    width: 2,
                                  ),
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Add Category Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: widget.onSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    shadowColor: widget.primaryColor.withOpacity(0.3),
                  ),
                  child: Text(
                    widget.category == null ? 'Add Category' : 'Save Changes',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Extra bottom padding for safety
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}