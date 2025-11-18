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
        rating: 4.8,
        available: true,
      ),
      ProviderModel(
        id: "2",
        name: "Rohan Singh",
        phone: "+91 9123456789",
        specialty: "Electrical Work",
        rating: 4.6,
        available: true,
      ),
      ProviderModel(
        id: "3",
        name: "Deepak Jain",
        phone: "+91 9988776655",
        specialty: "Plumbing",
        rating: 4.9,
        available: false,
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
        price: 45.00,
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
        price: 30.00,
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
        price: 50.00,
      ),
    ];
  }

  void updateInquiryStatus(String inquiryId, InquiryStatus newStatus) {
    final index = _inquiries.indexWhere((inq) => inq.id == inquiryId);
    if (index != -1) {
      _inquiries[index].status = newStatus;
    }
  }

  void assignProvider(String inquiryId, ProviderModel provider) {
    final index = _inquiries.indexWhere((inq) => inq.id == inquiryId);
    if (index != -1) {
      _inquiries[index].provider = provider;
      _inquiries[index].status = InquiryStatus.assigned;
    }
  }

  void updateProvider(String inquiryId, ProviderModel newProvider, String reason) {
    final index = _inquiries.indexWhere((inq) => inq.id == inquiryId);
    if (index != -1) {
      _inquiries[index].provider = newProvider;
    }
  }
}