// provider_management/provider_screen/provider_list_screen.dart

import 'package:flutter/material.dart';
import '../provider_model/provider_model.dart';

class ProviderListScreen extends StatefulWidget {
  const ProviderListScreen({super.key});

  @override
  State<ProviderListScreen> createState() => _ProviderListScreenState();
}

class _ProviderListScreenState extends State<ProviderListScreen> {
  List<ProviderModel> _allProviders = [];
  List<ProviderModel> _filteredProviders = [];
  String _searchQuery = '';
  ProviderStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _loadProviders();
  }

  void _loadProviders() {
    _allProviders = [
      ProviderModel(
        id: '1',
        name: 'Amit Kumar',
        phone: '+91 9876543210',
        specialty: 'AC Repair',
        status: ProviderStatus.active,
        totalServicesAssigned: 45,
        totalServicesCompleted: 42,
      ),
      ProviderModel(
        id: '2',
        name: 'Rajesh Sharma',
        phone: '+91 9876543211',
        specialty: 'Electrical Wire service ',
        status: ProviderStatus.active,
        totalServicesAssigned: 32,
        totalServicesCompleted: 30,
      ),
      ProviderModel(
        id: '3',
        name: 'Priya Singh',
        phone: '+91 9876543212',
        specialty: 'Home Electrical service',
        status: ProviderStatus.inactive,
        totalServicesAssigned: 28,
        totalServicesCompleted: 25,
      ),
    ];

    _filteredProviders = _allProviders;
  }

  void _searchProviders(String query) {
    setState(() {
      _searchQuery = query;
      _applyFilters();
    });
  }

  void _applyFilters() {
    setState(() {
      _filteredProviders = _allProviders.where((p) {
        final matchesSearch = _searchQuery.isEmpty ||
            p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            p.phone.contains(_searchQuery) ||
            p.specialty.toLowerCase().contains(_searchQuery.toLowerCase());

        final matchesStatus =
            _selectedStatus == null || p.status == _selectedStatus;

        return matchesSearch && matchesStatus;
      }).toList();
    });
  }

  void _updateStatusFilter(ProviderStatus? status) {
    setState(() {
      _selectedStatus = status;
      _applyFilters();
    });
  }


  // UI


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Provider Management",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              onChanged: _searchProviders,
              decoration: InputDecoration(
                hintText: "Search by name, phone, service...",
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.redAccent),
                ),
              ),
            ),
          ),

          // Tabs
          _segmentedTabs(),

          // Provider List
          Expanded(
            child: _filteredProviders.isEmpty
                ? const Center(
              child: Text("No providers found",
                  style: TextStyle(color: Colors.grey, fontSize: 16)),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredProviders.length,
              itemBuilder: (context, index) =>
                  _providerCard(_filteredProviders[index]),
            ),
          ),
        ],
      ),
    );
  }


  //  TABS EXACT like your reference UI


  Widget _segmentedTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(child: _tabButton("All", null)),
          const SizedBox(width: 10),
          Expanded(child: _tabButton("Active", ProviderStatus.active)),
          const SizedBox(width: 10),
          Expanded(child: _tabButton("Inactive", ProviderStatus.inactive)),
        ],
      ),
    );
  }

  Widget _tabButton(String label, ProviderStatus? status) {
    final bool isSelected = _selectedStatus == status;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _updateStatusFilter(status),
      child: Container(
        height: 42, // Bigger box height
        decoration: BoxDecoration(
          color: isSelected ? Colors.redAccent : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Colors.redAccent : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // perfect center text
            children: [
              if (isSelected) ...[
                const Icon(Icons.check, size: 16, color: Colors.white),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  // Provider Card


  Widget _providerCard(ProviderModel p) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                p.name,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: p.status == ProviderStatus.active
                      ? Colors.green.shade100
                      : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  p.status.label,
                  style: TextStyle(
                    fontSize: 12,
                    color: p.status == ProviderStatus.active
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _row(Icons.phone, p.phone),
          _row(Icons.work, "Service: ${p.specialty}"),
          _row(Icons.assignment, "Assigned: ${p.totalServicesAssigned}"),
          _row(Icons.check_circle, "Completed: ${p.totalServicesCompleted}"),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
