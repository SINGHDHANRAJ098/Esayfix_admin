// lib/admin_pages/Inquiry_management/inquiry_data_service/inquiry_data_service.dart

import '../inquiry_model/inquiry.model.dart';
import '../inquiry_model/inquiry_provider_model.dart';
import '../inquiry_model/inquiry_status_model.dart';

class InquiryDataService {
  static final InquiryDataService _instance = InquiryDataService._internal();
  factory InquiryDataService() => _instance;
  InquiryDataService._internal();

  List<Inquiry> _inquiries = [];
  List<ProviderModel> _providers = [];

  List<Inquiry> get inquiries => _inquiries;
  List<ProviderModel> get providers => _providers;

  void initializeData() {
    _loadProviders();
    _loadInquiries();
  }

  //  PROVIDERS

  void _loadProviders() {
    _providers = [
      ProviderModel(
        id: "1",
        name: "Amit Kumar",
        phone: "+91 9876543210",
        specialty: "AC Repair",
        available: true,
      ),
      ProviderModel(
        id: "2",
        name: "Rohan Singh",
        phone: "+91 9123456789",
        specialty: "Electrical Work",
        available: true,
      ),
      ProviderModel(
        id: "3",
        name: "Deepak Jain",
        phone: "+91 9988776655",
        specialty: "Plumbing",
        available: false,
      ),
      ProviderModel(
        id: "4",
        name: "Rajesh Patel",
        phone: "+91 9876543211",
        specialty: "Carpentry",
        available: true,
      ),
    ];
  }

  //  INQUIRIES

  void _loadInquiries() {
    _inquiries = [
      //  Inquiry 1 (Pending)
      Inquiry(
        id: "BZ4001",
        customer: "Rahul Sharma",
        service: "AC Repair",
        location: "Pune, Maharashtra",
        date: "21 Nov",
        time: "11:30 AM",
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        status: InquiryStatus.pending,
        customerPhone: "+91 9876543210",
        customerAddress: "123 Main Street, Pune - 411001",
        price: 200, // Booking amount
        userNotes: "AC not cooling properly. Need urgent repair.",
        paymentStatus: PaymentStatus.unpaid,
        items: [
          ServiceItem(name: "AC Inspection", qty: 1, price: 500),
          ServiceItem(name: "Outdoor Unit Cleaning", qty: 1, price: 280),
        ],
        additionalAmount: 0,
      ),

      //  Inquiry 2 (Assigned)
      Inquiry(
        id: "BZ4002",
        customer: "Pooja Verma",
        service: "Fan Installation",
        location: "Mumbai, Maharashtra",
        date: "22 Nov",
        time: "12:00 PM",
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        status: InquiryStatus.assigned,
        provider: _providers[0],
        customerPhone: "+91 9123456789",
        customerAddress: "456 Oak Avenue, Mumbai",
        price: 150,
        userNotes: "Need ceiling fan installation in living room.",
        paymentStatus: PaymentStatus.paid,
        paymentMethod: PaymentMethod.cash,
        assignedAt: DateTime.now().subtract(const Duration(hours: 2)),
        items: [
          ServiceItem(name: "Fan Installation", qty: 1, price: 300),
          ServiceItem(name: "Wiring Check", qty: 1, price: 100),
        ],
        additionalAmount: 0,
      ),

      //  Inquiry 3 (In Progress)
      Inquiry(
        id: "BZ4003",
        customer: "Amit Kumar",
        service: "Light Fitting",
        location: "Delhi",
        date: "23 Nov",
        time: "10:00 AM",
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        status: InquiryStatus.inProgress,
        provider: _providers[1],
        customerPhone: "+91 9988776655",
        customerAddress: "789 Pine Road, Delhi",
        price: 100, // booking
        userNotes: "LED light fitting required in kitchen area.",
        paymentStatus: PaymentStatus.partiallyPaid,
        paymentMethod: PaymentMethod.online,
        assignedAt: DateTime.now().subtract(const Duration(days: 1)),
        adminNotes: "Customer requested premium quality LED lights.",
        items: [
          ServiceItem(name: "LED Light Fitting", qty: 2, price: 350),
        ],
        additionalAmount: 150, // extra onsite charge
      ),

      //  Inquiry 4 (Completed)
      Inquiry(
        id: "BZ4004",
        customer: "Neha Gupta",
        service: "AC Repair",
        location: "Bangalore",
        date: "20 Nov",
        time: "09:00 AM",
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        status: InquiryStatus.completed,
        provider: _providers[0],
        customerPhone: "+91 9876543210",
        customerAddress: "321 Elm Street, Bangalore",
        price: 300,
        userNotes: "AC gas refill and servicing required.",
        paymentStatus: PaymentStatus.paid,
        paymentMethod: PaymentMethod.card,
        assignedAt: DateTime.now().subtract(const Duration(days: 2)),
        completedAt: DateTime.now().subtract(const Duration(hours: 5)),
        adminNotes: "Service completed successfully. Customer satisfied.",
        items: [
          ServiceItem(name: "AC Gas Refill", qty: 1, price: 550),
          ServiceItem(name: "Full Service", qty: 1, price: 350),
        ],
        additionalAmount: 0,
      ),

      //  Inquiry 5 (Cancelled)
      Inquiry(
        id: "BZ4005",
        customer: "Sanjay Mehta",
        service: "Plumbing Work",
        location: "Chennai",
        date: "19 Nov",
        time: "02:00 PM",
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        status: InquiryStatus.cancelled,
        customerPhone: "+91 9123456780",
        customerAddress: "654 Maple Lane, Chennai",
        price: 100,
        userNotes: "Bathroom tap leakage repair.",
        paymentStatus: PaymentStatus.refunded,
        cancelledAt: DateTime.now().subtract(const Duration(days: 1)),
        adminNotes: "Customer cancelled. Full refund processed.",
        items: [
          ServiceItem(name: "Tap Leakage Repair", qty: 1, price: 300),
        ],
        additionalAmount: 0,
      ),
    ];
  }

  //  UPDATE METHODS

  void updateInquiryStatus(String inquiryId, InquiryStatus newStatus) {
    final i = _find(inquiryId);
    if (i == -1) return;

    DateTime? completedAt;
    DateTime? cancelledAt;

    if (newStatus == InquiryStatus.completed) {
      completedAt = DateTime.now();
    } else if (newStatus == InquiryStatus.cancelled) {
      cancelledAt = DateTime.now();
    }

    _inquiries[i] = _inquiries[i].copyWith(
      status: newStatus,
      completedAt: completedAt,
      cancelledAt: cancelledAt,
    );
  }

  void assignProvider(String inquiryId, ProviderModel provider) {
    final i = _find(inquiryId);
    if (i == -1) return;

    _inquiries[i] = _inquiries[i].copyWith(
      provider: provider,
      status: InquiryStatus.assigned,
      assignedAt: DateTime.now(),
    );
  }

  void updateProvider(String inquiryId, ProviderModel newProvider, String reason) {
    final i = _find(inquiryId);
    if (i == -1) return;

    final old = _inquiries[i].adminNotes;
    final note = "[Reassigned] $reason - ${DateTime.now()}";

    _inquiries[i] = _inquiries[i].copyWith(
      provider: newProvider,
      adminNotes: old != null ? "$old\n\n$note" : note,
    );
  }

  void updatePaymentStatus(String inquiryId, PaymentStatus status, PaymentMethod? method) {
    final i = _find(inquiryId);
    if (i == -1) return;

    final old = _inquiries[i].adminNotes;
    final note =
        "[Payment Updated] Status: ${status.label}${method != null ? ', Method: ${method.label}' : ''} - ${DateTime.now()}";

    _inquiries[i] = _inquiries[i].copyWith(
      paymentStatus: status,
      paymentMethod: method,
      adminNotes: old != null ? "$old\n\n$note" : note,
    );
  }

  void updateAdminNotes(String inquiryId, String notes) {
    final i = _find(inquiryId);
    if (i == -1) return;

    _inquiries[i] = _inquiries[i].copyWith(adminNotes: notes);
  }

  void addAdminNote(String inquiryId, String note) {
    final i = _find(inquiryId);
    if (i == -1) return;

    final old = _inquiries[i].adminNotes;
    final timestamp = DateTime.now();

    _inquiries[i] = _inquiries[i].copyWith(
      adminNotes: old != null ? "$old\n\n$note - $timestamp" : "$note - $timestamp",
    );
  }

  void updateInquiryPrice(String inquiryId, double newPrice) {
    final i = _find(inquiryId);
    if (i == -1) return;

    _inquiries[i] = _inquiries[i].copyWith(price: newPrice);
  }

  void updateAdditionalAmount(String inquiryId, double amount) {
    final i = _find(inquiryId);
    if (i == -1) return;

    _inquiries[i] = _inquiries[i].copyWith(additionalAmount: amount);
  }

  //  SEARCH

  List<Inquiry> searchInquiries(String query) {
    if (query.isEmpty) return _inquiries;

    final q = query.toLowerCase();

    return _inquiries.where((inquiry) {
      return inquiry.id.toLowerCase().contains(q) ||
          inquiry.customer.toLowerCase().contains(q) ||
          inquiry.service.toLowerCase().contains(q) ||
          inquiry.location.toLowerCase().contains(q) ||
          (inquiry.customerPhone?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  //  STATISTICS

  Map<String, dynamic> getStatistics() {
    final total = _inquiries.length;

    final pending =
        _inquiries.where((i) => i.status == InquiryStatus.pending).length;
    final assigned =
        _inquiries.where((i) => i.status == InquiryStatus.assigned).length;
    final inProgress =
        _inquiries.where((i) => i.status == InquiryStatus.inProgress).length;
    final completed =
        _inquiries.where((i) => i.status == InquiryStatus.completed).length;
    final cancelled =
        _inquiries.where((i) => i.status == InquiryStatus.cancelled).length;

    double totalRevenue = 0;
    double unpaidAmount = 0;

    for (var inq in _inquiries) {
      double itemTotal = 0;

      // Items total
      if (inq.items != null) {
        for (var item in inq.items!) {
          itemTotal += item.price * item.qty;
        }
      }

      // Additional
      itemTotal += inq.additionalAmount ?? 0;

      if (inq.paymentStatus == PaymentStatus.paid) {
        totalRevenue += itemTotal;
      } else {
        unpaidAmount += itemTotal;
      }
    }

    return {
      "total": total,
      "pending": pending,
      "assigned": assigned,
      "inProgress": inProgress,
      "completed": completed,
      "cancelled": cancelled,
      "totalRevenue": totalRevenue,
      "unpaidAmount": unpaidAmount,
    };
  }

  //  UTILS

  int _find(String id) {
    return _inquiries.indexWhere((inq) => inq.id == id);
  }
}
