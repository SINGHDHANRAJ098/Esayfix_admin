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
        margin: const EdgeInsets.all(12),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          "Update Status",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: Column(
        children: [
          _buildCurrentStatusCard(),
          const SizedBox(height: 10),
          Expanded(child: _buildStatusOptions()),
          _buildUpdateButton(),
        ],
      ),
    );
  }

  Widget _buildCurrentStatusCard() {
    final status = widget.inquiry.status;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: status.color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: status.color,
            child: Icon(
              status.icon,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Current Status",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                status.label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: status.color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        children: [
          const Text(
            "Choose New Status",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 8),
          ...InquiryStatus.values.map(_buildStatusOptionCard),
        ],
      ),
    );
  }

  Widget _buildStatusOptionCard(InquiryStatus status) {
    final bool isSelected = _selectedStatus == status;
    final bool isCurrent = widget.inquiry.status == status;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? status.color : Colors.transparent,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isSelected ? 0.08 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

        leading: CircleAvatar(
          radius: 22,
          backgroundColor: status.color.withOpacity(0.15),
          child: Icon(
            status.icon,
            color: status.color,
            size: 18,
          ),
        ),

        title: Text(
          status.label,
          style: TextStyle(
            fontSize: 16,
            color: status.color,
            fontWeight: FontWeight.w600,
          ),
        ),

        subtitle: Text(
          _statusExplanation(status),
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),

        trailing: isCurrent
            ? _currentBadge()
            : isSelected
            ? const Icon(Icons.check_circle, color: Colors.green, size: 24)
            : null,

        onTap: () {
          if (!isCurrent) {
            setState(() => _selectedStatus = status);
          }
        },
      ),
    );
  }

  Widget _currentBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "Current",
        style: TextStyle(
          fontSize: 11,
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _statusExplanation(InquiryStatus s) {
    switch (s) {
      case InquiryStatus.pending:
        return "Awaiting assignment";
      case InquiryStatus.assigned:
        return "Provider assigned";
      case InquiryStatus.inProgress:
        return "Service is in progress";
      case InquiryStatus.completed:
        return "Service completed";
      case InquiryStatus.cancelled:
        return "Service request cancelled";
    }
  }

  Widget _buildUpdateButton() {
    final isChanged = _selectedStatus != widget.inquiry.status;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
        color: Colors.white,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: isChanged ? _updateStatus : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            disabledBackgroundColor: Colors.grey.shade400,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text(
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
