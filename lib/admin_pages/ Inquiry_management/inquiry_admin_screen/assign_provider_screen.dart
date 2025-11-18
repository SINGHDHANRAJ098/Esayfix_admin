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
    _selectedDate = DateTime.now().add(const Duration(days: 1));
    _selectedTime = const TimeOfDay(hour: 10, minute: 0);
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate!,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: _selectedTime!,
      );

      if (time != null) {
        setState(() {
          _selectedDate = date;
          _selectedTime = time;
        });
      }
    }
  }

  void _confirm() {
    if (_selectedProvider == null) {
      _error("Please select a service provider");
      return;
    }

    widget.onAssign(_selectedProvider!);
    Navigator.pop(context);
    _success("Assigned to ${_selectedProvider!.name}");
  }

  void _success(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
      ),
    );
  }

  void _error(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final providers = widget.providers.where((e) => e.available).toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      // Light Admin AppBar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Assign Provider",
          style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18, color: Colors.black),
        ),
      ),

      body: Column(
        children: [
          _summaryCard(),
          const SizedBox(height: 12),
          Expanded(child: _providerList(providers)),
          _bottomPanel(),
        ],
      ),
    );
  }


  Widget _summaryCard() {
    return Card(
      elevation: 3,
      shadowColor: Colors.black.withOpacity(.08),
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.redAccent.withOpacity(.15),
              child: const Icon(Icons.build, size: 26, color: Colors.redAccent),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.inquiry.service,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text("Customer: ${widget.inquiry.customer}",
                      style: TextStyle(color: Colors.grey.shade200)),
                  Text("Location: ${widget.inquiry.location}",
                      style: TextStyle(color: Colors.grey.shade200)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------
  // AVAILABLE PROVIDERS LIST
  // -------------------------------
  Widget _providerList(List<ProviderModel> providers) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Available Providers",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Select a provider to assign",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          const SizedBox(height: 16),

          // Provider List
          Expanded(
            child: ListView.builder(
              itemCount: providers.length,
              itemBuilder: (_, i) => _providerCard(providers[i]),
            ),
          )
        ],
      ),
    );
  }

  Widget _providerCard(ProviderModel p) {
    final selected = _selectedProvider?.id == p.id;

    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(.05),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: selected ? Colors.blue : Colors.transparent,
          width: selected ? 2 : 0,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),

        leading: CircleAvatar(
          radius: 24,
          backgroundColor: Colors.blue.shade100,
          child: Text(
            p.name[0],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
        ),

        title: Text(
          p.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: selected ? Colors.blue.shade700 : Colors.black,
          ),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(p.specialty),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.orange, size: 16),
                const SizedBox(width: 3),
                Text(p.rating.toStringAsFixed(1)),
                const SizedBox(width: 10),
                const Icon(Icons.phone, size: 15, color: Colors.grey),
                const SizedBox(width: 4),
                Text(p.phone),
              ],
            ),
          ],
        ),

        trailing: selected
            ? const CircleAvatar(
          radius: 13,
          backgroundColor: Colors.green,
          child: Icon(Icons.check, size: 16, color: Colors.white),
        )
            : const CircleAvatar(
          radius: 13,
          backgroundColor: Colors.transparent,
          child: Icon(Icons.circle, size: 14, color: Colors.grey),
        ),

        onTap: () => setState(() => _selectedProvider = p),
      ),
    );
  }

  // -------------------------------
  // BOTTOM PANEL
  // -------------------------------
  Widget _bottomPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Date & Time Selector
          GestureDetector(
            onTap: _pickDateTime,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.redAccent),
                  const SizedBox(width: 12),
                  Text(
                    "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}  •  ${_selectedTime!.format(context)}",
                    style: const TextStyle(fontSize: 15),
                  ),
                  const Spacer(),
                  const Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Confirm Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _selectedProvider != null ? _confirm : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                disabledBackgroundColor: Colors.grey.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Confirm Assignment",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
