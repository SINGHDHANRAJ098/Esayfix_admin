import 'package:flutter/foundation.dart';

class SubCategory {
  final String id;
  final String name;
  final String? imagePath;     // local file path
  final double fixedPrice;
  final double visitPrice;
  final DateTime createdAt;

  SubCategory({
    required this.id,
    required this.name,
    this.imagePath,
    required this.fixedPrice,
    required this.visitPrice,
    required this.createdAt,
  });

  SubCategory copyWith({
    String? id,
    String? name,
    String? imagePath,
    double? fixedPrice,
    double? visitPrice,
    DateTime? createdAt,
  }) {
    return SubCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      fixedPrice: fixedPrice ?? this.fixedPrice,
      visitPrice: visitPrice ?? this.visitPrice,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ServiceCategory {
  final String id;
  final String name;
  final String? imagePath;     // local file path
  final double fixedPrice;
  final double visitPrice;
  final List<SubCategory> subCategories;
  final DateTime createdAt;

  ServiceCategory({
    required this.id,
    required this.name,
    this.imagePath,
    required this.fixedPrice,
    required this.visitPrice,
    this.subCategories = const [],
    required this.createdAt,
  });

  ServiceCategory copyWith({
    String? id,
    String? name,
    String? imagePath,
    double? fixedPrice,
    double? visitPrice,
    List<SubCategory>? subCategories,
    DateTime? createdAt,
  }) {
    return ServiceCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      fixedPrice: fixedPrice ?? this.fixedPrice,
      visitPrice: visitPrice ?? this.visitPrice,
      subCategories: subCategories ?? this.subCategories,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
