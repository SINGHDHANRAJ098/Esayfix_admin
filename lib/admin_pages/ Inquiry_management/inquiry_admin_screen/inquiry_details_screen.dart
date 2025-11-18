
import 'package:flutter/material.dart';

import '../inquiry_model/inquiry.model.dart';
import '../inquiry_model/inquiry_provider_model.dart';
import '../inquiry_model/inquiry_status_model.dart';
import 'assign_provider_screen.dart';
import 'update_status_screen.dart';
import 'inquiry_track_screen.dart';

class InquiryDetailsScreen extends StatefulWidget {
  final Inquiry inquiry;
  final List<ProviderModel> providers;
  final Function(InquiryStatus) onStatusUpdate;
  final Function(ProviderModel) onAssignProvider;
  final Function(ProviderModel, String) onUpdateProvider;

  const InquiryDetailsScreen({
    super.key,
    required this.inquiry,
    required this.providers,
    required this.onStatusUpdate,
    required this.onAssignProvider,
    required this.onUpdateProvider,
  });

  @override
  State<InquiryDetailsScreen> createState() => _InquiryDetailsScreenState();
}

class _InquiryDetailsScreenState extends State<InquiryDetailsScreen> {
  late Inquiry _currentInquiry;

  @override
  void initState() {
    super.initState();
    _currentInquiry = widget.inquiry;
  }

  void _updateStatus(InquiryStatus newStatus) {
    setState(() {
      _currentInquiry.status = newStatus;
    });
    widget.onStatusUpdate(newStatus);
    _showSuccessSnackbar('Status updated to ${newStatus.label}');
  }

  void _assignProvider(ProviderModel provider) {
    setState(() {
      _currentInquiry.provider = provider;
      _currentInquiry.status = InquiryStatus.assigned;
    });
    widget.onAssignProvider(provider);
    _showSuccessSnackbar('Assigned to ${provider.name}');
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
          "Inquiry Details",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.redAccent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Status Card
            _buildStatusCard(),
            SizedBox(height: 20),
            // Booking Information
            _buildBookingInfoCard(),
            SizedBox(height: 20),
            // Provider Information (if assigned)
            if (_currentInquiry.provider != null) _buildProviderCard(),
            SizedBox(height: 20),
            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _currentInquiry.status.color.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: _currentInquiry.status.color.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                _currentInquiry.status.icon,
                size: 30,
                color: _currentInquiry.status.color,
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
                    _currentInquiry.status.label,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _currentInquiry.status.color,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Booking ID: ${_currentInquiry.id}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingInfoCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: Colors.redAccent),
                SizedBox(width: 8),
                Text(
                  "Booking Information",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildDetailRow("Service", _currentInquiry.service, Icons.build),
            _buildDetailRow("Customer", _currentInquiry.customer, Icons.person),
            if (_currentInquiry.customerPhone != null)
              _buildDetailRow("Phone", _currentInquiry.customerPhone!, Icons.phone),
            _buildDetailRow("Location", _currentInquiry.location, Icons.location_on),
            _buildDetailRow("Date & Time", "${_currentInquiry.date} • ${_currentInquiry.time}", Icons.calendar_today),
            if (_currentInquiry.price != null)
              _buildDetailRow("Price", "\$${_currentInquiry.price!.toStringAsFixed(2)}", Icons.attach_money),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            child: Icon(icon, size: 20, color: Colors.grey[600]),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProviderCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.blue[100],
                child: Text(
                  _currentInquiry.provider!.name[0],
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              title: Text(
                _currentInquiry.provider!.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_currentInquiry.provider!.specialty),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.orange),
                      SizedBox(width: 4),
                      Text(
                        _currentInquiry.provider!.rating.toStringAsFixed(1),
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: 16),
                      Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Text(_currentInquiry.provider!.phone),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Manage Inquiry",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 16),
            if (_currentInquiry.status == InquiryStatus.pending)
              _buildActionButton(
                "Assign Provider",
                Icons.person_add,
                Colors.blue,
                "Assign a service provider to this inquiry",
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AssignInquiryScreen(
                        inquiry: _currentInquiry,
                        providers: widget.providers,
                        onAssign: _assignProvider,
                      ),
                    ),
                  );
                },
              ),
            SizedBox(height: 12),
            _buildActionButton(
              "Update Status",
              Icons.update,
              Colors.orange,
              "Change the current status of this inquiry",
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UpdateStatusScreen(
                      inquiry: _currentInquiry,
                      onStatusUpdate: _updateStatus,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 12),
            _buildActionButton(
              "Track Inquiry",
              Icons.track_changes,
              Colors.green,
              "Monitor progress and manage providers",
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => InquiryTrackScreen(
                      inquiry: _currentInquiry,
                      providers: widget.providers,
                      onStatusUpdate: _updateStatus,
                      onUpdateProvider: widget.onUpdateProvider,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon, Color color, String description, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
          ],
        ),
      ),
    );
  }
}