// screens/inquiry_list_screen.dart
import 'package:flutter/material.dart';
import '../inquiry_model/inquiry.model.dart';
import '../inquiry_model/inquiry_provider_model.dart';
import '../inquiry_model/inquiry_status_model.dart';
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
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTopBar(),
          const SizedBox(height: 8),
          Expanded(child: _buildInquiryList()),
        ],
      ),
    );
  }

  // --------------------- APP BAR ---------------------
  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0.5,
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
    );
  }

  // --------------------- SEARCH + FILTERS ---------------------
  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),

          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search by ID, name, phone…',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              onChanged: widget.onSearch,
            ),
          ),

          const SizedBox(height: 12),

          // Filter Chips
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip("All", null),
                const SizedBox(width: 10),
                ...InquiryStatus.values.map(
                      (status) => Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: _buildFilterChip(status.label, status),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, InquiryStatus? status) {
    final bool isSelected = widget.currentFilter == status;

    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
      selected: isSelected,
      selectedColor: Colors.redAccent,
      backgroundColor: Colors.grey[200],
      onSelected: (value) => widget.onFilterChange(value ? status : null),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  // --------------------- LIST ---------------------
  Widget _buildInquiryList() {
    if (widget.inquiries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 12),
            const Text(
              "No inquiries found",
              style: TextStyle(color: Colors.black54, fontSize: 16),
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
        itemBuilder: (context, index) =>
            _buildInquiryCard(widget.inquiries[index]),
      ),
    );
  }

  // --------------------- CARD UI (Option A Minimal) ---------------------
  Widget _buildInquiryCard(Inquiry inquiry) {
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
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => InquiryDetailsScreen(
                inquiry: inquiry,
                providers: widget.providers,
                onStatusUpdate: (newStatus) =>
                    widget.onStatusUpdate(inquiry.id, newStatus),
                onAssignProvider: (provider) =>
                    widget.onAssignProvider(inquiry.id, provider),
                onUpdateProvider: (provider, reason) =>
                    widget.onUpdateProvider(inquiry.id, provider, reason),
                onPaymentUpdate: (status, method) =>
                    widget.onPaymentUpdate(inquiry.id, status, method),
                onAddAdminNote: (note) =>
                    widget.onAddAdminNote(inquiry.id, note),
                onUpdateInquiryPrice: (newPrice) =>
                    widget.onUpdateInquiryPrice(inquiry.id, newPrice),
              ),
            ),
          );
        },
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
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  _statusChip(inquiry.status),
                ],
              ),

              const SizedBox(height: 16),

              _infoLine(Icons.person, inquiry.customer),
              const SizedBox(height: 6),

              if (inquiry.customerPhone != null)
                _infoLine(Icons.phone, inquiry.customerPhone!),

              const SizedBox(height: 6),

              _infoLine(Icons.location_on, inquiry.location),
              const SizedBox(height: 6),

              _infoLine(Icons.calendar_today,
                  "${inquiry.date} • ${inquiry.time}"),

              const SizedBox(height: 16),

              if (inquiry.provider != null) _providerChip(inquiry.provider!),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------- MINIMAL PROVIDER CHIP ---------------------
  Widget _providerChip(ProviderModel provider) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.redAccent.withOpacity(.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.engineering, size: 16, color: Colors.redAccent),
              const SizedBox(width: 6),
              Text(
                provider.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --------------------- SMALL INFO ROW ---------------------
  Widget _infoLine(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
          ),
        ),
      ],
    );
  }

  // --------------------- STATUS CHIP ---------------------
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
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: status.color,
        ),
      ),
    );
  }
}
