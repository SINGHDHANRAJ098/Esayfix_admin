// screens/inquiry_details_screen.dart
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
  final Function(PaymentStatus, PaymentMethod?) onPaymentUpdate;

  final Function(String) onUpdateAdminNotes;
  final Function(String) onAddAdminNote;
  final Function(double) onUpdateInquiryPrice;

  const InquiryDetailsScreen({
    super.key,
    required this.inquiry,
    required this.providers,
    required this.onStatusUpdate,
    required this.onAssignProvider,
    required this.onUpdateProvider,
    required this.onPaymentUpdate,
    required this.onUpdateAdminNotes,
    required this.onAddAdminNote,
    required this.onUpdateInquiryPrice,
  });

  @override
  State<InquiryDetailsScreen> createState() => _InquiryDetailsScreenState();
}

class _InquiryDetailsScreenState extends State<InquiryDetailsScreen> {
  late Inquiry inquiry;
  final TextEditingController _adminNotesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    inquiry = widget.inquiry;
    _adminNotesController.text = inquiry.adminNotes ?? '';
  }

  void _assignProvider(ProviderModel provider) {
    setState(() {
      inquiry.provider = provider;
      inquiry.status = InquiryStatus.assigned;
      inquiry.assignedAt = DateTime.now();
    });

    widget.onAssignProvider(provider);
    _showSuccess("Assigned to ${provider.name}");
  }

  void _updateStatus(InquiryStatus newStatus) {
    setState(() {
      inquiry.status = newStatus;

      // Update timestamps based on status
      if (newStatus == InquiryStatus.completed) {
        inquiry.completedAt = DateTime.now();
      } else if (newStatus == InquiryStatus.cancelled) {
        inquiry.cancelledAt = DateTime.now();
      }
    });

    widget.onStatusUpdate(newStatus);
    _showSuccess("Status updated to ${newStatus.label}");
  }

  void _updatePayment(PaymentStatus status, PaymentMethod? method) {
    setState(() {
      inquiry.paymentStatus = status;
      inquiry.paymentMethod = method;
    });

    widget.onPaymentUpdate(status, method);
    _showSuccess("Payment status updated to ${status.label}");
  }

  void _updateAdminNotes() {
    setState(() {
      inquiry.adminNotes = _adminNotesController.text;
    });
    _showSuccess("Admin notes updated");
  }

  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        margin: const EdgeInsets.all(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          "Service Details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        actions: [
          if (inquiry.status != InquiryStatus.completed &&
              inquiry.status != InquiryStatus.cancelled)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'cancel') {
                  _showCancelConfirmation();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'cancel',
                  child: Row(
                    children: [
                      Icon(Icons.cancel, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Cancel Service'),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _statusCard(),
          const SizedBox(height: 16),
          _bookingInfoCard(),
          const SizedBox(height: 16),
          _customerInfoCard(),
          const SizedBox(height: 16),
          _paymentCard(),
          const SizedBox(height: 16),
          if (inquiry.userNotes != null) _userNotesCard(),
          const SizedBox(height: 16),
          _adminNotesCard(),
          const SizedBox(height: 16),
          if (inquiry.provider != null) _providerCard(),
          const SizedBox(height: 16),
          _actionSection(),
        ],
      ),
    );
  }

  void _showCancelConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('Cancel Service'),
          ],
        ),
        content: const Text(
          'Are you sure you want to cancel this service? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _updateStatus(InquiryStatus.cancelled);
            },
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // STATUS CARD
  Widget _statusCard() {
    final s = inquiry.status;

    return Card(
      elevation: 3,
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: s.color.withOpacity(.15),
                  child: Icon(s.icon, color: s.color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Current Status",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        s.label,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: s.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Booking ID: ${inquiry.id}",
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  if (inquiry.price != null)
                    Text(
                      "\$${inquiry.price!.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.redAccent,
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

  // BOOKING INFO CARD
  Widget _bookingInfoCard() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title(Icons.build, "Service Information"),
            const SizedBox(height: 16),
            _info(Icons.build, "Service Type", inquiry.service),
            _info(Icons.calendar_today, "Date", inquiry.date),
            _info(Icons.access_time, "Time", inquiry.time),
            _info(Icons.location_on, "Service Location", inquiry.location),
          ],
        ),
      ),
    );
  }

  // CUSTOMER INFO CARD
  Widget _customerInfoCard() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title(Icons.person, "Customer Information"),
            const SizedBox(height: 16),
            _info(Icons.person, "Customer Name", inquiry.customer),
            if (inquiry.customerPhone != null)
              _info(Icons.phone, "Phone Number", inquiry.customerPhone!),
            if (inquiry.customerAddress != null)
              _info(Icons.home, "Address", inquiry.customerAddress!),
          ],
        ),
      ),
    );
  }

  // PAYMENT CARD
  Widget _paymentCard() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title(Icons.payment, "Payment Information"),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Payment Status",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: inquiry.paymentStatus.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: inquiry.paymentStatus.color.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              inquiry.paymentStatus.icon,
                              size: 14,
                              color: inquiry.paymentStatus.color,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              inquiry.paymentStatus.label,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: inquiry.paymentStatus.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (inquiry.paymentMethod != null) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Payment Method",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.blue.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                inquiry.paymentMethod!.icon,
                                size: 14,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                inquiry.paymentMethod!.label,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            if (inquiry.status != InquiryStatus.cancelled)
              _buttonSmall("Update Payment", Icons.payment, Colors.purple, () {
                _showPaymentDialog();
              }),
          ],
        ),
      ),
    );
  }

  // USER NOTES CARD
  Widget _userNotesCard() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title(Icons.note, "Customer Notes"),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange[100]!),
              ),
              child: Text(
                inquiry.userNotes!,
                style:  TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ADMIN NOTES CARD
  Widget _adminNotesCard() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title(Icons.admin_panel_settings, "Admin Notes"),
            const SizedBox(height: 12),
            TextField(
              controller: _adminNotesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Add internal notes or instructions...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 12),
            _buttonSmall(
              "Save Notes",
              Icons.save,
              Colors.blue,
              _updateAdminNotes,
            ),
          ],
        ),
      ),
    );
  }

  // PROVIDER CARD
  Widget _providerCard() {
    final p = inquiry.provider!;

    return Card(
      elevation: 2,
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _title(Icons.engineering, "Assigned Provider"),
                const Spacer(),
                if (inquiry.status == InquiryStatus.assigned ||
                    inquiry.status == InquiryStatus.inProgress)
                  _buttonSmall("Reassign", Icons.swap_horiz, Colors.orange, () {
                    _showReassignDialog();
                  }),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.blue.shade100,
                  child: Text(
                    p.name[0],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        p.specialty,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.orange, size: 16),
                          const SizedBox(width: 4),
                          Text(p.rating.toStringAsFixed(1)),
                          const SizedBox(width: 12),
                          Icon(Icons.phone, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(p.phone),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (inquiry.assignedAt != null) ...[
              const SizedBox(height: 12),
              Text(
                "Assigned on: ${_formatDateTime(inquiry.assignedAt!)}",
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ACTION SECTION
  Widget _actionSection() {
    return Card(
      elevation: 3,
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Service Actions",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 18),

            // ASSIGN PROVIDER BUTTON
            if (inquiry.status == InquiryStatus.pending)
              _button("Assign Provider", Icons.person_add, Colors.blue, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AssignInquiryScreen(
                      inquiry: inquiry,
                      providers: widget.providers,
                      onAssign: _assignProvider,
                    ),
                  ),
                );
              }),

            if (inquiry.status == InquiryStatus.pending)
              const SizedBox(height: 12),

            // UPDATE STATUS BUTTON
            _button("Update Status", Icons.update, Colors.orange, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UpdateStatusScreen(
                    inquiry: inquiry,
                    onStatusUpdate: _updateStatus,
                  ),
                ),
              );
            }),

            const SizedBox(height: 12),

            // TRACK INQUIRY BUTTON
            _button("Track Service", Icons.track_changes, Colors.green, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => InquiryTrackScreen(
                    inquiry: inquiry,
                    providers: widget.providers,
                    onStatusUpdate: _updateStatus,
                    onUpdateProvider: widget.onUpdateProvider,
                  ),
                ),
              );
            }),

            // CANCEL BUTTON
            if (inquiry.status != InquiryStatus.completed &&
                inquiry.status != InquiryStatus.cancelled)
              const SizedBox(height: 12),

            if (inquiry.status != InquiryStatus.completed &&
                inquiry.status != InquiryStatus.cancelled)
              _button(
                "Cancel Service",
                Icons.cancel,
                Colors.red,
                _showCancelConfirmation,
              ),
          ],
        ),
      ),
    );
  }

  void _showPaymentDialog() {
    PaymentStatus selectedStatus = inquiry.paymentStatus;
    PaymentMethod? selectedMethod = inquiry.paymentMethod;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Update Payment Status'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Payment Status
                const Text(
                  'Payment Status:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: PaymentStatus.values.map((status) {
                    return ChoiceChip(
                      label: Text(status.label),
                      selected: selectedStatus == status,
                      onSelected: (selected) {
                        setState(() => selectedStatus = status);
                      },
                      selectedColor: status.color.withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: selectedStatus == status
                            ? status.color
                            : Colors.grey,
                        fontWeight: selectedStatus == status
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                // Payment Method (only show if paid or partially paid)
                if (selectedStatus == PaymentStatus.paid ||
                    selectedStatus == PaymentStatus.partiallyPaid) ...[
                  const Text(
                    'Payment Method:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: PaymentMethod.values.map((method) {
                      return ChoiceChip(
                        label: Text(method.label),
                        selected: selectedMethod == method,
                        onSelected: (selected) {
                          setState(() => selectedMethod = method);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _updatePayment(selectedStatus, selectedMethod);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text(
                  'Update',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showReassignDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reassign Provider'),
        content: const Text(
          'Are you sure you want to reassign this service to a different provider?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AssignInquiryScreen(
                    inquiry: inquiry,
                    providers: widget.providers,
                    onAssign: _assignProvider,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text(
              'Reassign',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _button(String text, IconData icon, Color color, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white, size: 20),
        onPressed: onTap,
        label: Text(
          text,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Widget _buttonSmall(
    String text,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return SizedBox(
      height: 40,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white, size: 16),
        onPressed: onTap,
        label: Text(
          text,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _info(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.redAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _title(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.redAccent),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
