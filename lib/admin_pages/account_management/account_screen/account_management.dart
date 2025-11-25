import 'package:flutter/material.dart';

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
        automaticallyImplyLeading: false,
        elevation: 0,

        title: const Text(
          'Account Management',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            AdminProfileSection(),
            SizedBox(height: 16),
            PoliciesLegalSection(),
            SizedBox(height: 16),
            SupportContactSection(),
          ],
        ),
      ),
    );
  }
}
