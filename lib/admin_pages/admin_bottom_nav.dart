import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easyfix_admin/admin_pages/%20Inquiry_management/inquiry_management.dart';

import 'package:easyfix_admin/admin_pages/account_management.dart';
import 'package:easyfix_admin/admin_pages/dashboard.dart';
import 'package:easyfix_admin/admin_pages/service_pricing_management.dart';
import 'package:easyfix_admin/admin_pages/service_provider_management.dart';
import 'package:flutter/material.dart';

class AdminBottomNav extends StatefulWidget {
  const AdminBottomNav({super.key});

  @override
  State<AdminBottomNav> createState() => _AdminBottomNavState();
}

class _AdminBottomNavState extends State<AdminBottomNav> {
  int currentTabIndex = 0;
  late List<Widget> pages;
  late Dashboard dashboard;
  late InquiryManagement inquiryManagement;
  late ServiceProviderManagement serviceProviderManagement;
  late ServicePricingManagement servicePricingManagement;
  late AccountManagement accountManagement;

  @override
  void initState() {
    super.initState();
    dashboard = Dashboard();
    inquiryManagement = InquiryManagement();
    serviceProviderManagement = ServiceProviderManagement();
    servicePricingManagement = ServicePricingManagement();
    accountManagement = AccountManagement();

    pages = [
      dashboard,
      inquiryManagement,
      serviceProviderManagement,
      servicePricingManagement,
      accountManagement,
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
          animationDuration: Duration(milliseconds: 350),
          onTap: (int index) {
            setState(() {
              currentTabIndex = index;
            });
          },
          items: [
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
