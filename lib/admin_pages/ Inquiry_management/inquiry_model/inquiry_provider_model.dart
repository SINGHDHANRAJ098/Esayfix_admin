// models/inquiry_provider_model.dart
class ProviderModel {
  final String id;
  final String name;
  final String phone;
  final String specialty;
  final double rating;
  final bool available;

  ProviderModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.specialty,
    this.rating = 0.0,
    this.available = true,
  });
}