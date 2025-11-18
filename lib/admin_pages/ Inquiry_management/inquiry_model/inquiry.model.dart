// models/inquiry_model.dart
import 'inquiry_provider_model.dart';
import 'inquiry_status_model.dart';

class Inquiry {
  final String id;
  final String customer;
  final String customerPhone;
  final String service;
  final String location;
  final String date;
  final String time;
  final double price;
  InquiryStatus status;
  ProviderModel? provider;
  final String? notes;
  final String? deadline;

  Inquiry({
    required this.id,
    required this.customer,
    required this.customerPhone,
    required this.service,
    required this.location,
    required this.date,
    required this.time,
    required this.price,
    this.status = InquiryStatus.pending,
    this.provider,
    this.notes,
    this.deadline,
  });
}