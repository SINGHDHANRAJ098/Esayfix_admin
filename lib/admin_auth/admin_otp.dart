import 'package:easyfix_admin/admin_pages/admin_bottom_navigation/admin_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminOtp extends StatefulWidget {
  final String phone;

  const AdminOtp({super.key, required this.phone});

  @override
  State<AdminOtp> createState() => _AdminOtpState();
}

class _AdminOtpState extends State<AdminOtp> {
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final Color redAccent = Colors.redAccent;
  final Color backgroundColor = Colors.white;
  final Color lightGrey = Colors.grey.shade100;
  final String fontFamily = 'Inter';

  //logo widget
  Widget _buildLogo() {
    return Hero(
      tag: 'admin_logo',
      child: Image.asset(
        'images/easyfix.webp',
        height: 120,
        width: 200,
        fit: BoxFit.contain,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    for (var node in _focusNodes) {
      node.addListener(() {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _verifyOtp() {
    final otp = _controllers.map((e) => e.text).join();
    if (otp.length == 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Admin OTP Verified: $otp")));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminBottomNav()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter all 6 digits")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back Button
              Align(
                alignment: Alignment.centerLeft,
                child: CircleAvatar(
                  backgroundColor: Colors.grey.shade100,
                  radius: 20,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 16,
                      color: Colors.black,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // App Logo -
              Center(child: _buildLogo()),
              const SizedBox(height: 28),

              // Heading
              Text(
                "Admin OTP Verification",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: fontFamily,
                ),
              ),
              const SizedBox(height: 12), // Increased spacing
              Text(
                "Enter the 6-digit code sent to your number",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14, // Slightly larger for better readability
                  color: Colors.grey.shade600,
                  fontFamily: fontFamily,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.phone,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: fontFamily,
                ),
              ),
              const SizedBox(height: 32),

              // OTP Input Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  bool isFocused = _focusNodes[index].hasFocus;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: size.width * 0.12,
                    height: size.width * 0.13,
                    decoration: BoxDecoration(
                      color: isFocused ? Colors.white : lightGrey,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isFocused ? redAccent : Colors.grey.shade300,
                        width: isFocused ? 2 : 1,
                      ),
                      boxShadow: isFocused
                          ? [
                              BoxShadow(
                                color: redAccent.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : [],
                    ),
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(1),
                      ],
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          FocusScope.of(
                            context,
                          ).requestFocus(_focusNodes[index + 1]);
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(
                            context,
                          ).requestFocus(_focusNodes[index - 1]);
                        }
                      },
                    ),
                  );
                }),
              ),

              const SizedBox(height: 36),

              // Verify Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  child: Text(
                    "Verify OTP",
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Resend OTP Section
              Column(
                children: [
                  Text(
                    "Didn't receive the code?",
                    style: TextStyle(
                      fontFamily: fontFamily,
                      color: Colors.grey.shade600,
                      fontSize: 14, // Consistent font size
                    ),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("OTP sent again to ${widget.phone}"),
                        ),
                      );
                    },
                    child: Text(
                      "Resend OTP",
                      style: TextStyle(
                        fontFamily: fontFamily,
                        color: redAccent,
                        fontWeight: FontWeight.w600,
                        fontSize: 14, // Consistent font size
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
