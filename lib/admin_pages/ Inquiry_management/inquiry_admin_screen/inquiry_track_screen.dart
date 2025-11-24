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
  // SNACKBAR SUCCESS MESSAGE

  void _success(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // CHANGE PROVIDER BOTTOM SHEET

  void _showChangeProviderSheet() {
    final available = widget.providers.where((p) => p.available).toList();

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                "Change Provider",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              const SizedBox(height: 10),

              Expanded(
                child: ListView.builder(
                  controller: controller,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: available.length,
                  itemBuilder: (_, i) => _providerOption(available[i]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _providerOption(ProviderModel p) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: Colors.redAccent.withOpacity(.12),
          child: Text(
            p.name[0],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
        ),
        title: Text(
          p.name,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(
          p.specialty,
          style: TextStyle(color: Colors.grey.shade600),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.pop(context);
          widget.onUpdateProvider(p, "Admin updated provider");
          _success("Provider changed to ${p.name}");
        },
      ),
    );
  }

  // CANCEL INQUIRY

  void _cancelInquiry() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Cancel Inquiry"),
        content: const Text("Are you sure you want to cancel this inquiry?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onStatusUpdate(InquiryStatus.cancelled);
              _success("Inquiry canceled");
            },
            child: const Text("Cancel", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // MAIN UI

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Track Inquiry",
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _statusCard(),
          if (widget.inquiry.provider != null) ...[
            const SizedBox(height: 16),
            _providerCard(),
          ],
          const SizedBox(height: 16),
          _actionCard(),
          const SizedBox(height: 16),
          _timelineCard(),
        ],
      ),
    );
  }

  // MINIMAL STATUS CARD

  Widget _statusCard() {
    final status = widget.inquiry.status;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _box(),
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: status.color.withOpacity(.12),
            child: Icon(status.icon, color: status.color, size: 28),
          ),

          const SizedBox(height: 12),

          Text(
            status.label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: status.color,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "Booking ID: ${widget.inquiry.id}",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // PROVIDER CARD

  Widget _providerCard() {
    final p = widget.inquiry.provider!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _box(),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.blue.shade50,
            child: Text(
              p.name[0],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
                fontSize: 18,
              ),
            ),
          ),

          const SizedBox(width: 14),

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
                const SizedBox(height: 3),
                Text(
                  p.specialty,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.phone, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(p.phone),
                  ],
                ),
              ],
            ),
          ),

          IconButton(
            icon: const Icon(Icons.swap_horiz, color: Colors.redAccent),
            onPressed: _showChangeProviderSheet,
          ),
        ],
      ),
    );
  }

  // ACTION CARD

  Widget _actionCard() {
    final disabled =
        widget.inquiry.status == InquiryStatus.completed ||
        widget.inquiry.status == InquiryStatus.cancelled;

    if (disabled) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: _box(),
        child: const Center(
          child: Text(
            "No actions available",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _box(),
      child: Column(
        children: [
          _actionBtn(
            "Change Provider",
            Icons.swap_horiz,
            Colors.blue,
            _showChangeProviderSheet,
          ),
          const SizedBox(height: 12),

          _actionBtn(
            "Cancel Inquiry",
            Icons.cancel,
            Colors.red,
            _cancelInquiry,
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18, color: Colors.white),
        label: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // TIMELINE — MINIMAL STYLE

  Widget _timelineCard() {
    final items = [
      _History("Inquiry Created", "System", "Today"),
      if (widget.inquiry.provider != null)
        _History("Assigned", "Admin", "Today"),
      if (widget.inquiry.status == InquiryStatus.inProgress)
        _History("Work in Progress", "Provider", "Today"),
      if (widget.inquiry.status == InquiryStatus.completed)
        _History("Completed", "Provider", "Today"),
      if (widget.inquiry.status == InquiryStatus.cancelled)
        _History("Cancelled", "Admin", "Today"),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _box(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.history, color: Colors.redAccent),
              SizedBox(width: 8),
              Text(
                "Status History",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map(_timelineItem),
        ],
      ),
    );
  }

  Widget _timelineItem(_History item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: Colors.redAccent,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "By ${item.by} • ${item.time}",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _box() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.grey.shade300),
    );
  }
}

class _History {
  final String title;
  final String by;
  final String time;

  _History(this.title, this.by, this.time);
}
