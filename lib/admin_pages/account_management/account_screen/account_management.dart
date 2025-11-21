// lib/admin_pages/account_management/account_screen/account_management_screen.dart

import 'package:flutter/material.dart';

import '../account_model/account_model.dart';
import '../account_service/account_service.dart';
import '../account_widget/account_widget.dart';

/// Main Account Management screen – groups:
/// 1) Admin Profile
/// 2) Policies & Legal
/// 3) Support & Contact
class AccountManagementScreen extends StatelessWidget {
  const AccountManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Account Management',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            AdminProfileSection(),
            SizedBox(height: 24),
            PoliciesLegalSection(),
            SizedBox(height: 24),
            SupportContactSection(),
          ],
        ),
      ),
    );
  }
}

//
// -------------------- ADMIN PROFILE SECTION --------------------
//

class AdminProfileSection extends StatefulWidget {
  const AdminProfileSection({super.key});

  @override
  State<AdminProfileSection> createState() => _AdminProfileSectionState();
}

class _AdminProfileSectionState extends State<AdminProfileSection> {
  final AccountService _accountService = AccountService();
  late Future<AdminProfile> _adminProfileFuture;

  @override
  void initState() {
    super.initState();
    _loadAdminProfile();
  }

  void _loadAdminProfile() {
    setState(() {
      _adminProfileFuture = _accountService.getAdminProfile();
    });
  }

  void _navigateToEditProfile(AdminProfile profile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          profile: profile,
          onProfileUpdated: _loadAdminProfile,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AdminProfile>(
      future: _adminProfileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SectionCard(
            title: 'Admin Profile',
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return SectionCard(
            title: 'Admin Profile',
            child: Column(
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 40),
                const SizedBox(height: 8),
                Text(
                  'Failed to load profile',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _loadAdminProfile,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final adminProfile = snapshot.data!;

        return SectionCard(
          title: 'Admin Profile',
          child: Column(
            children: [
              ProfileInfoRow(label: 'Name', value: adminProfile.name),
              const SizedBox(height: 16),
              ProfileInfoRow(label: 'Email', value: adminProfile.email),
              const SizedBox(height: 16),
              ProfileInfoRow(label: 'Phone', value: adminProfile.phone),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _navigateToEditProfile(adminProfile),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

//
// -------------------- POLICIES & LEGAL --------------------
//

class PoliciesLegalSection extends StatelessWidget {
  const PoliciesLegalSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Policies & Legal',
      child: Column(
        children: [
          PolicyItem(
            title: 'Terms & Conditions',
            icon: Icons.description_rounded,
            onTap: () => _navigateToPolicy(context, 'terms_conditions'),
          ),
          const SizedBox(height: 12),
          PolicyItem(
            title: 'Privacy Policy',
            icon: Icons.privacy_tip_rounded,
            onTap: () => _navigateToPolicy(context, 'privacy_policy'),
          ),
          const SizedBox(height: 12),
          PolicyItem(
            title: 'Refund/Cancellation Policy',
            icon: Icons.money_off_rounded,
            onTap: () => _navigateToPolicy(context, 'refund_policy'),
          ),
        ],
      ),
    );
  }

  void _navigateToPolicy(BuildContext context, String policyId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PolicyDetailScreen(policyId: policyId),
      ),
    );
  }
}

//
// -------------------- SUPPORT & CONTACT (ICON-BASED, SIMPLE) --------------------
//

class SupportContactSection extends StatelessWidget {
  const SupportContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SupportContact>(
      future: AccountService().getSupportContact(),
      builder: (context, snapshot) {
        final data = snapshot.data;

        return SectionCard(
          title: 'Support & Contact',
          child: data == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    // Support Contact (phone) with edit icon
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: _iconBox(Icons.phone),
                      title: const Text(
                        'Support Contact',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        data.phone,
                        style: TextStyle(color: Colors.grey[700], fontSize: 13),
                      ),
                      trailing: _editIcon(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                EditSupportDetailsScreen(contact: data),
                          ),
                        );
                      }),
                    ),

                    const Divider(height: 20),

                    // Support Email with edit icon
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: _iconBox(Icons.email),
                      title: const Text(
                        'Email Support',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        data.email,
                        style: TextStyle(color: Colors.grey[700], fontSize: 13),
                      ),
                      trailing: _editIcon(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                EditSupportDetailsScreen(contact: data),
                          ),
                        );
                      }),
                    ),

                    const Divider(height: 20),

                    // View Support Tickets (simple row)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: _iconBox(Icons.receipt_long),
                      title: const Text(
                        'View Support Tickets',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SupportTicketListScreen(),
                          ),
                        );
                      },
                    ),

                    const Divider(height: 20),

                    // Raise Support Ticket (simple row)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: _iconBox(Icons.add_circle_outline),
                      title: const Text(
                        'Raise Support Ticket',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                      onTap: () => _showTicketDialog(context),
                    ),
                  ],
                ),
        );
      },
    );
  }

  // Rounded icon background (red accent tint)
  Widget _iconBox(IconData icon) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: Colors.redAccent),
    );
  }

  // Edit icon used for contact + email
  Widget _editIcon(VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade200,
        ),
        child: const Icon(Icons.edit, size: 18, color: Colors.redAccent),
      ),
    );
  }

  void _showTicketDialog(BuildContext context) {
    showDialog(context: context, builder: (_) => const SupportTicketDialog());
  }
}

//
// -------------------- EDIT PROFILE SCREEN --------------------
//

class EditProfileScreen extends StatefulWidget {
  final AdminProfile profile;
  final VoidCallback onProfileUpdated;

  const EditProfileScreen({
    super.key,
    required this.profile,
    required this.onProfileUpdated,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _accountService = AccountService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.profile.name;
    _emailController.text = widget.profile.email;
    _phoneController.text = widget.profile.phone;
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updatedProfile = widget.profile.copyWith(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
      );

      await _accountService.updateAdminProfile(updatedProfile);

      if (mounted) {
        widget.onProfileUpdated();
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildInput(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'Required' : null,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          children: [
                            _buildInput('Name', _nameController),
                            const SizedBox(height: 18),
                            _buildInput(
                              'Email',
                              _emailController,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 18),
                            _buildInput(
                              'Phone',
                              _phoneController,
                              keyboardType: TextInputType.phone,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Save Changes',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}

//
// -------------------- POLICY DETAIL + EDIT POLICY --------------------
//

class PolicyDetailScreen extends StatefulWidget {
  final String policyId;

  const PolicyDetailScreen({super.key, required this.policyId});

  @override
  State<PolicyDetailScreen> createState() => _PolicyDetailScreenState();
}

class _PolicyDetailScreenState extends State<PolicyDetailScreen> {
  final _accountService = AccountService();
  late Future<Policy> _policyFuture;

  @override
  void initState() {
    super.initState();
    _policyFuture = _accountService.getPolicy(widget.policyId);
  }

  void _refreshPolicy() {
    setState(() {
      _policyFuture = _accountService.getPolicy(widget.policyId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Policy>(
          future: _policyFuture,
          builder: (context, snapshot) {
            return Text(snapshot.data?.title ?? 'Policy');
          },
        ),
        actions: [
          FutureBuilder<Policy>(
            future: _policyFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox.shrink();
              final policy = snapshot.data!;
              return IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditPolicyScreen(
                        policy: policy,
                        onUpdated: _refreshPolicy,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Policy>(
        future: _policyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 40),
                  const SizedBox(height: 8),
                  const Text('Failed to load policy'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _refreshPolicy,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final policy = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  policy.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Version: ${policy.version} • Last Updated: ${_formatDate(policy.lastUpdated)}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                Text(
                  policy.description,
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  policy.content,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class EditPolicyScreen extends StatefulWidget {
  final Policy policy;
  final VoidCallback onUpdated;

  const EditPolicyScreen({
    super.key,
    required this.policy,
    required this.onUpdated,
  });

  @override
  State<EditPolicyScreen> createState() => _EditPolicyScreenState();
}

class _EditPolicyScreenState extends State<EditPolicyScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _contentController;
  bool _loading = false;
  final _accountService = AccountService();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.policy.title);
    _descriptionController = TextEditingController(
      text: widget.policy.description,
    );
    _contentController = TextEditingController(text: widget.policy.content);
  }

  String _increaseVersion(String version) {
    final parts = version.split('.');
    if (parts.length != 3) return version;
    final major = int.tryParse(parts[0]) ?? 1;
    final minor = int.tryParse(parts[1]) ?? 0;
    final patch = (int.tryParse(parts[2]) ?? 0) + 1;
    return '$major.$minor.$patch';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final updated = widget.policy.copyWith(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      content: _contentController.text.trim(),
      lastUpdated: DateTime.now(),
      version: _increaseVersion(widget.policy.version),
    );

    await _accountService.updatePolicy(updated);
    widget.onUpdated();

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Policy updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Policy')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Please enter title' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Short Description',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Please enter description' : null,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: TextFormField(
                  controller: _contentController,
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Please enter content' : null,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  child: _loading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : const Text(
                          'Save Changes',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
// -------------------- SUPPORT TICKET DIALOG --------------------
//

class SupportTicketDialog extends StatefulWidget {
  const SupportTicketDialog({super.key});

  @override
  State<SupportTicketDialog> createState() => _SupportTicketDialogState();
}

class _SupportTicketDialogState extends State<SupportTicketDialog> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _accountService = AccountService();
  String _priority = 'Medium';
  bool _isLoading = false;

  Future<void> _submitTicket() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final ticket = SupportTicket(
        id: '',
        subject: _subjectController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _priority,
        status: 'Open',
        createdAt: DateTime.now(),
      );

      final ticketId = await _accountService.createSupportTicket(ticket);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Support ticket created: $ticketId'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Support Ticket'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter subject'
                  : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _priority,
              decoration: const InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
              ),
              items: ['Low', 'Medium', 'High', 'Urgent']
                  .map(
                    (priority) => DropdownMenuItem(
                      value: priority,
                      child: Text(priority),
                    ),
                  )
                  .toList(),
              onChanged: _isLoading
                  ? null
                  : (value) {
                      setState(() {
                        _priority = value!;
                      });
                    },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter description'
                  : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submitTicket,
          child: _isLoading
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              : const Text('Submit'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

//
// -------------------- EDIT SUPPORT DETAILS --------------------
//

class EditSupportDetailsScreen extends StatefulWidget {
  final SupportContact contact;

  const EditSupportDetailsScreen({super.key, required this.contact});

  @override
  State<EditSupportDetailsScreen> createState() =>
      _EditSupportDetailsScreenState();
}

class _EditSupportDetailsScreenState extends State<EditSupportDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  bool _loading = false;

  final _accountService = AccountService();

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.contact.phone);
    _emailController = TextEditingController(text: widget.contact.email);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final updated = widget.contact.copyWith(
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
    );

    await _accountService.updateSupportContact(updated);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Support details updated'),
          backgroundColor: Colors.green,
        ),
      );
    }

    setState(() => _loading = false);
  }

  Widget _input(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
            ),
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Edit Support Details',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _input(
                'Support Contact Number',
                _phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _input(
                'Support Email',
                _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _loading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : const Text(
                          'Save Changes',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
// -------------------- SUPPORT TICKET LIST + DETAIL --------------------
//

class SupportTicketListScreen extends StatelessWidget {
  const SupportTicketListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = AccountService();

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Support Tickets')),
      body: FutureBuilder<List<SupportTicket>>(
        future: service.getAllTickets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final tickets = snapshot.data ?? [];

          if (tickets.isEmpty) {
            return const Center(child: Text('No tickets found'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: tickets.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final t = tickets[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    t.subject,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    'Priority: ${t.priority} • Status: ${t.status}',
                    style: const TextStyle(fontSize: 13),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SupportTicketDetailScreen(ticket: t),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SupportTicketDetailScreen extends StatelessWidget {
  final SupportTicket ticket;

  const SupportTicketDetailScreen({super.key, required this.ticket});

  String _formatDate(DateTime d) =>
      '${d.day}/${d.month}/${d.year} ${d.hour}:${d.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Ticket Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ticket.subject,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Priority: ${ticket.priority}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Status: ${ticket.status}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Created: ${_formatDate(ticket.createdAt)}',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            const Text(
              'Description',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              ticket.description,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
