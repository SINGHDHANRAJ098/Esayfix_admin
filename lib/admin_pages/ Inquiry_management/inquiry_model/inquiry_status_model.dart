// models/inquiry_status_model.dart
import 'package:flutter/material.dart';

enum InquiryStatus {
  pending,
  assigned,
  inProgress,
  completed,
  cancelled,
}

extension InquiryStatusX on InquiryStatus {
  String get label {
    switch (this) {
      case InquiryStatus.pending:
        return "Pending";
      case InquiryStatus.assigned:
        return "Assigned";
      case InquiryStatus.inProgress:
        return "In Progress";
      case InquiryStatus.completed:
        return "Completed";
      case InquiryStatus.cancelled:
        return "Cancelled";
    }
  }

  Color get color {
    switch (this) {
      case InquiryStatus.pending:
        return Colors.orange;
      case InquiryStatus.assigned:
        return Colors.blue;
      case InquiryStatus.inProgress:
        return Colors.purple;
      case InquiryStatus.completed:
        return Colors.green;
      case InquiryStatus.cancelled:
        return Colors.red;
    }
  }

  IconData get icon {
    switch (this) {
      case InquiryStatus.pending:
        return Icons.pending;
      case InquiryStatus.assigned:
        return Icons.assignment_ind;
      case InquiryStatus.inProgress:
        return Icons.build;
      case InquiryStatus.completed:
        return Icons.check_circle;
      case InquiryStatus.cancelled:
        return Icons.cancel;
    }
  }
}