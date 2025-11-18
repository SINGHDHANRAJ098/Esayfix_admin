// screens/inquiry_management_wrapper.dart
import 'package:flutter/material.dart';
import '../inquiry_data_service/inquiry_data_service.dart';
import 'inquiry_list_screen.dart';

class InquiryManagementWrapper extends StatefulWidget {
  const InquiryManagementWrapper({super.key});

  @override
  State<InquiryManagementWrapper> createState() => _InquiryManagementWrapperState();
}

class _InquiryManagementWrapperState extends State<InquiryManagementWrapper> {
  final InquiryDataService _dataService = InquiryDataService();

  @override
  void initState() {
    super.initState();
    _dataService.initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return InquiryListScreen(
      inquiries: _dataService.inquiries,
      providers: _dataService.providers,
      onStatusUpdate: (inquiryId, newStatus) {
        setState(() {
          _dataService.updateInquiryStatus(inquiryId, newStatus);
        });
      },
      onAssignProvider: (inquiryId, provider) {
        setState(() {
          _dataService.assignProvider(inquiryId, provider);
        });
      },
      onUpdateProvider: (inquiryId, newProvider, reason) {
        setState(() {
          _dataService.updateProvider(inquiryId, newProvider, reason);
        });
      },
    );
  }
}