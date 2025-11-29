import 'package:flutter/material.dart';
import '../inquiry_model/inquiry.model.dart';
import '../inquiry_model/inquiry_provider_model.dart';
import '../inquiry_model/inquiry_status_model.dart';

import 'assign_provider_screen.dart';
import 'inquiry_details_screen.dart';

class InquiryListScreen extends StatefulWidget {
  final List<Inquiry> inquiries;
  final List<ProviderModel> providers;

  final Function(String, InquiryStatus) onStatusUpdate;
  final Function(String, ProviderModel) onAssignProvider;
  final Function(String, ProviderModel, String) onUpdateProvider;
  final Function(String, PaymentStatus, PaymentMethod?) onPaymentUpdate;

  final Function(String, String) onUpdateAdminNotes;
  final Function(String, String) onAddAdminNote;
  final Function(String, double) onUpdateInquiryPrice;

  final String searchQuery;
  final InquiryStatus? currentFilter;

  final Function(String) onSearch;
  final Function(InquiryStatus?) onFilterChange;
  final VoidCallback onRefresh;

  final Map<String, dynamic> statistics;

  const InquiryListScreen({
    super.key,
    required this.inquiries,
    required this.providers,
    required this.onStatusUpdate,
    required this.onAssignProvider,
    required this.onUpdateProvider,
    required this.onPaymentUpdate,
    required this.onUpdateAdminNotes,
    required this.onAddAdminNote,
    required this.onUpdateInquiryPrice,
    required this.searchQuery,
    required this.currentFilter,
    required this.onSearch,
    required this.onFilterChange,
    required this.onRefresh,
    required this.statistics,
  });

  @override
  State<InquiryListScreen> createState() => _InquiryListScreenState();
}

class _InquiryListScreenState extends State<InquiryListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchQuery;
  }

  @override
  void didUpdateWidget(InquiryListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      _searchController.text = widget.searchQuery;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0.3,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Inquiry Management",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildTopBar(),
          const SizedBox(height: 8),
          Expanded(child: _buildInquiryList()),
        ],
      ),
    );
  }

  // SEARCH + FILTER
  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),

          // Show active filter label if filter is applied
          if (widget.currentFilter != null) ...[
            Row(
              children: [
                Icon(Icons.filter_alt, size: 16, color: Colors.redAccent),
                SizedBox(width: 4),
                Text(
                  "Showing: ${widget.currentFilter!.label}",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () => widget.onFilterChange(null),
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, size: 14, color: Colors.grey.shade700),
                  ),
                )
              ],
            ),
            SizedBox(height: 8),
          ],

          // Search Box
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                hintText: "Search by ID, name, phone…",
                border: InputBorder.none,
                contentPadding:
                EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              onChanged: widget.onSearch,
            ),
          ),

          const SizedBox(height: 12),

          // Filters
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _filterChip("All", null),
                const SizedBox(width: 10),
                ...InquiryStatus.values.map(
                      (s) => Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: _filterChip(s.label, s),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _filterChip(String label, InquiryStatus? status) {
    final selected = widget.currentFilter == status;

    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      selected: selected,
      selectedColor: Colors.redAccent,
      backgroundColor: Colors.grey.shade200,
      onSelected: (_) => widget.onFilterChange(status),
    );
  }

  // LIST
  Widget _buildInquiryList() {
    if (widget.inquiries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 60, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
                widget.currentFilter != null
                    ? "No ${widget.currentFilter!.label.toLowerCase()} inquiries found"
                    : "No inquiries found",
                style: const TextStyle(color: Colors.black54)
            )
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => widget.onRefresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.inquiries.length,
        itemBuilder: (_, i) => _inquiryCard(widget.inquiries[i]),
      ),
    );
  }

  // CARD
  Widget _inquiryCard(Inquiry inquiry) {
    String formattedCreatedAt() {
      final d = inquiry.createdAt;
      final day = d.day.toString().padLeft(2, '0');
      final month = d.month.toString().padLeft(2, '0');
      final year = d.year.toString();
      final hour = d.hour.toString().padLeft(2, '0');
      final minute = d.minute.toString().padLeft(2, '0');
      return "$day-$month-$year • $hour:$minute";
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => InquiryDetailsScreen(
                inquiry: inquiry,
                providers: widget.providers,
                onStatusUpdate: (s) =>
                    widget.onStatusUpdate(inquiry.id, s),
                onAssignProvider: (p) =>
                    widget.onAssignProvider(inquiry.id, p),
                onUpdateProvider: (p, r) =>
                    widget.onUpdateProvider(inquiry.id, p, r),
                onPaymentUpdate: (s, m) =>
                    widget.onPaymentUpdate(inquiry.id, s, m),
                onAddAdminNote: (n) =>
                    widget.onAddAdminNote(inquiry.id, n),
                onUpdateInquiryPrice: (p) =>
                    widget.onUpdateInquiryPrice(inquiry.id, p),
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ID + STATUS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    inquiry.id,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  _statusChip(inquiry.status),
                ],
              ),

              const SizedBox(height: 8),

              // CREATED AT (Order date & time)
              _info(Icons.access_time, formattedCreatedAt()),

              const SizedBox(height: 12),

              _info(Icons.person, inquiry.customer),
              const SizedBox(height: 8),
              _info(Icons.phone, inquiry.customerPhone ?? "-"),
              const SizedBox(height: 8),
              _info(Icons.location_on,
                  inquiry.customerAddress ?? inquiry.location),
              const SizedBox(height: 8),
              _info(Icons.calendar_month, inquiry.date),
              const SizedBox(height: 8),
              _info(Icons.schedule, inquiry.time),

              const SizedBox(height: 14),

              //  PROVIDER INFO ONLY IF ASSIGNED
              if (inquiry.status == InquiryStatus.assigned &&
                  inquiry.provider != null) ...[
                Row(
                  children: [
                    const Icon(Icons.handshake,
                        size: 18, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      "Provider: ${inquiry.provider!.name}",
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.phone,
                        size: 18, color: Colors.blueAccent),
                    const SizedBox(width: 8),
                    Text(
                      inquiry.provider!.phone,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],

              //  BUTTONS ONLY WHEN PENDING
              if (inquiry.status == InquiryStatus.pending) ...[
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AssignInquiryScreen(
                                inquiry: inquiry,
                                providers: widget.providers,
                                onAssign: (provider) {
                                  widget.onAssignProvider(
                                      inquiry.id, provider);
                                },
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text(
                          "Assign Provider",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () =>
                            widget.onStatusUpdate(inquiry.id,
                                InquiryStatus.cancelled),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ],
          ),
        ),
      ),
    );
  }

     // UI HELPERS
  Widget _info(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey.shade800, fontSize: 14),
          ),
        )
      ],
    );
  }

  Widget _statusChip(InquiryStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: status.color.withOpacity(.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: status.color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}