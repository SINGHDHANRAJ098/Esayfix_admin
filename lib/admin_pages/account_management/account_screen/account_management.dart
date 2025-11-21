import 'package:flutter/material.dart';
import '../account_service/account_service.dart';
import '../account_widget/account_widget.dart';
import 'admin_profile_screen.dart';
import 'policies_legal_screen.dart';
import 'support_contact_screen.dart';

/// Main Account Management screen – groups:
/// 1) Admin Profile
/// 2) Policies & Legal
/// 3) Support & Contact
class AccountManagementScreen extends StatelessWidget {
  const AccountManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Account Management',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            AdminProfileSection(),
            SizedBox(height: 24),
            PoliciesLegalSection(),
            SizedBox(height: 24),
            SupportContactSection(),
          ],
        ),
      ),
    );
  }
}