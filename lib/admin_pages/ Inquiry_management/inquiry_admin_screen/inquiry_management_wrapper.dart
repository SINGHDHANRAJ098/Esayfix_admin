// screens/inquiry_management_wrapper.dart
import 'package:flutter/material.dart';
import '../inquiry_data_service/inquiry_data_service.dart';
import '../inquiry_model/inquiry.model.dart';
import '../inquiry_model/inquiry_provider_model.dart';
import '../inquiry_model/inquiry_status_model.dart';

import 'inquiry_list_screen.dart';

class InquiryManagementWrapper extends StatefulWidget {
  const InquiryManagementWrapper({super.key});

  @override
  State<InquiryManagementWrapper> createState() => _InquiryManagementWrapperState();
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
    _filteredInquiries.addAll(_dataService.inquiries);
  }

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

  void _onUpdateProvider(String inquiryId, ProviderModel newProvider, String reason) {
    setState(() {
      _dataService.updateProvider(inquiryId, newProvider, reason);
      _applyFilters();
    });
  }

  void _onPaymentUpdate(String inquiryId, PaymentStatus status, PaymentMethod? method) {
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

  void _applyFilters() {
    setState(() {
      _filteredInquiries.clear();

      // Apply search filter first
      List<Inquiry> results = _dataService.inquiries;
      if (_searchQuery.isNotEmpty) {
        results = _dataService.searchInquiries(_searchQuery);
      }

      // Apply status filter
      if (_currentFilter != null) {
        results = results.where((inquiry) => inquiry.status == _currentFilter).toList();
      }

      _filteredInquiries.addAll(results);
    });
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
      _applyFilters();
    });
  }

  void _onFilterChange(InquiryStatus? status) {
    setState(() {
      _currentFilter = status;
      _applyFilters();
    });
  }

  void _refreshData() {
    setState(() {
      _applyFilters();
    });
  }

  Map<String, dynamic> _getStatistics() {
    return _dataService.getStatistics();
  }

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