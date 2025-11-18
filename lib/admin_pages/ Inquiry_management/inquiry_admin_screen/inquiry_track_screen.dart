// screens/inquiry_track_screen.dart
import 'package:flutter/material.dart';

import '../inquiry_model/inquiry.model.dart';
import '../inquiry_model/inquiry_provider_model.dart';
import '../inquiry_model/inquiry_status_model.dart';

class InquiryTrackScreen extends StatefulWidget {
  final Inquiry inquiry;
  final List<ProviderModel> providers;
  final Function(InquiryStatus) onStatusUpdate;
  final Function(ProviderModel, String) onUpdateProvider;

  const InquiryTrackScreen({
    super.key,
    required this.inquiry,
    required this.providers,
    required this.onStatusUpdate,
    required this.onUpdateProvider,
  });

  @override
  State<InquiryTrackScreen> createState() => _InquiryTrackScreenState();
}

class _InquiryTrackScreenState extends State<InquiryTrackScreen> {
  // ------------------------------
  // PROVIDER CHANGE MODAL
  // ------------------------------
  void _showChangeProviderDialog() {
    final availableProviders =
    widget.providers.where((p) => p.available).toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
          ),
          child: Column(
            children: [
              SizedBox(height: 12),
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Change Service Provider",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: availableProviders.length,
                  itemBuilder: (_, i) =>
                      _buildProviderOption(availableProviders[i]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProviderOption(ProviderModel provider) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.05),
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: Colors.redAccent.shade100,
          child: Text(
            provider.name[0],
            style: TextStyle(
              color: Colors.redAccent.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          provider.name,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(provider.specialty),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {
          Navigator.pop(context);
          widget.onUpdateProvider(provider, "Admin changed provider");
          _success("Provider changed to ${provider.name}");
        },
      ),
    );
  }

  // ------------------------------
  // STATUS UPDATE ACTIONS
  // ------------------------------

  void _complete() {
    widget.onStatusUpdate(InquiryStatus.completed);
    _success("Marked as completed");
  }

  void _cancel() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Cancel Inquiry"),
        content:
        Text("Are you sure you want to cancel this inquiry permanently?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("No")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onStatusUpdate(InquiryStatus.cancelled);
              _success("Inquiry cancelled");
            },
            child: Text("Yes, Cancel", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _success(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(12),
        backgroundColor: Colors.green,
      ),
    );
  }

  // ------------------------------
  // BUILD UI
  // ------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Track Inquiry",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _statusOverview(),
          if (widget.inquiry.provider != null) ...[
            SizedBox(height: 18),
            _providerInfo(),
          ],
          SizedBox(height: 18),
          _quickActions(),
          SizedBox(height: 18),
          _timeline(),
        ],
      ),
    );
  }

  // ------------------------------
  // STATUS OVERVIEW
  // ------------------------------

  Widget _statusOverview() {
    final status = widget.inquiry.status;

    return Card(
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.07),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(22),
        child: Column(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: status.color.withOpacity(0.15),
              child: Icon(status.icon, color: status.color, size: 35),
            ),
            SizedBox(height: 10),
            Text(
              status.label,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: status.color,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Booking ID: ${widget.inquiry.id}",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            )
          ],
        ),
      ),
    );
  }

  // ------------------------------
  // PROVIDER INFO
  // ------------------------------

  Widget _providerInfo() {
    final p = widget.inquiry.provider!;

    return Card(
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.07),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 27,
              backgroundColor: Colors.blue.shade100,
              child: Text(
                p.name[0],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.name,
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 3),
                  Text(p.specialty, style: TextStyle(color: Colors.grey[600])),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange, size: 16),
                      SizedBox(width: 4),
                      Text(p.rating.toStringAsFixed(1)),
                      SizedBox(width: 12),
                      Icon(Icons.phone, color: Colors.grey, size: 16),
                      SizedBox(width: 4),
                      Text(p.phone),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.swap_horiz, color: Colors.redAccent),
              onPressed: _showChangeProviderDialog,
            )
          ],
        ),
      ),
    );
  }

  // ------------------------------
  // QUICK ACTION BUTTONS
  // ------------------------------

  Widget _quickActions() {
    final disabled = widget.inquiry.status == InquiryStatus.completed ||
        widget.inquiry.status == InquiryStatus.cancelled;

    return Card(
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.07),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: disabled
            ? Center(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              "No actions available",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        )
            : Column(
          children: [
            _bigButton(
                "Change Provider", Icons.swap_horiz, Colors.blue, _showChangeProviderDialog),
            SizedBox(height: 10),
            _bigButton(
                "Mark Completed", Icons.check_circle, Colors.green, _complete),
            SizedBox(height: 10),
            _bigButton(
                "Cancel Inquiry", Icons.cancel, Colors.red, _cancel),
          ],
        ),
      ),
    );
  }

  Widget _bigButton(String title, IconData icon, Color color, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 20),
        label: Text(title),
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  // ------------------------------
  // TIMELINE
  // ------------------------------

  Widget _timeline() {
    List<_StatusHistory> items = [
      _StatusHistory("Inquiry Created", "System", "Today"),
      if (widget.inquiry.provider != null)
        _StatusHistory("Assigned", "Admin", "Today"),
      if (widget.inquiry.status == InquiryStatus.inProgress)
        _StatusHistory("Work In Progress", "Provider", "Today"),
      if (widget.inquiry.status == InquiryStatus.completed)
        _StatusHistory("Completed", "Provider", "Today"),
      if (widget.inquiry.status == InquiryStatus.cancelled)
        _StatusHistory("Cancelled", "Admin", "Today"),
    ];

    return Card(
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.07),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.history, color: Colors.redAccent),
                SizedBox(width: 8),
                Text(
                  "Status History",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            ...items.map(_buildTimelineItem),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(_StatusHistory item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circle
          Container(
            width: 12,
            height: 12,
            margin: EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style:
                    TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                SizedBox(height: 2),
                Text(
                  "By ${item.by} • ${item.time}",
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _StatusHistory {
  final String title;
  final String by;
  final String time;

  _StatusHistory(this.title, this.by, this.time);
}
