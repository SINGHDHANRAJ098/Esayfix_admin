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
  double get serviceTotal =>
      inquiry.items.fold(0.0, (sum, item) => sum + (item.qty * item.price));

  double get bookingAmount =>
      inquiry.price != null && inquiry.price! < serviceTotal
          ? inquiry.price!
          : 0;

  double get additionalAmount => inquiry.additionalAmount;

  double get totalPayable =>
      serviceTotal - bookingAmount + additionalAmount;

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
            Navigator.pop(context);
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
          onStatusUpdate: widget.onStatusUpdate,
          onUpdateProvider: widget.onUpdateProvider,
        ),
      ),
    );
  }

  //  UI BUILD
  @override
  Widget build(BuildContext context) {
    // Get the bottom padding to avoid navigation bar
    final bottomPadding = MediaQuery.of(context).padding.bottom;

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
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.all(14).copyWith(
            bottom: 14 + bottomPadding, // Add extra bottom padding
          ),
          children: [
            // TOP ROW
            Container(
              padding: const EdgeInsets.all(14),
              decoration: box(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Booking ID: ${inquiry.id}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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

            // SERVICE LIST
            Container(
              padding: const EdgeInsets.all(14),
              decoration: box(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Services",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),

                  Row(
                    children: const [
                      Expanded(flex: 6, child: Text("Service")),
                      Expanded(flex: 2, child: Text("Qty")),
                      Expanded(
                          flex: 3,
                          child: Text("Price", textAlign: TextAlign.right)),
                    ],
                  ),
                  const Divider(),

                  ...inquiry.items.map(
                        (item) => Padding(
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
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // CUSTOMER NOTE
            if ((inquiry.userNotes ?? "").isNotEmpty)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: box(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Customer Note",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 8),
                    Text(inquiry.userNotes!,
                        style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),

            const SizedBox(height: 12),

            // TOTALS
            Container(
              padding: const EdgeInsets.all(14),
              decoration: box(),
              child: Column(
                children: [
                  row("Total", "₹${serviceTotal.toStringAsFixed(2)}"),
                  row("Booking Amount", "₹${bookingAmount.toStringAsFixed(2)}"),
                  row("Additional Service",
                      "₹${additionalAmount.toStringAsFixed(2)}"),
                  const Divider(),
                  row("Total Payable Amount",
                      "₹${totalPayable.toStringAsFixed(2)}",
                      bold: true),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // PAYMENT DETAILS
            Container(
              padding: const EdgeInsets.all(14),
              decoration: box(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Payment Details",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 16),

                  // Payment Status Row
                  Row(
                    children: [
                      const Icon(Icons.receipt_long, color: Colors.black54),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text("Payment Status",
                            style: TextStyle(color: Colors.grey.shade700)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: inquiry.paymentStatus.color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: inquiry.paymentStatus.color),
                        ),
                        child: Text(
                          inquiry.paymentStatus.label,
                          style: TextStyle(
                            color: inquiry.paymentStatus.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Payment Method Row
                  Row(
                    children: [
                      const Icon(Icons.payments, color: Colors.black54),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text("Payment Method",
                            style: TextStyle(color: Colors.grey.shade700)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Text(
                          inquiry.paymentMethod?.label ?? "N/A",
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            //  PROVIDER CARD
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
            Padding(
              padding: EdgeInsets.only(bottom: bottomPadding), // Extra space for navigation bar
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _assignProvider,
                      style: button(Colors.redAccent),
                      child: const Text(
                        "Assign Provider",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Track Query Button (White UI)
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border:
                        Border.all(color: Colors.black.withOpacity(0.3)),
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
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>InvoiceScreen(inquiry: inquiry)));
                    },
                    icon:  Icon(Icons.format_align_right_outlined, color: Colors.redAccent),
                  )
                ],
              ),
            ),


            SizedBox(height: bottomPadding > 0 ? bottomPadding : 20),
          ],
        ),
      ),
    );
  }

  //  HELPERS
  BoxDecoration box() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 6,
          offset: const Offset(0, 3))
    ],
  );

  Widget row(String title, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
              child:
              Text(title, style: const TextStyle(color: Colors.grey))),
          Text(
            value,
            style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.w600),
          ),
        ],
      ),
    );
  }

  ButtonStyle button(Color c) => ElevatedButton.styleFrom(
    backgroundColor: c,
    shape:
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    padding: const EdgeInsets.symmetric(vertical: 14),
  );
}