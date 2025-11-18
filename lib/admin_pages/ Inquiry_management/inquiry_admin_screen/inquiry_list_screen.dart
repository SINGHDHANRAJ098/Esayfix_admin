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
  void didUpdateWidget(covariant InquiryListScreen oldWidget) {
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

  // Helper method to get icon for status
  IconData _getStatusIcon(InquiryStatus status) {
    switch (status) {
      case InquiryStatus.pending:
        return Icons.pending;
      case InquiryStatus.assigned:
        return Icons.assignment_ind;
      case InquiryStatus.inProgress:
        return Icons.build;
      case InquiryStatus.completed:
        return Icons.check_circle;
      case InquiryStatus.cancelled:
        return Icons.cancel;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Inquiry Management",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: _buildAppBarContent(),
        ),
      ),
      body: _buildInquiryList(),
    );
  }

  Widget _buildAppBarContent() {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search by customer, service, ID...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  _searchController.clear();
                  widget.onSearch('');
                },
              )
                  : null,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            onChanged: widget.onSearch,
          ),
        ),
        // Filter Chips
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildFilterChip('All', null),
              const SizedBox(width: 8),
              ...InquiryStatus.values.map((status) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildFilterChip(status.label, status),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, InquiryStatus? status) {
    final isSelected = widget.currentFilter == status;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        widget.onFilterChange(selected ? status : null);
      },
      backgroundColor: Colors.white,
      selectedColor: Colors.redAccent,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.redAccent,
        fontWeight: FontWeight.w500,
      ),
      side: BorderSide(color: Colors.redAccent),
    );
  }

  Widget _buildInquiryList() {
    if (widget.inquiries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              widget.currentFilter != null
                  ? 'No ${widget.currentFilter!.label.toLowerCase()} inquiries'
                  : 'No inquiries found',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            if (widget.searchQuery.isNotEmpty)
              Text(
                'Try adjusting your search criteria',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                ),
              ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        widget.onRefresh();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.inquiries.length,
        itemBuilder: (context, index) {
          final inquiry = widget.inquiries[index];
          return _buildInquiryCard(inquiry);
        },
      ),
    );
  }

  Widget _buildInquiryCard(Inquiry inquiry) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => InquiryDetailsScreen(
                inquiry: inquiry,
                providers: widget.providers,
                onStatusUpdate: (newStatus) => widget.onStatusUpdate(inquiry.id, newStatus),
                onAssignProvider: (provider) => widget.onAssignProvider(inquiry.id, provider),
                onUpdateProvider: (newProvider, reason) => widget.onUpdateProvider(inquiry.id, newProvider, reason),
                onPaymentUpdate: (status, method) => widget.onPaymentUpdate(inquiry.id, status, method),
                onUpdateAdminNotes: (notes) => widget.onUpdateAdminNotes(inquiry.id, notes),
                onAddAdminNote: (note) => widget.onAddAdminNote(inquiry.id, note),
                onUpdateInquiryPrice: (newPrice) => widget.onUpdateInquiryPrice(inquiry.id, newPrice),
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with Booking ID and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "ID: ${inquiry.id}",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: inquiry.status.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: inquiry.status.color.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getStatusIcon(inquiry.status),
                          size: 14,
                          color: inquiry.status.color,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          inquiry.status.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: inquiry.status.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Service Title and Price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      inquiry.service,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  if (inquiry.price != null)
                    Text(
                      "\$${inquiry.price!.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              // Customer Info
              _buildInfoRow(Icons.person, inquiry.customer),
              const SizedBox(height: 6),
              // Phone
              if (inquiry.customerPhone != null)
                _buildInfoRow(Icons.phone, inquiry.customerPhone!),
              const SizedBox(height: 6),
              // Location
              _buildInfoRow(Icons.location_on, inquiry.location),
              const SizedBox(height: 6),
              // Date & Time
              _buildInfoRow(Icons.calendar_today, "${inquiry.date} • ${inquiry.time}"),
              // Payment Status
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: inquiry.paymentStatus.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      inquiry.paymentStatus.icon,
                      size: 12,
                      color: inquiry.paymentStatus.color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      inquiry.paymentStatus.label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: inquiry.paymentStatus.color,
                      ),
                    ),
                  ],
                ),
              ),
              // Assigned Provider
              if (inquiry.provider != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.engineering, size: 16, color: Colors.blue[700]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Assigned to: ${inquiry.provider!.name}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.star, size: 12, color: Colors.orange),
                            const SizedBox(width: 2),
                            Text(
                              inquiry.provider!.rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue[800],
                                fontWeight: FontWeight.bold,
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
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }
}