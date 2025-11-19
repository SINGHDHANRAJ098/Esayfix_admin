// services/inquiry_data_service.dart
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

  void _loadInquiries() {
    _inquiries = [
      Inquiry(
        id: "BZ4001",
        customer: "Rahul Sharma",
        service: "AC Repair",
        location: "Pune, Maharashtra",
        date: "21 Nov",
        time: "11:30 AM",
        status: InquiryStatus.pending,
        customerPhone: "+91 9876543210",
        customerAddress: "123 Main Street, Pune, Maharashtra - 411001",
        price: 45.00,
        userNotes: "AC not cooling properly. Need urgent repair.",
        paymentStatus: PaymentStatus.unpaid,
      ),
      Inquiry(
        id: "BZ4002",
        customer: "Pooja Verma",
        service: "Fan Installation",
        location: "Mumbai, Maharashtra",
        date: "22 Nov",
        time: "12:00 PM",
        status: InquiryStatus.assigned,
        provider: _providers[0],
        customerPhone: "+91 9123456789",
        customerAddress: "456 Oak Avenue, Mumbai, Maharashtra - 400001",
        price: 30.00,
        userNotes: "Need ceiling fan installation in living room.",
        paymentStatus: PaymentStatus.paid,
        paymentMethod: PaymentMethod.cash,
        assignedAt: DateTime.now().subtract(Duration(hours: 2)),
      ),
      Inquiry(
        id: "BZ4003",
        customer: "Amit Kumar",
        service: "Light Fitting",
        location: "Delhi",
        date: "23 Nov",
        time: "10:00 AM",
        status: InquiryStatus.inProgress,
        provider: _providers[1],
        customerPhone: "+91 9988776655",
        customerAddress: "789 Pine Road, Delhi - 110001",
        price: 50.00,
        userNotes: "LED light fitting required in kitchen area.",
        paymentStatus: PaymentStatus.partiallyPaid,
        paymentMethod: PaymentMethod.online,
        assignedAt: DateTime.now().subtract(Duration(days: 1)),
        adminNotes: "Customer requested premium quality LED lights.",
      ),
      Inquiry(
        id: "BZ4004",
        customer: "Neha Gupta",
        service: "AC Repair",
        location: "Bangalore",
        date: "20 Nov",
        time: "09:00 AM",
        status: InquiryStatus.completed,
        provider: _providers[0],
        customerPhone: "+91 9876543210",
        customerAddress: "321 Elm Street, Bangalore, Karnataka - 560001",
        price: 55.00,
        userNotes: "AC gas refill and servicing required.",
        paymentStatus: PaymentStatus.paid,
        paymentMethod: PaymentMethod.card,
        assignedAt: DateTime.now().subtract(Duration(days: 2)),
        completedAt: DateTime.now().subtract(Duration(hours: 5)),
        adminNotes: "Service completed successfully. Customer satisfied.",
      ),
      Inquiry(
        id: "BZ4005",
        customer: "Sanjay Mehta",
        service: "Plumbing Work",
        location: "Chennai",
        date: "19 Nov",
        time: "02:00 PM",
        status: InquiryStatus.cancelled,
        customerPhone: "+91 9123456780",
        customerAddress: "654 Maple Lane, Chennai, Tamil Nadu - 600001",
        price: 40.00,
        userNotes: "Bathroom tap leakage repair.",
        paymentStatus: PaymentStatus.refunded,
        cancelledAt: DateTime.now().subtract(Duration(days: 1)),
        adminNotes: "Customer cancelled due to personal reasons. Full refund processed.",
      ),
    ];
  }

  void updateInquiryStatus(String inquiryId, InquiryStatus newStatus) {
    final index = _inquiries.indexWhere((inq) => inq.id == inquiryId);
    if (index != -1) {
      // Update timestamps based on status
      DateTime? completedAt;
      DateTime? cancelledAt;

      if (newStatus == InquiryStatus.completed) {
        completedAt = DateTime.now();
      } else if (newStatus == InquiryStatus.cancelled) {
        cancelledAt = DateTime.now();
      }

      _inquiries[index] = _inquiries[index].copyWith(
        status: newStatus,
        completedAt: completedAt,
        cancelledAt: cancelledAt,
      );
    }
  }

  void assignProvider(String inquiryId, ProviderModel provider) {
    final index = _inquiries.indexWhere((inq) => inq.id == inquiryId);
    if (index != -1) {
      _inquiries[index] = _inquiries[index].copyWith(
        provider: provider,
        status: InquiryStatus.assigned,
        assignedAt: DateTime.now(),
      );
    }
  }

  void updateProvider(String inquiryId, ProviderModel newProvider, String reason) {
    final index = _inquiries.indexWhere((inq) => inq.id == inquiryId);
    if (index != -1) {
      // Add reassignment note
      final currentNotes = _inquiries[index].adminNotes;
      final reassignmentNote = "[Reassigned] $reason - ${DateTime.now().toString()}";
      final updatedNotes = currentNotes != null
          ? "$currentNotes\n\n$reassignmentNote"
          : reassignmentNote;

      _inquiries[index] = _inquiries[index].copyWith(
        provider: newProvider,
        adminNotes: updatedNotes,
      );
    }
  }

  void updatePaymentStatus(String inquiryId, PaymentStatus status, PaymentMethod? method) {
    final index = _inquiries.indexWhere((inq) => inq.id == inquiryId);
    if (index != -1) {
      // Add payment update note
      final currentNotes = _inquiries[index].adminNotes;
      final paymentNote = "[Payment Updated] Status: ${status.label}${method != null ? ', Method: ${method.label}' : ''} - ${DateTime.now().toString()}";
      final updatedNotes = currentNotes != null
          ? "$currentNotes\n\n$paymentNote"
          : paymentNote;

      _inquiries[index] = _inquiries[index].copyWith(
        paymentStatus: status,
        paymentMethod: method,
        adminNotes: updatedNotes,
      );
    }
  }

  void updateAdminNotes(String inquiryId, String notes) {
    final index = _inquiries.indexWhere((inq) => inq.id == inquiryId);
    if (index != -1) {
      _inquiries[index] = _inquiries[index].copyWith(
        adminNotes: notes,
      );
    }
  }

  void addAdminNote(String inquiryId, String note) {
    final index = _inquiries.indexWhere((inq) => inq.id == inquiryId);
    if (index != -1) {
      final currentNotes = _inquiries[index].adminNotes;
      final timestamp = DateTime.now().toString();
      final updatedNotes = currentNotes != null
          ? "$currentNotes\n\n$note - $timestamp"
          : "$note - $timestamp";

      _inquiries[index] = _inquiries[index].copyWith(
        adminNotes: updatedNotes,
      );
    }
  }

  void updateInquiryPrice(String inquiryId, double newPrice) {
    final index = _inquiries.indexWhere((inq) => inq.id == inquiryId);
    if (index != -1) {
      _inquiries[index] = _inquiries[index].copyWith(
        price: newPrice,
      );
    }
  }

  // Get inquiries by status
  List<Inquiry> getInquiriesByStatus(InquiryStatus status) {
    return _inquiries.where((inquiry) => inquiry.status == status).toList();
  }

  // Get inquiries by provider
  List<Inquiry> getInquiriesByProvider(String providerId) {
    return _inquiries.where((inquiry) => inquiry.provider?.id == providerId).toList();
  }

  // Get available providers for a service type
  List<ProviderModel> getAvailableProviders(String serviceType) {
    return _providers.where((provider) =>
    provider.available &&
        provider.specialty.toLowerCase().contains(serviceType.toLowerCase())
    ).toList();
  }

  // Get provider by ID
  ProviderModel? getProviderById(String providerId) {
    try {
      return _providers.firstWhere((provider) => provider.id == providerId);
    } catch (e) {
      return null;
    }
  }

  // Get inquiry by ID
  Inquiry? getInquiryById(String inquiryId) {
    try {
      return _inquiries.firstWhere((inquiry) => inquiry.id == inquiryId);
    } catch (e) {
      return null;
    }
  }

  // Add new inquiry
  void addInquiry(Inquiry inquiry) {
    _inquiries.add(inquiry);
  }

  // Remove inquiry
  void removeInquiry(String inquiryId) {
    _inquiries.removeWhere((inq) => inq.id == inquiryId);
  }

  // Get statistics
  Map<String, dynamic> getStatistics() {
    final total = _inquiries.length;
    final pending = _inquiries.where((i) => i.status == InquiryStatus.pending).length;
    final assigned = _inquiries.where((i) => i.status == InquiryStatus.assigned).length;
    final inProgress = _inquiries.where((i) => i.status == InquiryStatus.inProgress).length;
    final completed = _inquiries.where((i) => i.status == InquiryStatus.completed).length;
    final cancelled = _inquiries.where((i) => i.status == InquiryStatus.cancelled).length;

    final totalRevenue = _inquiries
        .where((i) => i.price != null && i.paymentStatus == PaymentStatus.paid)
        .fold(0.0, (sum, inquiry) => sum + inquiry.price!);

    final unpaidAmount = _inquiries
        .where((i) => i.price != null && i.paymentStatus != PaymentStatus.paid)
        .fold(0.0, (sum, inquiry) => sum + inquiry.price!);

    return {
      'total': total,
      'pending': pending,
      'assigned': assigned,
      'inProgress': inProgress,
      'completed': completed,
      'cancelled': cancelled,
      'totalRevenue': totalRevenue,
      'unpaidAmount': unpaidAmount,
    };
  }

  // Search inquiries
  List<Inquiry> searchInquiries(String query) {
    if (query.isEmpty) return _inquiries;

    final lowerQuery = query.toLowerCase();
    return _inquiries.where((inquiry) =>
    inquiry.id.toLowerCase().contains(lowerQuery) ||
        inquiry.customer.toLowerCase().contains(lowerQuery) ||
        inquiry.service.toLowerCase().contains(lowerQuery) ||
        inquiry.location.toLowerCase().contains(lowerQuery) ||
        (inquiry.customerPhone?.toLowerCase().contains(lowerQuery) ?? false)
    ).toList();
  }
}