import 'package:flutter/material.dart';
import '../account_model/account_model.dart';
import '../account_service/account_service.dart';
import '../account_widget/account_widget.dart';

class ReportsAnalyticsSection extends StatelessWidget {
  const ReportsAnalyticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Reports & Analytics',
      child: Column(
        children: [
          _buildReportItem(
            icon: Icons.assessment_outlined,
            title: 'Daily/Monthly Inquiry Report',
            subtitle: 'Track inquiry statistics and performance',
            onTap: () => _navigateToInquiryReport(context),
          ),
          const SizedBox(height: 12),
          _buildReportItem(
            icon: Icons.bar_chart_outlined,
            title: 'Revenue Report',
            subtitle: 'View financial performance and earnings',
            onTap: () => _navigateToRevenueReport(context),
          ),
          const SizedBox(height: 12),
          _buildReportItem(
            icon: Icons.trending_up_outlined,
            title: 'Service Analytics',
            subtitle: 'Analyze service distribution and trends',
            onTap: () => _navigateToServiceAnalytics(context),
          ),
        ],
      ),
    );
  }

  Widget _buildReportItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.redAccent, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.redAccent),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToInquiryReport(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InquiryReportScreen()),
    );
  }

  void _navigateToRevenueReport(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RevenueReportScreen()),
    );
  }

  void _navigateToServiceAnalytics(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ServiceAnalyticsScreen()),
    );
  }
}

class InquiryReportScreen extends StatefulWidget {
  const InquiryReportScreen({super.key});

  @override
  State<InquiryReportScreen> createState() => _InquiryReportScreenState();
}

class _InquiryReportScreenState extends State<InquiryReportScreen> {
  final _accountService = AccountService();
  late Future<ReportData> _dailyReportFuture;
  late Future<ReportData> _monthlyReportFuture;
  String _selectedPeriod = 'daily';

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  void _loadReports() {
    setState(() {
      _dailyReportFuture = _accountService.getDailyReport();
      _monthlyReportFuture = _accountService.getMonthlyReport();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Inquiry Reports',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Period Selector
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  _buildPeriodButton('Daily', 'daily'),
                  const SizedBox(width: 8),
                  _buildPeriodButton('Monthly', 'monthly'),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<ReportData>(
                future: _selectedPeriod == 'daily' ? _dailyReportFuture : _monthlyReportFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, color: Colors.redAccent, size: 40),
                          const SizedBox(height: 8),
                          const Text('Failed to load report'),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _loadReports,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Try Again'),
                          ),
                        ],
                      ),
                    );
                  }

                  final report = snapshot.data!;
                  return _buildReportContent(report);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodButton(String text, String period) {
    final isSelected = _selectedPeriod == period;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => _selectedPeriod = period),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.redAccent : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReportContent(ReportData report) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Summary Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Inquiries',
                  report.totalInquiries.toString(),
                  Icons.request_page_outlined,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Completed',
                  report.completedInquiries.toString(),
                  Icons.check_circle_outline,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Pending',
                  report.pendingInquiries.toString(),
                  Icons.pending_actions_outlined,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Avg Rating',
                  report.averageRating.toStringAsFixed(1),
                  Icons.star_outline,
                  Colors.amber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Service Distribution
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Service Distribution',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                ...report.serviceDistribution.entries.map((entry) =>
                    _buildServiceRow(entry.key, entry.value)
                ).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const Spacer(),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceRow(String service, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              service,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.redAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RevenueReportScreen extends StatefulWidget {
  const RevenueReportScreen({super.key});

  @override
  State<RevenueReportScreen> createState() => _RevenueReportScreenState();
}

class _RevenueReportScreenState extends State<RevenueReportScreen> {
  final _accountService = AccountService();
  late Future<List<ReportData>> _revenueReportFuture;

  @override
  void initState() {
    super.initState();
    _loadRevenueReport();
  }

  void _loadRevenueReport() {
    setState(() {
      _revenueReportFuture = _accountService.getRevenueReport();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Revenue Report',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<ReportData>>(
          future: _revenueReportFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.redAccent, size: 40),
                    const SizedBox(height: 8),
                    const Text('Failed to load revenue report'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _loadRevenueReport,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            }

            final reports = snapshot.data!;
            return _buildRevenueContent(reports);
          },
        ),
      ),
    );
  }

  Widget _buildRevenueContent(List<ReportData> reports) {
    final totalRevenue = reports.fold(0.0, (sum, report) => sum + report.totalRevenue);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Total Revenue Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Text(
                  'Total Revenue',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '₹${totalRevenue.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Across ${reports.length} months',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Monthly Breakdown
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Monthly Breakdown',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ...reports.map((report) => _buildRevenueRow(report)).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueRow(ReportData report) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report.period,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${report.completedInquiries} inquiries • Rating: ${report.averageRating}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            '₹${report.totalRevenue.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceAnalyticsScreen extends StatelessWidget {
  const ServiceAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Service Analytics',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: const SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.analytics_outlined, size: 64, color: Colors.redAccent),
                SizedBox(height: 16),
                Text(
                  'Service Analytics',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Text(
                  'Detailed service performance analytics and trends will be displayed here',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}