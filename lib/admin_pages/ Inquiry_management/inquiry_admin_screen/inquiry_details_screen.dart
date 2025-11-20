import 'package:easyfix_admin/admin_pages/%20Inquiry_management/inquiry_admin_screen/invoice_screen.dart';
import 'package:flutter/material.dart';
import '../inquiry_model/inquiry.model.dart';
import '../inquiry_model/inquiry_provider_model.dart';
import '../inquiry_model/inquiry_status_model.dart';
import 'assign_provider_screen.dart';
import 'inquiry_track_screen.dart';

class InquiryDetailsScreen extends StatefulWidget {
  final Inquiry inquiry;
  final List<ProviderModel> providers;

  final Function(InquiryStatus) onStatusUpdate;
  final Function(ProviderModel) onAssignProvider;
  final Function(ProviderModel, String) onUpdateProvider;
  final Function(PaymentStatus, PaymentMethod?) onPaymentUpdate;
  final Function(String) onAddAdminNote;
  final Function(double) onUpdateInquiryPrice;

  const InquiryDetailsScreen({
    super.key,
    required this.inquiry,
    required this.providers,
    required this.onStatusUpdate,
    required this.onAssignProvider,
    required this.onUpdateProvider,
    required this.onPaymentUpdate,
    required this.onAddAdminNote,
    required this.onUpdateInquiryPrice,
  });

  @override
  State<InquiryDetailsScreen> createState() => _InquiryDetailsScreenState();
}

class _InquiryDetailsScreenState extends State<InquiryDetailsScreen> {
  late Inquiry inquiry;

  @override
  void initState() {
    super.initState();
    inquiry = widget.inquiry;
  }

  // ------------------ CALCULATIONS ------------------
  double get serviceTotal => inquiry.serviceTotal;
  double get additionalServiceTotal => inquiry.additionalServiceTotal;
  double get bookingAmount => inquiry.price ?? 0;
  double get additionalAmount => inquiry.additionalAmount;
  double get totalPayable => inquiry.payableAmount;

  // ------------------ PAYMENT STATUS AUTO ------------------
  PaymentStatus get autoPaymentStatus {
    double totalBeforeBooking = serviceTotal + additionalServiceTotal + additionalAmount;

    // If service is completed, check if fully paid
    if (inquiry.status == InquiryStatus.completed) {
      if (bookingAmount >= totalBeforeBooking) {
        return PaymentStatus.paid;
      } else {
        return PaymentStatus.partiallyPaid;
      }
    }

    // For ongoing services - use the same logic but update the model
    if (bookingAmount == 0) return PaymentStatus.unpaid;
    if (bookingAmount > 0 && bookingAmount < totalBeforeBooking) {
      return PaymentStatus.partiallyPaid;
    }
    if (bookingAmount >= totalBeforeBooking) {
      return PaymentStatus.paid;
    }
    return PaymentStatus.unpaid;
  }

  double get outstandingAmount {
    double totalBeforeBooking = serviceTotal + additionalServiceTotal + additionalAmount;
    return (totalBeforeBooking - bookingAmount).clamp(0, double.infinity);
  }

  // ------------------ NAVIGATION ------------------
  void _assignProvider() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AssignInquiryScreen(
          inquiry: inquiry,
          providers: widget.providers,
          onAssign: (p) {
            widget.onAssignProvider(p);
            setState(() {
              inquiry = inquiry.copyWith(provider: p);
            });
          },
        ),
      ),
    );
  }

  void _trackQuery() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InquiryTrackScreen(
          inquiry: inquiry,
          providers: widget.providers,
          onStatusUpdate: (newStatus) {
            widget.onStatusUpdate(newStatus);

            // Auto-update payment status when service is completed
            PaymentStatus? updatedPaymentStatus;
            if (newStatus == InquiryStatus.completed) {
              updatedPaymentStatus = _calculatePaymentStatusForCompletedService();
            }

            setState(() {
              inquiry = inquiry.copyWith(
                status: newStatus,
                paymentStatus: updatedPaymentStatus ?? inquiry.paymentStatus,
              );
            });

            // Call the callback if payment status was updated
            if (updatedPaymentStatus != null) {
              widget.onPaymentUpdate(updatedPaymentStatus, inquiry.paymentMethod);
            }
          },
          onUpdateProvider: widget.onUpdateProvider,
        ),
      ),
    );
  }

  PaymentStatus _calculatePaymentStatusForCompletedService() {
    double totalBeforeBooking = serviceTotal + additionalServiceTotal + additionalAmount;

    if (bookingAmount >= totalBeforeBooking) {
      return PaymentStatus.paid;
    } else if (bookingAmount > 0) {
      return PaymentStatus.partiallyPaid;
    } else {
      return PaymentStatus.unpaid;
    }
  }

  // Update payment status manually
  void _updatePaymentStatus(PaymentStatus newStatus) {
    widget.onPaymentUpdate(newStatus, inquiry.paymentMethod);
    setState(() {
      inquiry = inquiry.copyWith(paymentStatus: newStatus);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use the auto-calculated status for display, but store the actual model status
    final PaymentStatus displayPaymentStatus = autoPaymentStatus;

    return Scaffold(
      backgroundColor: const Color(0xfff7f7f7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Service Details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(14),
          children: [
            // ---------------- BOOKING ID ----------------
            Container(
              padding: const EdgeInsets.all(14),
              decoration: box(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Booking ID: ${inquiry.id}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: inquiry.status.color),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      inquiry.status.label,
                      style: TextStyle(
                        color: inquiry.status.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ---------------- SERVICES ----------------
            Container(
              padding: const EdgeInsets.all(14),
              decoration: box(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Services",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),

                  Row(
                    children: const [
                      Expanded(flex: 6, child: Text("Service")),
                      Expanded(flex: 2, child: Text("Qty")),
                      Expanded(flex: 3, child: Text("Price",
                          textAlign: TextAlign.right)),
                    ],
                  ),

                  const Divider(),

                  ...inquiry.items.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Expanded(flex: 6, child: Text(item.name)),
                        Expanded(flex: 2, child: Text("${item.qty}")),
                        Expanded(
                          flex: 3,
                          child: Text(
                            "₹${(item.qty * item.price).toStringAsFixed(2)}",
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ---------------- ADDITIONAL SERVICES ----------------
            if (inquiry.additionalServices.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: box(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Additional Services",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),

                    Row(
                      children: const [
                        Expanded(flex: 6, child: Text("Service")),
                        Expanded(flex: 2, child: Text("Qty")),
                        Expanded(flex: 3, child: Text("Price",
                            textAlign: TextAlign.right)),
                      ],
                    ),

                    const Divider(),

                    ...inquiry.additionalServices.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Expanded(flex: 6, child: Text(item.name)),
                          Expanded(flex: 2, child: Text("${item.qty}")),
                          Expanded(
                            flex: 3,
                            child: Text(
                              "₹${item.total.toStringAsFixed(2)}",
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),

            if (inquiry.additionalServices.isNotEmpty) const SizedBox(height: 12),

            // ---------------- CUSTOMER NOTE (RESTORED) ----------------
            if ((inquiry.userNotes ?? "").isNotEmpty)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: box(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Customer Note",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        )),
                    const SizedBox(height: 8),
                    Text(
                      inquiry.userNotes!,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 12),

            // ---------------- TOTALS ----------------
            Container(
              padding: const EdgeInsets.all(14),
              decoration: box(),
              child: Column(
                children: [
                  row("Services Total", "₹${serviceTotal.toStringAsFixed(2)}"),
                  if (inquiry.additionalServices.isNotEmpty)
                    row("Additional Services", "₹${additionalServiceTotal.toStringAsFixed(2)}"),
                  row("Additional Charges", "₹${additionalAmount.toStringAsFixed(2)}"),
                  row("Booking Amount",
                      "₹${bookingAmount.toStringAsFixed(2)} (Prepaid)"),
                  const Divider(),
                  row("Total Payable Amount",
                      "₹${totalPayable.toStringAsFixed(2)}", bold: true),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ---------------- PAYMENT DETAILS ----------------
            Container(
              padding: const EdgeInsets.all(14),
              decoration: box(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text("Payment Details",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),

                  // Payment Status with update option
                  Row(
                    children: [
                      const Icon(Icons.receipt_long, color: Colors.black54),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text("Payment Status",
                            style: TextStyle(color: Colors.grey.shade700)),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showPaymentStatusDialog();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: displayPaymentStatus.color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: displayPaymentStatus.color),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                displayPaymentStatus.label,
                                style: TextStyle(
                                  color: displayPaymentStatus.color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.edit, size: 14, color: displayPaymentStatus.color),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Outstanding Amount
                  if (outstandingAmount > 0)
                    Row(
                      children: [
                        const Icon(Icons.info, color: Colors.orange),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Outstanding Amount",
                            style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Text(
                          "₹${outstandingAmount.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),

                  if (outstandingAmount > 0) const SizedBox(height: 14),

                  // Payment Method
                  Row(
                    children: [
                      const Icon(Icons.payments, color: Colors.black54),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text("Payment Method",
                            style: TextStyle(color: Colors.grey.shade700)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Text(
                          inquiry.paymentMethod?.label ?? "N/A",
                          style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ---------------- PROVIDER CARD ----------------
            if (inquiry.provider != null)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: box(),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.redAccent.withOpacity(.15),
                      radius: 22,
                      child: Text(
                        inquiry.provider!.name[0],
                        style: const TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(inquiry.provider!.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        Text(inquiry.provider!.phone,
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 14),

            // ---------------- ACTION BUTTONS ----------------
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _assignProvider,
                      style: button(Colors.redAccent),
                      child: const Text("Assign Provider",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black.withOpacity(0.3)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: MaterialButton(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: _trackQuery,
                        child: const Text(
                          "Track Query",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                InvoiceScreen(inquiry: inquiry)),
                      );
                    },
                    icon: const Icon(Icons.format_align_right_outlined,
                        color: Colors.redAccent),
                  )
                ],
              ),
            ),

            // Extra bottom padding for safety
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _showPaymentStatusDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Update Payment Status"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: PaymentStatus.values.map((status) {
            return ListTile(
              leading: Icon(
                Icons.circle,
                color: status.color,
                size: 16,
              ),
              title: Text(status.label),
              onTap: () {
                _updatePaymentStatus(status);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  // ------------------ HELPERS ------------------
  BoxDecoration box() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 6,
        offset: const Offset(0, 3),
      )
    ],
  );

  Widget row(String title, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
              child: Text(title, style: const TextStyle(color: Colors.grey))),
          Text(value,
              style: TextStyle(
                  fontWeight: bold ? FontWeight.bold : FontWeight.w600)),
        ],
      ),
    );
  }

  ButtonStyle button(Color c) => ElevatedButton.styleFrom(
    backgroundColor: c,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    padding: const EdgeInsets.symmetric(vertical: 14),
  );
}