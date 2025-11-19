// models/inquiry_model.dart
import 'package:flutter/material.dart';
import 'inquiry_provider_model.dart';
import 'inquiry_status_model.dart';

class Inquiry {
  final String id;
  final String customer;
  final String service;
  final String location;
  final String date;
  final String time;
  InquiryStatus status;
  ProviderModel? provider;
  final String? customerPhone;
  final String? customerAddress;
  double? price;
  final String? userNotes;
  String? adminNotes;
  PaymentStatus paymentStatus;
  PaymentMethod? paymentMethod;
  DateTime? assignedAt;
  DateTime? completedAt;
  DateTime? cancelledAt;

  Inquiry({
    required this.id,
    required this.customer,
    required this.service,
    required this.location,
    required this.date,
    required this.time,
    required this.status,
    this.provider,
    this.customerPhone,
    this.customerAddress,
    this.price,
    this.userNotes,
    this.adminNotes,
    this.paymentStatus = PaymentStatus.unpaid,
    this.paymentMethod,
    this.assignedAt,
    this.completedAt,
    this.cancelledAt,
  });

  // Add copyWith method to create updated instances
  Inquiry copyWith({
    String? id,
    String? customer,
    String? service,
    String? location,
    String? date,
    String? time,
    InquiryStatus? status,
    ProviderModel? provider,
    String? customerPhone,
    String? customerAddress,
    double? price,
    String? userNotes,
    String? adminNotes,
    PaymentStatus? paymentStatus,
    PaymentMethod? paymentMethod,
    DateTime? assignedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
  }) {
    return Inquiry(
      id: id ?? this.id,
      customer: customer ?? this.customer,
      service: service ?? this.service,
      location: location ?? this.location,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      provider: provider ?? this.provider,
      customerPhone: customerPhone ?? this.customerPhone,
      customerAddress: customerAddress ?? this.customerAddress,
      price: price ?? this.price,
      userNotes: userNotes ?? this.userNotes,
      adminNotes: adminNotes ?? this.adminNotes,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      assignedAt: assignedAt ?? this.assignedAt,
      completedAt: completedAt ?? this.completedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
    );
  }
}

enum PaymentStatus {
  unpaid,
  paid,
  partiallyPaid,
  refunded,
}

extension PaymentStatusX on PaymentStatus {
  String get label {
    switch (this) {
      case PaymentStatus.unpaid:
        return "Unpaid";
      case PaymentStatus.paid:
        return "Paid";
      case PaymentStatus.partiallyPaid:
        return "Partially Paid";
      case PaymentStatus.refunded:
        return "Refunded";
    }
  }

  Color get color {
    switch (this) {
      case PaymentStatus.unpaid:
        return Colors.red;
      case PaymentStatus.paid:
        return Colors.green;
      case PaymentStatus.partiallyPaid:
        return Colors.orange;
      case PaymentStatus.refunded:
        return Colors.blue;
    }
  }

  IconData get icon {
    switch (this) {
      case PaymentStatus.unpaid:
        return Icons.money_off;
      case PaymentStatus.paid:
        return Icons.attach_money;
      case PaymentStatus.partiallyPaid:
        return Icons.money;
      case PaymentStatus.refunded:
        return Icons.refresh;
    }
  }
}

enum PaymentMethod {
  cash,
  card,
  online,
  bankTransfer,
}

extension PaymentMethodX on PaymentMethod {
  String get label {
    switch (this) {
      case PaymentMethod.cash:
        return "Cash";
      case PaymentMethod.card:
        return "Card";
      case PaymentMethod.online:
        return "online";
      case PaymentMethod.bankTransfer:
        return "Bank Transfer";
    }
  }

  IconData get icon {
    switch (this) {
      case PaymentMethod.cash:
        return Icons.money;
      case PaymentMethod.card:
        return Icons.credit_card;
      case PaymentMethod.online:
        return Icons.phone_android;
      case PaymentMethod.bankTransfer:
        return Icons.account_balance;
    }
  }
}