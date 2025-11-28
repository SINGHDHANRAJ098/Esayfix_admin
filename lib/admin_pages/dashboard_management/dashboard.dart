import 'package:flutter/material.dart';
import '../ Inquiry_management/inquiry_admin_screen/inquiry_management_wrapper.dart';

import '../account_management/account_screen/reports_analytics_screen.dart';
import '../provider_management/provider_screen/provider_list_screen.dart';
import '../notification_screen/notification.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final Color redAccent = Colors.redAccent;

  void _navigateToInquiries(BuildContext context, {String? initialFilter}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InquiryManagementWrapper(initialFilter: initialFilter),
      ),
    );
  }

  void _navigateToProviders(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProviderListScreen()),
    );
  }

  void _navigateToRevenueReport(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RevenueReportScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: redAccent,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER SECTION
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              decoration: BoxDecoration(color: redAccent),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // PROFILE + NAME + LOCATION
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 22,
                        backgroundImage: AssetImage("images/adminprofile.webp"),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Text(
                                "Rahul Khan ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text("👋", style: TextStyle(fontSize: 16)),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: const [
                              Icon(
                                Icons.location_on,
                                color: Colors.white70,
                                size: 14,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "Admin, EasyFix",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  // NOTIFICATION ICON
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminNotification(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.notifications_none,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // WHITE ROUNDED CONTENT AREA - CUSTOM LAYOUT
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // First Row of Cards
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: _dashboardCard(
                                title: "Total Inquiries",
                                value: "296",
                                color: Colors.redAccent,
                                icon: Icons.list_alt,
                                filter: null,
                              ),
                            ),
                            const SizedBox(width: 11),
                            Expanded(
                              child: _dashboardCard(
                                title: "Pending",
                                value: "14",
                                color: Colors.orange,
                                icon: Icons.access_time,
                                filter: "pending",
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 11),

                      // Second Row of Cards
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: _dashboardCard(
                                title: "Assigned",
                                value: "9",
                                color: Colors.blue,
                                icon: Icons.person_search,
                                filter: "assigned",
                              ),
                            ),
                            const SizedBox(width: 11),
                            Expanded(
                              child: _dashboardCard(
                                title: "In Progress",
                                value: "6",
                                color: Colors.purple,
                                icon: Icons.sync,
                                filter: "inProgress",
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 11),

                      // Third Row of Cards
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: _dashboardCard(
                                title: "Completed",
                                value: "28",
                                color: Colors.green,
                                icon: Icons.check_circle,
                                filter: "completed",
                              ),
                            ),
                            const SizedBox(width: 11),
                            Expanded(
                              child: _dashboardCard(
                                title: "Cancelled",
                                value: "3",
                                color: Colors.grey,
                                icon: Icons.close,
                                filter: "cancelled",
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 11),

                      // Fourth Row of Cards
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: _dashboardCard(
                                title: "Service Providers",
                                value: "57",
                                color: Colors.teal,
                                icon: Icons.engineering,
                                filter: null,
                              ),
                            ),
                            const SizedBox(width: 11),
                            Expanded(
                              child: _dashboardCard(
                                title: "Revenue Report",
                                value: "₹89,234",
                                color: Colors.brown,
                                icon: Icons.bar_chart,
                                filter: null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // DASHBOARD CARD WITH NAVIGATION
  Widget _dashboardCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
    required String? filter,
  }) {
    return GestureDetector(
      onTap: () {
        if (title == "Total Inquiries" ||
            title == "Pending" ||
            title == "Assigned" ||
            title == "In Progress" ||
            title == "Completed" ||
            title == "Cancelled") {
          _navigateToInquiries(context, initialFilter: filter);
        } else if (title == "Service Providers") {
          _navigateToProviders(context);
        } else if (title == "Revenue Report") {
          _navigateToRevenueReport(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              offset: const Offset(0, 3),
              color: Colors.black.withOpacity(.07),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: color.withOpacity(.15),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
