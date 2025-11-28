// lib/account_service/account_service.dart
import '../account_model/account_model.dart';

class AccountService {
  static final AccountService _instance = AccountService._internal();
  factory AccountService() => _instance;
  AccountService._internal();

  // Cache for frequently accessed data
  AdminProfile? _cachedAdminProfile;
  SupportContact? _cachedSupportContact;
  List<Policy>? _cachedPolicies;
  List<SupportTicket>? _cachedTickets;

  // Admin Profile Methods with caching
  Future<AdminProfile> getAdminProfile() async {
    if (_cachedAdminProfile != null) {
      return _cachedAdminProfile!;
    }

    await Future.delayed(const Duration(milliseconds: 300));
    _cachedAdminProfile = const AdminProfile(
      name: 'Rahul Khan',
      email: 'rahul.khan@easyfn.com',
      phone: '+91 9876543210',
    );
    return _cachedAdminProfile!;
  }

  Future<AdminProfile> updateAdminProfile(AdminProfile profile) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _cachedAdminProfile = profile;
    return profile;
  }

  // Policy Methods with caching
  Future<List<Policy>> getPolicies() async {
    if (_cachedPolicies != null) {
      return _cachedPolicies!;
    }

    await Future.delayed(const Duration(milliseconds: 200));

    _cachedPolicies = [
      Policy(
        id: 'terms_conditions',
        title: 'Terms & Conditions',
        description: 'User agreement and terms of service',
        content: _getTermsContent(),
        lastUpdated: DateTime(2024, 1, 15),
        version: '2.1.0',
      ),
      Policy(
        id: 'privacy_policy',
        title: 'Privacy Policy',
        description: 'How we handle your personal data',
        content: _getPrivacyContent(),
        lastUpdated: DateTime(2024, 1, 10),
        version: '1.5.0',
      ),
      Policy(
        id: 'refund_policy',
        title: 'Refund/Cancellation Policy',
        description: 'Our refund and cancellation procedures',
        content: _getRefundContent(),
        lastUpdated: DateTime(2024, 1, 5),
        version: '1.2.0',
      ),
    ];

    return _cachedPolicies!;
  }

  Future<Policy> getPolicy(String policyId) async {
    final policies = await getPolicies();
    return policies.firstWhere((policy) => policy.id == policyId);
  }

  Future<void> updatePolicy(Policy policy) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (_cachedPolicies != null) {
      final index = _cachedPolicies!.indexWhere((p) => p.id == policy.id);
      if (index != -1) {
        _cachedPolicies![index] = policy;
      }
    }
  }

  // Support Methods with caching
  Future<SupportContact> getSupportContact() async {
    if (_cachedSupportContact != null) {
      return _cachedSupportContact!;
    }

    await Future.delayed(const Duration(milliseconds: 200));
    _cachedSupportContact = const SupportContact(
      phone: '+1-800-123-4567',
      email: 'support@easyfn.com',
      workingHours: 'Mon-Fri 9:00 AM - 6:00 PM',
    );
    return _cachedSupportContact!;
  }

  Future<void> updateSupportContact(SupportContact contact) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _cachedSupportContact = contact;
  }

  // Ticket Methods with caching
  Future<String> createSupportTicket(SupportTicket ticket) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final ticketId = 'TICKET-${DateTime.now().millisecondsSinceEpoch}';

    // Add to cache if exists
    if (_cachedTickets != null) {
      _cachedTickets!.insert(0, ticket.copyWith(id: ticketId));
    }

    return ticketId;
  }

  Future<List<SupportTicket>> getAllTickets() async {
    if (_cachedTickets != null) {
      return _cachedTickets!;
    }

    await Future.delayed(const Duration(milliseconds: 300));

    _cachedTickets = [
      SupportTicket(
        id: '1',
        subject: 'Login Issue',
        description: 'Unable to login to admin panel',
        priority: 'High',
        status: 'Open',
        createdAt: DateTime(2024, 1, 20),
      ),
      SupportTicket(
        id: '2',
        subject: 'Feature Request',
        description: 'Add bulk action for user management',
        priority: 'Medium',
        status: 'In Progress',
        createdAt: DateTime(2024, 1, 18),
      ),
      SupportTicket(
        id: '3',
        subject: 'Bug Report',
        description: 'Dashboard stats not updating',
        priority: 'Low',
        status: 'Resolved',
        createdAt: DateTime(2024, 1, 15),
      ),
    ];

    return _cachedTickets!;
  }

  // Reports & Analytics Methods

  Future<ReportData> getDailyReport() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return ReportData(
      period: 'Today',
      totalInquiries: 24,
      completedInquiries: 18,
      pendingInquiries: 6,
      totalRevenue: 12500.0,
      averageRating: 4.7,
      serviceDistribution: {
        'AC Repair': 8,
        'Plumbing': 6,
        'Electrical': 5,
        'Carpentry': 3,
        'Painting': 2,
      },
    );
  }

  Future<ReportData> getMonthlyReport() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return ReportData(
      period: 'This Month',
      totalInquiries: 342,
      completedInquiries: 315,
      pendingInquiries: 27,
      totalRevenue: 185000.0,
      averageRating: 4.6,
      serviceDistribution: {
        'AC Repair': 125,
        'Plumbing': 89,
        'Electrical': 67,
        'Carpentry': 35,
        'Painting': 26,
      },
    );
  }

  Future<List<ReportData>> getRevenueReport() async {
    await Future.delayed(const Duration(milliseconds: 400));

    return [
      ReportData(
        period: 'Jan 2024',
        totalInquiries: 298,
        completedInquiries: 285,
        pendingInquiries: 13,
        totalRevenue: 162000.0,
        averageRating: 4.5,
        serviceDistribution: {},
      ),
      ReportData(
        period: 'Feb 2024',
        totalInquiries: 315,
        completedInquiries: 302,
        pendingInquiries: 13,
        totalRevenue: 172500.0,
        averageRating: 4.6,
        serviceDistribution: {},
      ),
      ReportData(
        period: 'Mar 2024',
        totalInquiries: 342,
        completedInquiries: 315,
        pendingInquiries: 27,
        totalRevenue: 185000.0,
        averageRating: 4.6,
        serviceDistribution: {},
      ),
    ];
  }

  // Clear cache methods (useful for logout or refresh)
  void clearCache() {
    _cachedAdminProfile = null;
    _cachedSupportContact = null;
    _cachedPolicies = null;
    _cachedTickets = null;
  }

  // Private content methods
  String _getTermsContent() => 'Terms & Conditions Content...';
  String _getPrivacyContent() => 'Privacy Policy Content...';
  String _getRefundContent() => 'Refund Policy Content...';
}
