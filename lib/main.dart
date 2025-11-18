import 'package:easyfix_admin/admin_auth/admin_otp.dart';
import 'package:easyfix_admin/admin_pages/admin_bottom_nav.dart';

import 'package:easyfix_admin/try.dart';
import 'package:flutter/material.dart';
import 'admin_auth/splash_screen.dart';
import 'admin_pages/ Inquiry_management/inquiry_admin_screen/inquiry_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: AdminBottomNav()
    );
  }
}
