import 'package:flutter/material.dart';
import '../inquiry_data_service/inquiry_data_service.dart';
import '../inquiry_model/inquiry.model.dart';
import '../inquiry_model/inquiry_provider_model.dart';
import '../inquiry_model/inquiry_status_model.dart';
import 'inquiry_list_screen.dart';

class InquiryManagementWrapper extends StatefulWidget {
  final String? initialFilter;

  const InquiryManagementWrapper({super.key, this.initialFilter});

  @override
  State<InquiryManagementWrapper> createState() =>
      _InquiryManagementWrapperState();
}

class _InquiryManagementWrapperState extends State<InquiryManagementWrapper> {
  final InquiryDataService _dataService = InquiryDataService();
  final List<Inquiry> _filteredInquiries = [];

  String _searchQuery = '';
  InquiryStatus? _currentFilter;

  @override
  void initState() {
    super.initState();
    _dataService.initializeData();

    // Set initial filter if provided
    if (widget.initialFilter != null) {
      _currentFilter = InquiryStatusX.fromString(widget.initialFilter!);
    }

    _applyFilters();
  }

  // CALLBACK UPDATES
  void _onStatusUpdate(String inquiryId, InquiryStatus newStatus) {
    setState(() {
      _dataService.updateInquiryStatus(inquiryId, newStatus);
      _applyFilters();
    });
  }

  void _onAssignProvider(String inquiryId, ProviderModel provider) {
    setState(() {
      _dataService.assignProvider(inquiryId, provider);
      _applyFilters();
    });
  }

  void _onUpdateProvider(
      String inquiryId,
      ProviderModel newProvider,
      String reason,
      ) {
    setState(() {
      _dataService.updateProvider(inquiryId, newProvider, reason);
      _applyFilters();
    });
  }

  void _onPaymentUpdate(
      String inquiryId,
      PaymentStatus status,
      PaymentMethod? method,
      ) {
    setState(() {
      _dataService.updatePaymentStatus(inquiryId, status, method);
      _applyFilters();
    });
  }

  void _onUpdateAdminNotes(String inquiryId, String notes) {
    setState(() {
      _dataService.updateAdminNotes(inquiryId, notes);
      _applyFilters();
    });
  }

  void _onAddAdminNote(String inquiryId, String note) {
    setState(() {
      _dataService.addAdminNote(inquiryId, note);
      _applyFilters();
    });
  }

  void _onUpdateInquiryPrice(String inquiryId, double newPrice) {
    setState(() {
      _dataService.updateInquiryPrice(inquiryId, newPrice);
      _applyFilters();
    });
  }

  // FILTER + SEARCH
  void _applyFilters() {
    List<Inquiry> results = _dataService.inquiries;

    if (_searchQuery.isNotEmpty) {
      results = _dataService.searchInquiries(_searchQuery);
    }

    if (_currentFilter != null) {
      results = results.where((i) => i.status == _currentFilter).toList();
    }

    setState(() {
      _filteredInquiries
        ..clear()
        ..addAll(results);
    });
  }

  void _onSearch(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void _onFilterChange(InquiryStatus? status) {
    _currentFilter = status;
    _applyFilters();
  }

  void _refreshData() {
    _applyFilters();
  }

  Map<String, dynamic> _getStatistics() {
    return _dataService.getStatistics();
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: InquiryListScreen(
        inquiries: _filteredInquiries,
        providers: _dataService.providers,
        onStatusUpdate: _onStatusUpdate,
        onAssignProvider: _onAssignProvider,
        onUpdateProvider: _onUpdateProvider,
        onPaymentUpdate: _onPaymentUpdate,
        onUpdateAdminNotes: _onUpdateAdminNotes,
        onAddAdminNote: _onAddAdminNote,
        onUpdateInquiryPrice: _onUpdateInquiryPrice,
        searchQuery: _searchQuery,
        currentFilter: _currentFilter,
        onSearch: _onSearch,
        onFilterChange: _onFilterChange,
        onRefresh: _refreshData,
        statistics: _getStatistics(),
      ),
    );
  }
}