// lib/service_model/service_category.dart
class ServiceCategory {
  final String id;
  final String name;
  final String? imagePath;
  final double price; // Changed from fixedPrice
  final List<SubCategory> subCategories;
  final DateTime createdAt;

  ServiceCategory({
    required this.id,
    required this.name,
    this.imagePath,
    required this.price,
    List<SubCategory>? subCategories,
    required this.createdAt,
  }) : subCategories = subCategories ?? [];

  ServiceCategory copyWith({
    String? id,
    String? name,
    String? imagePath,
    double? price,
    List<SubCategory>? subCategories,
    DateTime? createdAt,
  }) {
    return ServiceCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      price: price ?? this.price,
      subCategories: subCategories ?? this.subCategories,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class SubCategory {
  final String id;
  final String name;
  final String? imagePath;
  final double price; // Changed from fixedPrice
  final DateTime createdAt;

  SubCategory({
    required this.id,
    required this.name,
    this.imagePath,
    required this.price,
    required this.createdAt,
  });

  SubCategory copyWith({
    String? id,
    String? name,
    String? imagePath,
    double? price,
    DateTime? createdAt,
  }) {
    return SubCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}