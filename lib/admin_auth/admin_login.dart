import 'package:easyfix_admin/admin_auth/admin_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  bool _isChecked = true;
  bool _autoValidate = false;

  final Color redAccent = Colors.redAccent;
  final String fontFamily = 'Inter';

  bool get _isPhoneValid {
    return RegExp(r'^[0-9]{10}$').hasMatch(_phoneController.text.trim());
  }

  void _login() {
    setState(() => _autoValidate = true);
    if (_formKey.currentState!.validate() && _isChecked) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdminOtp(phone: "+91-${_phoneController.text.trim()}"),
        ),
      );
    }
  }

  Widget _buildLogo() {
    return Hero(
      tag: 'admin_logo',
      child: Image.asset(
        'images/easyfix.webp',
        height: 120,
        fit: BoxFit.contain,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              autovalidateMode: _autoValidate
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  _buildLogo(),
                  const SizedBox(height: 16),

                  // Admin Heading
                  Text(
                    "Admin Panel Login",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      fontFamily: fontFamily,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Label
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Admin Phone Number",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.grey.shade800,
                        fontFamily: fontFamily,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Phone + Country Code
                  Row(
                    children: [
                      // Country Code
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade100,
                        ),
                        child: Text(
                          '+91',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: fontFamily,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Phone Input Field
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontFamily: fontFamily, fontSize: 14),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            hintText: 'Enter admin phone number',
                            hintStyle: TextStyle(fontSize: 14, fontFamily: fontFamily),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey.shade400),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: redAccent, width: 2),
                            ),
                            suffixIcon: _phoneController.text.isEmpty
                                ? null
                                : (_isPhoneValid
                                ? Icon(Icons.check_circle, color: Colors.green, size: 20)
                                : Icon(Icons.error, color: Colors.redAccent, size: 20)),
                          ),
                          validator: (value) {
                            final v = value?.trim() ?? '';
                            if (v.isEmpty) return 'Enter admin number';
                            if (!_isPhoneValid) return 'Enter valid 10 digit number';
                            return null;
                          },
                          onChanged: (s) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Checkbox
                  Row(
                    children: [
                      Checkbox(
                        activeColor: redAccent,
                        value: _isChecked,
                        onChanged: (v) => setState(() => _isChecked = v ?? false),
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: 'I agree to the ',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 13,
                              fontFamily: fontFamily,
                            ),
                            children: [
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  color: redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: fontFamily,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: (_isPhoneValid && _isChecked) ? _login : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 1,
                      ),
                      child: Text(
                        "Send OTP",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: fontFamily,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "EasyFix Admin Portal © 2025",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade500,
                      fontSize: 12,
                      fontFamily: fontFamily,
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
