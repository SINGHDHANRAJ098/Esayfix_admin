// models/inquiry_provider_model.dart
class ProviderModel {
  final String id;
  final String name;
  final String phone;
  final String specialty;

  final bool available;

  ProviderModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.specialty,

    this.available = true,
  });
}