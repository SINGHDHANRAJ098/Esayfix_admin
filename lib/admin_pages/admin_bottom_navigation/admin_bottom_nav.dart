import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easyfix_admin/admin_pages/account_management/account_screen/account_management.dart';

import 'package:flutter/material.dart';

import '../ Inquiry_management/inquiry_admin_screen/inquiry_management_wrapper.dart';
import '../Provider_management/provider_screen/provider_list_screen.dart';
import '../dashboard_management/dashboard.dart';

class AdminBottomNav extends StatefulWidget {
  const AdminBottomNav({super.key});

  @override
  State<AdminBottomNav> createState() => _AdminBottomNavState();
}

class _AdminBottomNavState extends State<AdminBottomNav> {
  int currentTabIndex = 0;
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();

    // Initialize all pages
    pages = [
      const Dashboard(),
      const InquiryManagementWrapper(),
      const ProviderListScreen(),
      //const ServicePricingManagement(),
      const AccountManagementScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentTabIndex],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: CurvedNavigationBar(
          height: 50,
          backgroundColor: Colors.white,
          color: Colors.redAccent,
          animationDuration: const Duration(milliseconds: 350),
          onTap: (int index) {
            setState(() {
              currentTabIndex = index;
            });
          },
          items: const [
            Icon(Icons.dashboard_outlined, size: 30, color: Colors.white),
            Icon(Icons.chat_bubble_outline, size: 30, color: Colors.white),
            Icon(Icons.group_outlined, size: 30, color: Colors.white),
            Icon(Icons.price_change, size: 30, color: Colors.white),
            Icon(Icons.person_outlined, size: 30, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
