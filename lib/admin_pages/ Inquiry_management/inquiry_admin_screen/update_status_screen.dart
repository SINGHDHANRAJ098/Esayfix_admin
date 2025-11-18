// screens/update_status_screen.dart
import 'package:flutter/material.dart';

import '../inquiry_model/inquiry.model.dart';
import '../inquiry_model/inquiry_status_model.dart';


class UpdateStatusScreen extends StatefulWidget {
  final Inquiry inquiry;
  final Function(InquiryStatus) onStatusUpdate;

  const UpdateStatusScreen({
    super.key,
    required this.inquiry,
    required this.onStatusUpdate,
  });

  @override
  State<UpdateStatusScreen> createState() => _UpdateStatusScreenState();
}

class _UpdateStatusScreenState extends State<UpdateStatusScreen> {
  InquiryStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.inquiry.status;
  }

  void _updateStatus() {
    if (_selectedStatus != null) {
      widget.onStatusUpdate(_selectedStatus!);
      Navigator.pop(context);
      _showSuccessSnackbar('Status updated to ${_selectedStatus!.label}');
    }
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
          "Update Status",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.redAccent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Current Status Card
          _buildCurrentStatusCard(),
          SizedBox(height: 20),
          // Status Options
          Expanded(
            child: _buildStatusOptions(),
          ),
          // Update Button
          _buildUpdateButton(),
        ],
      ),
    );
  }

  Widget _buildCurrentStatusCard() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.inquiry.status.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: widget.inquiry.status.color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: widget.inquiry.status.color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.inquiry.status.icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Current Status",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  widget.inquiry.status.label,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: widget.inquiry.status.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusOptions() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select New Status",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: InquiryStatus.values.map((status) {
                return _buildStatusOptionCard(status);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusOptionCard(InquiryStatus status) {
    final isSelected = _selectedStatus == status;
    final isCurrent = widget.inquiry.status == status;

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? status.color : Colors.transparent,
          width: isSelected ? 2 : 0,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: status.color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            status.icon,
            color: status.color,
            size: 20,
          ),
        ),
        title: Text(
          status.label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: status.color,
          ),
        ),
        subtitle: _buildStatusDescription(status),
        trailing: isCurrent
            ? Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "Current",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        )
            : isSelected
            ? Icon(Icons.check_circle, color: Colors.green)
            : null,
        onTap: () {
          setState(() {
            _selectedStatus = status;
          });
        },
      ),
    );
  }

  Widget _buildStatusDescription(InquiryStatus status) {
    String description = "";
    switch (status) {
      case InquiryStatus.pending:
        description = "Inquiry is waiting for assignment";
        break;
      case InquiryStatus.assigned:
        description = "Provider has been assigned";
        break;
      case InquiryStatus.inProgress:
        description = "Work is currently in progress";
        break;
      case InquiryStatus.completed:
        description = "Service has been completed";
        break;
      case InquiryStatus.cancelled:
        description = "Inquiry has been cancelled";
        break;
    }

    return Text(
      description,
      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
    );
  }

  Widget _buildUpdateButton() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: _selectedStatus != widget.inquiry.status ? _updateStatus : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
          child: Text(
            "Update Status",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}