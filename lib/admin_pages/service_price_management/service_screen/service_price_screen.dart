import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../service_model/service_category.dart';

class ServicePriceScreen extends StatefulWidget {
  const ServicePriceScreen({Key? key}) : super(key: key);

  @override
  State<ServicePriceScreen> createState() => _ServicePriceScreenState();
}

class _ServicePriceScreenState extends State<ServicePriceScreen> {
  final List<ServiceCategory> _categories = [];
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff0f0f0), // light grey
      appBar: AppBar(
        title: const Text(
          'Service & Pricing Management',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        onPressed: () => _openCategoryForm(),
        icon: const Icon(Icons.add),
        label: const Text("Add Category"),
      ),

      body: _categories.isEmpty
          ? const Center(
              child: Text(
                "No categories added yet.\nTap 'Add Category' to create one.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _categories.length,
              itemBuilder: (context, index) =>
                  _buildCategoryCard(_categories[index]),
            ),
    );
  }

  // CATEGORY CARD — clean, white, modern UI

  Widget _buildCategoryCard(ServiceCategory c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCategoryImage(c.imagePath, c.name),
                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.name,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Fixed Price: ₹${c.fixedPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 14.5,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Visit Price: ₹${c.visitPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 14.5,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  children: [
                    IconButton(
                      onPressed: () => _openCategoryForm(editing: c),
                      icon: const Icon(Icons.edit, size: 22),
                      color: Colors.blueAccent,
                    ),
                    IconButton(
                      onPressed: () => _deleteCategory(c),
                      icon: const Icon(Icons.delete, size: 22),
                      color: Colors.redAccent,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Sub-category header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Sub-categories (${c.subCategories.length})",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () => _openSubCategoryForm(parent: c),
                  child: const Text(
                    "Add",
                    style: TextStyle(color: Colors.redAccent, fontSize: 14.5),
                  ),
                ),
              ],
            ),

            if (c.subCategories.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  "No sub-categories added yet",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            else
              Column(
                children: c.subCategories
                    .map((s) => _buildSubCategoryTile(c, s))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryImage(String? path, String name) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.redAccent.withOpacity(0.15),
      backgroundImage: (path != null && path.isNotEmpty)
          ? FileImage(File(path))
          : null,
      child: (path == null || path.isEmpty)
          ? Text(
              name.isNotEmpty ? name[0].toUpperCase() : "?",
              style: const TextStyle(
                fontSize: 22,
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
    );
  }

  // -------------------------------------------------------------
  // SUB CATEGORY CARD — clean white tile
  // -------------------------------------------------------------
  Widget _buildSubCategoryTile(ServiceCategory parent, SubCategory s) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white, // white tile
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        children: [
          _buildSubImage(s.imagePath, s.name),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Fixed: ₹${s.fixedPrice}",
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                Text(
                  "Visit: ₹${s.visitPrice}",
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),

          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                color: Colors.blueAccent,
                onPressed: () =>
                    _openSubCategoryForm(parent: parent, editing: s),
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 20),
                color: Colors.redAccent,
                onPressed: () => _deleteSub(parent, s),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubImage(String? path, String name) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: Colors.redAccent.withOpacity(0.12),
      backgroundImage: (path != null && path.isNotEmpty)
          ? FileImage(File(path))
          : null,
      child: (path == null || path.isEmpty)
          ? Text(
              name.isNotEmpty ? name[0].toUpperCase() : "?",
              style: const TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            )
          : null,
    );
  }

  // -------------------------------------------------------------
  // CATEGORY FORM
  // -------------------------------------------------------------
  Future<void> _openCategoryForm({ServiceCategory? editing}) async {
    final name = TextEditingController(text: editing?.name ?? "");
    final fixed = TextEditingController(
      text: editing != null ? "${editing.fixedPrice}" : "",
    );
    final visit = TextEditingController(
      text: editing != null ? "${editing.visitPrice}" : "",
    );

    String? imagePath = editing?.imagePath;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),

      builder: (_) {
        return _bottomSheet(
          title: editing == null ? "Add Category" : "Edit Category",
          name: name,
          fixed: fixed,
          visit: visit,
          imagePath: imagePath,
          onPickImage: () async {
            final img = await _pickImageChoice();
            if (img != null) setState(() => imagePath = img);
          },
          buttonText: editing == null ? "Add Category" : "Save",
          onSubmit: () {
            final n = name.text.trim();
            final f = double.tryParse(fixed.text.trim());
            final v = double.tryParse(visit.text.trim());

            if (n.isEmpty || f == null || v == null) {
              _error("Please fill all fields");
              return;
            }

            if (editing == null) {
              setState(() {
                _categories.add(
                  ServiceCategory(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: n,
                    fixedPrice: f,
                    visitPrice: v,
                    imagePath: imagePath,
                    createdAt: DateTime.now(),
                  ),
                );
              });
            } else {
              setState(() {
                final index = _categories.indexWhere(
                  (item) => item.id == editing.id,
                );
                _categories[index] = editing.copyWith(
                  name: n,
                  fixedPrice: f,
                  visitPrice: v,
                  imagePath: imagePath,
                );
              });
            }

            Navigator.pop(context);
          },
        );
      },
    );
  }

  // -------------------------------------------------------------
  // SUB-CATEGORY FORM
  // -------------------------------------------------------------
  Future<void> _openSubCategoryForm({
    required ServiceCategory parent,
    SubCategory? editing,
  }) async {
    final name = TextEditingController(text: editing?.name ?? "");
    final fixed = TextEditingController(
      text: editing != null ? "${editing.fixedPrice}" : "",
    );
    final visit = TextEditingController(
      text: editing != null ? "${editing.visitPrice}" : "",
    );

    String? imagePath = editing?.imagePath;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),

      builder: (_) {
        return _bottomSheet(
          title: editing == null ? "Add Sub-category" : "Edit Sub-category",
          name: name,
          fixed: fixed,
          visit: visit,
          imagePath: imagePath,
          onPickImage: () async {
            final img = await _pickImageChoice();
            if (img != null) setState(() => imagePath = img);
          },
          buttonText: editing == null ? "Add" : "Save",
          onSubmit: () {
            final n = name.text.trim();
            final f = double.tryParse(fixed.text.trim());
            final v = double.tryParse(visit.text.trim());

            if (n.isEmpty || f == null || v == null) {
              _error("Please fill all fields");
              return;
            }

            final index = _categories.indexWhere((c) => c.id == parent.id);
            final cat = _categories[index];
            final updated = List<SubCategory>.from(cat.subCategories);

            if (editing == null) {
              updated.add(
                SubCategory(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: n,
                  fixedPrice: f,
                  visitPrice: v,
                  imagePath: imagePath,
                  createdAt: DateTime.now(),
                ),
              );
            } else {
              final subIndex = updated.indexWhere((s) => s.id == editing.id);
              updated[subIndex] = editing.copyWith(
                name: n,
                fixedPrice: f,
                visitPrice: v,
                imagePath: imagePath,
              );
            }

            setState(() {
              _categories[index] = cat.copyWith(subCategories: updated);
            });

            Navigator.pop(context);
          },
        );
      },
    );
  }

  // -------------------------------------------------------------
  // DELETE
  // -------------------------------------------------------------
  void _deleteCategory(ServiceCategory c) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Category"),
        content: const Text("This will also delete all sub-categories."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() => _categories.removeWhere((e) => e.id == c.id));
              Navigator.pop(context);
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteSub(ServiceCategory parent, SubCategory sub) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Sub-category"),
        content: const Text(
          "Are you sure you want to delete this sub-category?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final index = _categories.indexWhere((c) => c.id == parent.id);
              final updated = _categories[index].subCategories
                  .where((s) => s.id != sub.id)
                  .toList();

              setState(() {
                _categories[index] = _categories[index].copyWith(
                  subCategories: updated,
                );
              });

              Navigator.pop(context);
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // IMAGE PICKER
  // -------------------------------------------------------------
  Future<String?> _pickImageChoice() async {
    String? picked;

    await showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Choose from Gallery"),
              onTap: () async {
                final img = await _picker.pickImage(
                  source: ImageSource.gallery,
                );
                picked = img?.path;
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take Photo"),
              onTap: () async {
                final img = await _picker.pickImage(source: ImageSource.camera);
                picked = img?.path;
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );

    return picked;
  }

  // -------------------------------------------------------------
  // BOTTOM SHEET UI — clean and beautiful
  // -------------------------------------------------------------
  Widget _bottomSheet({
    required String title,
    required TextEditingController name,
    required TextEditingController fixed,
    required TextEditingController visit,
    required String? imagePath,
    required VoidCallback onPickImage,
    required String buttonText,
    required VoidCallback onSubmit,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: 18,
        right: 18,
        top: 18,
        bottom: MediaQuery.of(context).viewInsets.bottom + 18,
      ),

      child: ListView(
        shrinkWrap: true,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              _buildCategoryImage(imagePath, name.text),
              const SizedBox(width: 14),
              ElevatedButton(
                onPressed: onPickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Pick Image"),
              ),
            ],
          ),

          const SizedBox(height: 20),

          TextField(
            controller: name,
            decoration: InputDecoration(
              labelText: "Name",
              labelStyle: const TextStyle(fontSize: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: fixed,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Fixed Price",
                    prefixText: "₹ ",
                    labelStyle: const TextStyle(fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: TextField(
                  controller: visit,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Visit Price",
                    prefixText: "₹ ",
                    labelStyle: const TextStyle(fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _error(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
