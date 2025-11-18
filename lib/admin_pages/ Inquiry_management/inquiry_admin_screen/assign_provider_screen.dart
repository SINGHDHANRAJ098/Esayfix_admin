
import 'package:flutter/material.dart';
import '../inquiry_model/inquiry.model.dart';
import '../inquiry_model/inquiry_provider_model.dart';


class AssignInquiryScreen extends StatefulWidget {
  final Inquiry inquiry;
  final List<ProviderModel> providers;
  final Function(ProviderModel) onAssign;

  const AssignInquiryScreen({
    super.key,
    required this.inquiry,
    required this.providers,
    required this.onAssign,
  });

  @override
  State<AssignInquiryScreen> createState() => _AssignInquiryScreenState();
}

class _AssignInquiryScreenState extends State<AssignInquiryScreen> {
  ProviderModel? _selectedProvider;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().add(Duration(days: 1));
    _selectedTime = TimeOfDay(hour: 10, minute: 0);
  }

  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: _selectedTime ?? TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = pickedDate;
          _selectedTime = pickedTime;
        });
      }
    }
  }

  void _confirmAssignment() {
    if (_selectedProvider != null) {
      widget.onAssign(_selectedProvider!);
      _showSuccessSnackbar('Successfully assigned to ${_selectedProvider!.name}');
      Navigator.pop(context);
    } else {
      _showErrorSnackbar('Please select a service provider');
    }
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

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableProviders = widget.providers.where((p) => p.available).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Assign Provider",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.redAccent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Inquiry Summary
          _buildInquirySummary(),
          SizedBox(height: 16),
          // Provider Selection
          Expanded(
            child: _buildProviderSelection(availableProviders),
          ),
          // Deadline & Confirm
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildInquirySummary() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Booking Summary",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.build, color: Colors.redAccent),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.inquiry.service,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Customer: ${widget.inquiry.customer}",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Text(
                      "Location: ${widget.inquiry.location}",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProviderSelection(List<ProviderModel> availableProviders) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Available Providers",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Select a service provider to assign this inquiry",
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: availableProviders.length,
              itemBuilder: (context, index) {
                final provider = availableProviders[index];
                return _buildProviderCard(provider);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProviderCard(ProviderModel provider) {
    final isSelected = _selectedProvider?.id == provider.id;

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.transparent,
          width: isSelected ? 2 : 0,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.blue[100],
          child: Text(
            provider.name[0],
            style: TextStyle(
              color: Colors.blue[800],
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        title: Text(
          provider.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.blue[800] : Colors.grey[800],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(provider.specialty),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.star, size: 16, color: Colors.orange),
                SizedBox(width: 4),
                Text(provider.rating.toStringAsFixed(1)),
                SizedBox(width: 12),
                Icon(Icons.phone, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(provider.phone),
              ],
            ),
          ],
        ),
        trailing: isSelected
            ? Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check, size: 16, color: Colors.white),
        )
            : Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            shape: BoxShape.circle,
          ),
        ),
        onTap: () {
          setState(() {
            _selectedProvider = provider;
          });
        },
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Column(
        children: [
          // Deadline Selection
          Card(
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.event, color: Colors.redAccent),
                      SizedBox(width: 8),
                      Text(
                        "Expected Completion",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  InkWell(
                    onTap: _selectDateTime,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.redAccent),
                          SizedBox(width: 12),
                          Text(
                            _selectedDate != null && _selectedTime != null
                                ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year} ${_selectedTime!.format(context)}'
                                : 'Select date and time',
                            style: TextStyle(fontSize: 16),
                          ),
                          Spacer(),
                          Icon(Icons.arrow_drop_down, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          // Confirm Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _selectedProvider != null ? _confirmAssignment : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Text(
                "Confirm Assignment",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}