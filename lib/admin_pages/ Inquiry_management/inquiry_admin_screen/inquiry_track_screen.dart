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
  void _showChangeProviderDialog() {
    final availableProviders = widget.providers.where((p) => p.available).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Change Service Provider",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: availableProviders.length,
                itemBuilder: (context, index) {
                  final provider = availableProviders[index];
                  return _buildProviderOption(provider);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderOption(ProviderModel provider) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.redAccent,
          child: Text(
            provider.name[0],
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          provider.name,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(provider.specialty),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.star, size: 16, color: Colors.orange),
                SizedBox(width: 4),
                Text(provider.rating.toStringAsFixed(1)),
                SizedBox(width: 12),
                Icon(Icons.phone, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(provider.phone),
              ],
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {
          Navigator.pop(context);
          widget.onUpdateProvider(provider, "Admin requested provider change");
          _showSuccessSnackbar('Provider changed to ${provider.name}');
        },
      ),
    );
  }

  void _markAsCompleted() {
    widget.onStatusUpdate(InquiryStatus.completed);
    _showSuccessSnackbar('Inquiry marked as completed');
  }

  void _markAsCancelled() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text("Cancel Inquiry"),
          ],
        ),
        content: Text("Are you sure you want to cancel this inquiry? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("No", style: TextStyle(color: Colors.grey[600])),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onStatusUpdate(InquiryStatus.cancelled);
              _showSuccessSnackbar('Inquiry cancelled successfully');
            },
            child: Text("Yes, Cancel", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Track Inquiry",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.redAccent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Status Overview
            _buildStatusOverview(),
            SizedBox(height: 20),
            // Provider Information
            if (widget.inquiry.provider != null) _buildProviderInfo(),
            SizedBox(height: 20),
            // Quick Actions
            _buildQuickActions(),
            SizedBox(height: 20),
            // Status Timeline
            _buildStatusTimeline(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusOverview() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: widget.inquiry.status.color.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.inquiry.status.color.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                widget.inquiry.status.icon,
                size: 40,
                color: widget.inquiry.status.color,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Current Status",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.inquiry.status.label,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: widget.inquiry.status.color,
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Booking ID: ${widget.inquiry.id}",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderInfo() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.engineering, color: Colors.blue[700]),
                SizedBox(width: 8),
                Text(
                  "Assigned Provider",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: Colors.blue[100],
                child: Text(
                  widget.inquiry.provider!.name[0],
                  style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                widget.inquiry.provider!.name,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.inquiry.provider!.specialty),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.orange),
                      SizedBox(width: 4),
                      Text(widget.inquiry.provider!.rating.toStringAsFixed(1)),
                      SizedBox(width: 12),
                      Icon(Icons.phone, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(widget.inquiry.provider!.phone),
                    ],
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.swap_horiz, color: Colors.redAccent),
                onPressed: _showChangeProviderDialog,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 12),
            if (widget.inquiry.status != InquiryStatus.completed &&
                widget.inquiry.status != InquiryStatus.cancelled) ...[
              _buildActionButton(
                "Change Provider",
                Icons.swap_horiz,
                Colors.blue,
                _showChangeProviderDialog,
              ),
              SizedBox(height: 8),
              _buildActionButton(
                "Mark as Completed",
                Icons.check_circle,
                Colors.green,
                _markAsCompleted,
              ),
              SizedBox(height: 8),
              _buildActionButton(
                "Cancel Inquiry",
                Icons.cancel,
                Colors.red,
                _markAsCancelled,
              ),
            ] else ...[
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    "No actions available for ${widget.inquiry.status.label.toLowerCase()} inquiries",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white, size: 20),
        label: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusTimeline() {
    final statusHistory = [
      _StatusHistoryItem("Inquiry Created", "System", "Today, ${widget.inquiry.time}"),
      _StatusHistoryItem("Under Review", "Admin", "Today, ${widget.inquiry.time}"),
      if (widget.inquiry.provider != null)
        _StatusHistoryItem("Assigned to Provider", "Admin", "Today, ${widget.inquiry.time}"),
      if (widget.inquiry.status == InquiryStatus.inProgress)
        _StatusHistoryItem("Work In Progress", widget.inquiry.provider?.name ?? "Provider", "Today"),
      if (widget.inquiry.status == InquiryStatus.completed)
        _StatusHistoryItem("Service Completed", widget.inquiry.provider?.name ?? "Provider", "Today"),
      if (widget.inquiry.status == InquiryStatus.cancelled)
        _StatusHistoryItem("Inquiry Cancelled", "Admin", "Today"),
    ];

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history, color: Colors.redAccent),
                SizedBox(width: 8),
                Text(
                  "Status History",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Column(
              children: statusHistory.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isLast = index == statusHistory.length - 1;

                return _buildTimelineItem(item, index, isLast);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(_StatusHistoryItem item, int index, bool isLast) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line and dot
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 40,
                  color: Colors.grey[300],
                ),
            ],
          ),
          SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.status,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "By ${item.by} • ${item.time}",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusHistoryItem {
  final String status;
  final String by;
  final String time;

  _StatusHistoryItem(this.status, this.by, this.time);
}