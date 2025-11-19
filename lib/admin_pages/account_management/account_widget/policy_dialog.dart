import 'package:flutter/material.dart';

class PolicyDialog extends StatelessWidget {
  final String title;
  final String content;

  const PolicyDialog({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(
          color: Color(0xFFD32F2F),
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Text(content),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'CLOSE',
            style: TextStyle(color: Color(0xFFD32F2F)),
          ),
        ),
      ],
    );
  }
}