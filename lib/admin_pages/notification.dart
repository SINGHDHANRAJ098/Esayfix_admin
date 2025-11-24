import 'package:flutter/material.dart';

class AdminNotification extends StatefulWidget {
  const AdminNotification({super.key});

  @override
  State<AdminNotification> createState() => _AdminNotificationState();
}

class _AdminNotificationState extends State<AdminNotification> {
  final Color redAccent = Colors.redAccent;

  // Admin Notification Data
  List<Map<String, String>> notifications = [
    {
      "type": "New Inquiry",
      "title": "New Inquiry Received",
      "message": "Customer requested Refrigerator Repair",
      "time": "5 min ago",
    },
    {
      "type": "Provider Update",
      "title": "Provider Assigned",
      "message": "Rohit Kumar has accepted the inquiry.",
      "time": "12 min ago",
    },
    {
      "type": "Payment",
      "title": "Payment Successful",
      "message": "₹650 has been credited to admin wallet.",
      "time": "30 min ago",
    },
    {
      "type": "System Alert",
      "title": "Low Rating Warning",
      "message": "Provider Deepak got a 1-star rating.",
      "time": "2 hrs ago",
    },
  ];

  // Clear all notifications
  void clearAll() {
    setState(() => notifications.clear());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("All notifications cleared"),
        duration: Duration(milliseconds: 800),
      ),
    );
  }

  // Icon based on type
  IconData getIcon(String type) {
    switch (type) {
      case "New Inquiry":
        return Icons.mark_email_unread_outlined;
      case "Provider Update":
        return Icons.manage_accounts_outlined;
      case "Payment":
        return Icons.account_balance_wallet_outlined;
      case "System Alert":
        return Icons.warning_amber_rounded;
      default:
        return Icons.notifications;
    }
  }

  // Icon color
  Color getIconColor(String type) {
    switch (type) {
      case "New Inquiry":
        return Colors.blueAccent;
      case "Provider Update":
        return Colors.orange;
      case "Payment":
        return Colors.green;
      case "System Alert":
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      // Header AppBar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Notifications",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        actions: [
          if (notifications.isNotEmpty)
            TextButton(
              onPressed: clearAll,
              child: const Text(
                "Clear All",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),

      //  BODY
      body: notifications.isEmpty
          ? _emptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon bubble
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: getIconColor(notif["type"]!).withOpacity(.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          getIcon(notif["type"]!),
                          color: getIconColor(notif["type"]!),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Text Inner
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title & Time
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    notif["title"] ?? "",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: Colors.black87,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  notif["time"] ?? "",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),

                            // Message
                            Text(
                              notif["message"] ?? "",
                              style: const TextStyle(
                                fontSize: 13.5,
                                color: Colors.black54,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  // EMPTY UI
  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 100,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 20),
            const Text(
              "No Notifications Yet",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
            ),
            const SizedBox(height: 6),
            const Text(
              "You're all caught up.\nWe’ll alert you when there’s an update!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
