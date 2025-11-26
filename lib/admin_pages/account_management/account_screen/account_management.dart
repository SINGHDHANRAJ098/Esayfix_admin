import 'package:easyfix_admin/admin_pages/account_management/account_screen/admin_profile_screen.dart';
import 'package:easyfix_admin/admin_pages/account_management/account_screen/policies_legal_screen.dart';
import 'package:easyfix_admin/admin_pages/account_management/account_screen/reports_analytics_screen.dart';
import 'package:easyfix_admin/admin_pages/account_management/account_screen/support_contact_screen.dart';
import 'package:flutter/material.dart';
// ADD THIS IMPORT

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
            ReportsAnalyticsSection(), // ADD THIS SECTION
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
