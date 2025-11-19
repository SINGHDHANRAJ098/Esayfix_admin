// screens/inquiry_details_screen.dart
import 'package:flutter/material.dart';
import '../inquiry_model/inquiry.model.dart';
import '../inquiry_model/inquiry_provider_model.dart';
import '../inquiry_model/inquiry_status_model.dart';
import 'assign_provider_screen.dart';
import 'inquiry_track_screen.dart';

class InquiryDetailsScreen extends StatefulWidget {
  final Inquiry inquiry;
  final List<ProviderModel> providers;

  final Function(InquiryStatus) onStatusUpdate;
  final Function(ProviderModel) onAssignProvider;
  final Function(ProviderModel, String) onUpdateProvider;
  final Function(PaymentStatus, PaymentMethod?) onPaymentUpdate;

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
    required this.onAddAdminNote,
    required this.onUpdateInquiryPrice,
  });

  @override
  State<InquiryDetailsScreen> createState() => _InquiryDetailsScreenState();
}

class _InquiryDetailsScreenState extends State<InquiryDetailsScreen> {
  late Inquiry inquiry;

  @override
  void initState() {
    super.initState();
    inquiry = widget.inquiry;
  }

  void _updateStatus(InquiryStatus newStatus) {
    setState(() => inquiry.status = newStatus);
    widget.onStatusUpdate(newStatus);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Service ${newStatus.label}"),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f7f7),
      appBar: _appBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _topDetailsCard(),
          const SizedBox(height: 20),

          _paymentInfoCard(),
          const SizedBox(height: 20),

          if (inquiry.provider != null) _providerCard(),

          const SizedBox(height: 20),
          _actionButtons(),
        ],
      ),
    );
  }

  // APP BAR

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      centerTitle: true,
      title: const Text(
        "Service Details",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: 18,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  // TOP SERVICE INFO CARD — Minimal, Clean

  Widget _topDetailsCard() {
    final status = inquiry.status;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                inquiry.service,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: status.color, width: 1),
                ),
                child: Text(
                  status.label,
                  style: TextStyle(
                    color: status.color,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          _infoRow("Booking ID", inquiry.id),
          _infoRow("User Name", inquiry.customer),
          _infoRow("User Number", inquiry.customerPhone ?? "N/A"),

          if (inquiry.price != null)
            _infoRow("Price", "₹${inquiry.price!.toStringAsFixed(2)}"),

          Row(
            children: [
              Expanded(child: _infoRow("Date", inquiry.date)),
              Expanded(child: _infoRow("Time", inquiry.time)),
            ],
          ),

          if (inquiry.userNotes != null) ...[
            const SizedBox(height: 14),
            const Text(
              "User Note",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade100),
              ),
              child: Text(
                inquiry.userNotes!,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Info Row — clean alignment
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  // PAYMENT INFORMATION — Minimal Clean

  Widget _paymentInfoCard() {
    final isPaid = inquiry.paymentStatus == PaymentStatus.paid;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Payment Information",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),

          const SizedBox(height: 20),

          _paymentRow(
            title: "Total Amount",
            value: "₹${(inquiry.price ?? 0).toStringAsFixed(2)}",
          ),

          const SizedBox(height: 14),

          _paymentRow(
            title: "Payment Status",
            value: isPaid ? "Paid" : "Unpaid",
            valueColor: isPaid ? Colors.green : Colors.redAccent,
          ),

          const SizedBox(height: 14),

          _paymentRow(
            title: "Payment Method",
            value: _paymentMethodLabel(inquiry.paymentMethod),
          ),
        ],
      ),
    );
  }

  Widget _paymentRow({
    required String title,
    required String value,
    Color valueColor = Colors.black,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  String _paymentMethodLabel(PaymentMethod? method) {
    if (method == null) return "N/A";
    if (method == PaymentMethod.cash) return "Cash";
    if (method == PaymentMethod.online) return "Online";
    return "N/A";
  }

  // PROVIDER CARD

  Widget _providerCard() {
    final p = inquiry.provider!;
    final canReassign =
        inquiry.status == InquiryStatus.assigned ||
        inquiry.status == InquiryStatus.inProgress;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              const Icon(Icons.engineering, color: Colors.redAccent),
              const SizedBox(width: 8),
              const Text(
                "Assigned Provider",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const Spacer(),

              if (canReassign)
                TextButton.icon(
                  onPressed: _handleReassign,
                  icon: const Icon(Icons.swap_horiz, color: Colors.redAccent),
                  label: const Text(
                    "Reassign",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.redAccent.withOpacity(.15),
                child: Text(
                  p.name[0],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.redAccent,
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
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 16, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          p.phone,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (inquiry.assignedAt != null) ...[
            const SizedBox(height: 16),
            Text(
              "Assigned on: ${_formatDateTime(inquiry.assignedAt!)}",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13.2),
            ),
          ],
        ],
      ),
    );
  }

  void _handleReassign() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AssignInquiryScreen(
          inquiry: inquiry,
          providers: widget.providers,
          onAssign: (provider) {
            widget.onAssignProvider(provider);
            setState(() {
              inquiry.provider = provider;
              inquiry.assignedAt = DateTime.now();
            });
          },
        ),
      ),
    );
  }

  // ACTION BUTTONS

  Widget _actionButtons() {
    if (inquiry.status == InquiryStatus.completed ||
        inquiry.status == InquiryStatus.cancelled) {
      return const SizedBox();
    }

    return Column(
      children: [
        if (inquiry.status == InquiryStatus.pending)
          _actionBtn(
            label: "Assign Provider",
            icon: Icons.person_add,
            color: Colors.redAccent,
            onTap: () => _handleAssignProvider(),
          ),

        if (inquiry.status == InquiryStatus.pending) const SizedBox(height: 12),

        _actionBtn(
          label: "Track Inquiry",
          icon: Icons.track_changes,
          color: Colors.green,
          onTap: _handleTrack,
        ),

        const SizedBox(height: 12),

        _actionBtn(
          label: "Cancel Service",
          icon: Icons.cancel,
          color: Colors.redAccent,
          onTap: _showCancelDialog,
        ),
      ],
    );
  }

  void _handleAssignProvider() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AssignInquiryScreen(
          inquiry: inquiry,
          providers: widget.providers,
          onAssign: (provider) {
            widget.onAssignProvider(provider);
            setState(() {
              inquiry.provider = provider;
              inquiry.status = InquiryStatus.assigned;
              inquiry.assignedAt = DateTime.now();
            });
          },
        ),
      ),
    );
  }

  void _handleTrack() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InquiryTrackScreen(
          inquiry: inquiry,
          providers: widget.providers,
          onStatusUpdate: widget.onStatusUpdate,
          onUpdateProvider: widget.onUpdateProvider,
        ),
      ),
    );
  }

  // CANCEL DIALOG

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          "Cancel Service",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: const Text(
          "Are you sure? This action cannot be undone.",
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _updateStatus(InquiryStatus.cancelled);
            },
            child: const Text(
              "Yes, Cancel",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  // ACTION BUTTON WIDGET

  Widget _actionBtn({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15.5,
            color: Colors.white,
          ),
        ),
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

  // DECORATION FOR CARDS — Minimal Clean

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // Format date-time
  String _formatDateTime(DateTime dt) {
    return "${dt.day.toString().padLeft(2, '0')}/"
        "${dt.month.toString().padLeft(2, '0')}/"
        "${dt.year}   "
        "${dt.hour.toString().padLeft(2, '0')}:"
        "${dt.minute.toString().padLeft(2, '0')}";
  }
}
