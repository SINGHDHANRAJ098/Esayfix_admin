// provider_management/provider_model/provider_model.dart
import 'package:flutter/material.dart';

enum ProviderStatus { active, inactive }

class ProviderModel {
  final String id;
  final String name;
  final String phone;
  final String specialty;
  final ProviderStatus status;
  final int totalServicesAssigned;
  final int totalServicesCompleted;

  ProviderModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.specialty,
    required this.status,
    required this.totalServicesAssigned,
    required this.totalServicesCompleted,
  });

  double get completionRate {
    if (totalServicesAssigned == 0) return 0.0;
    return (totalServicesCompleted / totalServicesAssigned) * 100;
  }
}

extension ProviderStatusX on ProviderStatus {
  String get label {
    switch (this) {
      case ProviderStatus.active:
        return "Active";
      case ProviderStatus.inactive:
        return "Inactive";
    }
  }

  Color get color {
    switch (this) {
      case ProviderStatus.active:
        return Colors.green;
      case ProviderStatus.inactive:
        return Colors.grey;
    }
  }
}
