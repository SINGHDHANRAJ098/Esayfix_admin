// models/inquiry_model.dart
import 'package:easyfix_admin/admin_pages/%20Inquiry_management/inquiry_model/additional_services.dart';
import 'package:flutter/material.dart';
import 'inquiry_provider_model.dart';
import 'inquiry_status_model.dart';




// SERVICE ITEM MODEL (for multiple main services)

class ServiceItem {
  final String name;
  final int qty;
  final double price;

  ServiceItem({
    required this.name,
    required this.qty,
    required this.price,
  });

  ServiceItem copyWith({
    String? name,
    int? qty,
    double? price,
  }) {
    return ServiceItem(
      name: name ?? this.name,
      qty: qty ?? this.qty,
      price: price ?? this.price,
    );
  }
}


//INQUIRY MODEL

class Inquiry {
  final String id;
  final String customer;
  final String service;
  final String location;
  final String date;
  final String time;
  final DateTime createdAt;

  InquiryStatus status;
  ProviderModel? provider;

  final String? customerPhone;
  final String? customerAddress;

  //MULTIPLE MAIN SERVICES LIST

  List<ServiceItem> items;

  /// ----------------------------------------
  /// ADDITIONAL SERVICES (⭐ NEW)
  /// ----------------------------------------
  List<AdditionalService> additionalServices;

  /// ----------------------------------------
  /// PRICING
  /// ----------------------------------------
  double? price;             // booking / advance amount
  double additionalAmount;   // manual extra charge

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
    required this.createdAt,
    required this.items,

    this.additionalServices = const [],       // ⭐ DEFAULT EMPTY LIST
    this.provider,
    this.customerPhone,
    this.customerAddress,
    this.price,
    this.additionalAmount = 0,
    this.userNotes,
    this.adminNotes,
    this.paymentStatus = PaymentStatus.unpaid,
    this.paymentMethod,
    this.assignedAt,
    this.completedAt,
    this.cancelledAt,
  });

  /// ----------------------------------------
  /// TOTAL CALCULATIONS
  /// ----------------------------------------
  double get serviceTotal =>
      items.fold(0.0, (sum, item) => sum + (item.qty * item.price));

  double get additionalServiceTotal =>
      additionalServices.fold(0.0, (sum, item) => sum + item.total);

  double get payableAmount =>
      serviceTotal + additionalServiceTotal + additionalAmount - (price ?? 0);

  /// ----------------------------------------
  /// COPY-WITH
  /// ----------------------------------------
  Inquiry copyWith({
    String? id,
    String? customer,
    String? service,
    String? location,
    String? date,
    String? time,
    DateTime? createdAt,
    InquiryStatus? status,
    ProviderModel? provider,
    String? customerPhone,
    String? customerAddress,
    List<ServiceItem>? items,
    List<AdditionalService>? additionalServices,
    double? price,
    double? additionalAmount,
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
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      provider: provider ?? this.provider,
      customerPhone: customerPhone ?? this.customerPhone,
      customerAddress: customerAddress ?? this.customerAddress,
      items: items ?? this.items,
      additionalServices: additionalServices ?? this.additionalServices, // ⭐ REQUIRED
      price: price ?? this.price,
      additionalAmount: additionalAmount ?? this.additionalAmount,
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


/// ----------------------------------------------------------
/// PAYMENT STATUS ENUM
/// ----------------------------------------------------------
enum PaymentStatus { unpaid, paid, partiallyPaid, refunded }

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
}


/// ----------------------------------------------------------
/// PAYMENT METHOD ENUM
/// ----------------------------------------------------------
enum PaymentMethod { cash, card, online, bankTransfer }

extension PaymentMethodX on PaymentMethod {
  String get label {
    switch (this) {
      case PaymentMethod.cash:
        return "Cash";
      case PaymentMethod.card:
        return "Card";
      case PaymentMethod.online:
        return "Online";
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
