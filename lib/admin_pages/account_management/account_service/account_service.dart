// lib/account_service/account_service.dart

import '../account_model/account_model.dart';

class AccountService {
  // Local in-memory storage (mock backend)
  AdminProfile? _adminProfile;
  SupportContact? _supportContact;
  final Map<String, Policy> _policiesCache = {};
  final List<SupportTicket> _tickets = [];

  // ----------------- Admin Profile Methods -----------------
  Future<AdminProfile> getAdminProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));

    _adminProfile ??= const AdminProfile(
      name: 'Rahul Khan',
      email: 'rahul.khan@easyfn.com',
      phone: '+91 9876543210',
    );

    return _adminProfile!;
  }

  Future<AdminProfile> updateAdminProfile(AdminProfile profile) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _adminProfile = profile;
    return profile;
  }

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Simulate password change success
    return true;
  }

  // ----------------- Policy Methods -----------------
  Future<List<Policy>> getPolicies() async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Initialize default policies only once
    if (_policiesCache.isEmpty) {
      final defaults = [
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

      for (final p in defaults) {
        _policiesCache[p.id] = p;
      }
    }

    return _policiesCache.values.toList();
  }

  Future<Policy> getPolicy(String policyId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (_policiesCache.isEmpty) {
      await getPolicies();
    }

    return _policiesCache[policyId]!;
  }

  Future<void> updatePolicy(Policy policy) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _policiesCache[policy.id] = policy;
  }

  // ----------------- Support Methods -----------------
  Future<SupportContact> getSupportContact() async {
    await Future.delayed(const Duration(milliseconds: 300));

    _supportContact ??= const SupportContact(
      phone: '+1-800-123-4567',
      email: 'support@easyfn.com',
      workingHours: 'Mon-Fri 9:00 AM - 6:00 PM',
    );

    return _supportContact!;
  }

  Future<void> updateSupportContact(SupportContact contact) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _supportContact = contact;
  }

  Future<String> createSupportTicket(SupportTicket ticket) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final newId = 'TICKET-${DateTime.now().millisecondsSinceEpoch}';
    final storedTicket = ticket.copyWith(id: newId);
    _tickets.add(storedTicket);

    return newId;
  }

  Future<List<SupportTicket>> getAllTickets() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_tickets);
  }

  // ----------------- Private content methods -----------------
  String _getTermsContent() => '''
# Terms & Conditions

## 1. Acceptance of Terms
By accessing and using this admin panel, you agree to be bound by these terms and conditions.

## 2. Admin Responsibilities
- Maintain confidentiality of login credentials
- Use the system only for authorized purposes
- Report any security breaches immediately

## 3. Prohibited Activities
- Unauthorized access to other accounts
- Data manipulation without proper authorization
- Sharing login credentials with unauthorized persons

Last Updated: January 15, 2024
Version: 2.1.0
''';

  String _getPrivacyContent() => '''
# Privacy Policy

## 1. Information Collection
We collect necessary information to provide admin services including:
- Personal identification information
- System usage data
- Security logs

## 2. Data Protection
Your data is protected through:
- Encryption of sensitive information
- Regular security audits
- Access control mechanisms

## 3. Data Usage
Collected data is used for:
- System administration
- Security monitoring
- Service improvement

Last Updated: January 10, 2024
Version: 1.5.0
''';

  String _getRefundContent() => '''
# Refund/Cancellation Policy

## 1. Service Cancellation
Admins can cancel services with proper notice period as per company policy.

## 2. Refund Eligibility
Refunds are processed under specific circumstances:
- Service unavailability for extended periods
- Billing errors
- Contractual obligations

## 3. Refund Process
- Submit refund request through proper channel
- Provide necessary documentation
- Allow 7-10 business days for processing

Last Updated: January 5, 2024
Version: 1.2.0
''';
}
