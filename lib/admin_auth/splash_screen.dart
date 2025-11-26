import 'dart:async';

import 'package:easyfix_admin/admin_auth/admin_login.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AdminLogin()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Consistent logo sizing
            Image.asset(
              "images/easyfix.webp",
              height: 120, // Consistent height
              width: 200, // Consistent width
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            // Optional: Add loading indicator
            // const CircularProgressIndicator(
            //   valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
            // ),
          ],
        ),
      ),
    );
  }
}
