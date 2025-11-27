import 'package:flutter/material.dart';
import '../ Inquiry_management/inquiry_admin_screen/inquiry_management_wrapper.dart';

import '../account_management/account_screen/reports_analytics_screen.dart';
import '../provider_management/provider_screen/provider_list_screen.dart';
import '../notification_screen/notification.dart';
// Import the revenue report screen

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

            // WHITE ROUNDED CONTENT AREA
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // GRID SECTION
                      GridView.builder(
                        itemCount: 8,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 11,
                              mainAxisSpacing: 11,
                              childAspectRatio: 1.05,
                            ),
                        itemBuilder: (_, index) {
                          final items = [
                            [
                              "Total Inquiries",
                              "296",
                              Colors.redAccent,
                              Icons.list_alt,
                              null, // No filter for total inquiries
                            ],
                            [
                              "Pending",
                              "14",
                              Colors.orange,
                              Icons.access_time,
                              "pending",
                            ],
                            [
                              "Assigned",
                              "9",
                              Colors.blue,
                              Icons.person_search,
                              "assigned",
                            ],
                            [
                              "In Progress",
                              "6",
                              Colors.purple,
                              Icons.sync,
                              "inProgress",
                            ],
                            [
                              "Completed",
                              "28",
                              Colors.green,
                              Icons.check_circle,
                              "completed",
                            ],
                            [
                              "Cancelled",
                              "3",
                              Colors.grey,
                              Icons.close,
                              "cancelled",
                            ],
                            [
                              "Service Providers",
                              "57",
                              Colors.teal,
                              Icons.engineering,
                              null, // Different navigation
                            ],
                            [
                              "Revenue Report",
                              "₹89,234",
                              Colors.brown,
                              Icons.bar_chart,
                              null, // Different navigation
                            ],
                          ];

                          return _dashboardCard(
                            title: items[index][0] as String,
                            value: items[index][1] as String,
                            color: items[index][2] as Color,
                            icon: items[index][3] as IconData,
                            filter: items[index][4] as String?,
                          );
                        },
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

  // UPDATED DASHBOARD CARD WITH NAVIGATION
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
          // Navigate to Service Providers screen
          _navigateToProviders(context);
        } else if (title == "Revenue Report") {
          // Navigate to Revenue Report screen
          _navigateToRevenueReport(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(14),
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
              radius: 22,
              backgroundColor: color.withOpacity(.15),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
