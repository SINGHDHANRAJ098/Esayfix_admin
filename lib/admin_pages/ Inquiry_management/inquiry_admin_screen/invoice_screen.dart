import 'package:flutter/material.dart';
import '../inquiry_model/inquiry.model.dart';

class InvoiceScreen extends StatelessWidget {
  final Inquiry inquiry;

  const InvoiceScreen({super.key, required this.inquiry});

  // ------------------ CALCULATIONS ------------------
  double get serviceTotal =>
      inquiry.items.fold(0, (sum, item) => sum + (item.qty * item.price));

  double get additionalServiceTotal =>
      inquiry.additionalServices.fold(0, (sum, item) => sum + item.total);

  double get bookingAmount => inquiry.price ?? 0;

  double get totalBeforeBooking => serviceTotal + additionalServiceTotal;

  double get totalPayable => totalBeforeBooking - bookingAmount;

  double get outstandingAmount => totalBeforeBooking - bookingAmount;

  // ------------------ AUTO PAYMENT STATUS ------------------
  PaymentStatus get autoPaymentStatus {
    if (bookingAmount == 0) return PaymentStatus.unpaid;

    if (bookingAmount > 0 && bookingAmount < totalBeforeBooking) {
      return PaymentStatus.partiallyPaid;
    }

    return PaymentStatus.paid;
  }

  @override
  Widget build(BuildContext context) {
    final PaymentStatus paymentStatus = autoPaymentStatus;

    return Scaffold(
      backgroundColor: const Color(0xfff7f7f7),
      appBar: AppBar(
        title: const Text(
          "Invoice",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          // ---------------- HEADER ----------------
          Container(
            padding: const EdgeInsets.all(14),
            decoration: box(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Service ID: ${inquiry.id}",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "₹${totalPayable.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ------------ CUSTOMER DETAILS ------------
          Container(
            padding: const EdgeInsets.all(14),
            decoration: box(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title("Customer Details"),
                const SizedBox(height: 10),

                infoRow("Name", inquiry.customer),
                infoRow("Phone", inquiry.customerPhone ?? "N/A"),
                infoRow("Address", inquiry.customerAddress ?? inquiry.location),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ------------ MAIN SERVICES ------------
          Container(
            padding: const EdgeInsets.all(14),
            decoration: box(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title("Services"),
                const SizedBox(height: 10),

                headerRow(),
                const Divider(),

                ...inquiry.items.map(
                      (item) => serviceItem(item.name, item.qty, item.price),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ------------ ADDITIONAL SERVICES ------------
          Container(
            padding: const EdgeInsets.all(14),
            decoration: box(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title("Additional Services"),
                const SizedBox(height: 10),

                if (inquiry.additionalServices.isEmpty)
                  const Text("No additional services added.",
                      style: TextStyle(color: Colors.grey))
                else ...[
                  headerRow(),
                  const Divider(),
                  ...inquiry.additionalServices.map(
                        (item) =>
                        serviceItem(item.name, item.qty, item.price),
                  ),
                ]
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ------------ TOTALS ------------
          Container(
            padding: const EdgeInsets.all(14),
            decoration: box(),
            child: Column(
              children: [
                amountRow("Service Total", serviceTotal),
                amountRow("Additional Services", additionalServiceTotal),

                amountRow("Booking Amount (Prepaid)", bookingAmount),

                if (paymentStatus == PaymentStatus.partiallyPaid)
                  amountRow(
                    "Outstanding Amount",
                    outstandingAmount,
                    red: true,
                    bold: true,
                  ),

                const Divider(),

                amountRow(
                  "Total Payable",
                  totalPayable,
                  bold: true,
                  red: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ------------ PAYMENT INFO (MATCHING DETAIL SCREEN) ------------
          Container(
            padding: const EdgeInsets.all(14),
            decoration: box(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title("Payment Details"),
                const SizedBox(height: 16),

                // Status
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
                        color: paymentStatus.color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: paymentStatus.color),
                      ),
                      child: Text(
                        paymentStatus.label,
                        style: TextStyle(
                          color: paymentStatus.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Outstanding only when partially paid
                if (paymentStatus == PaymentStatus.partiallyPaid)
                  Row(
                    children: [
                      const Icon(Icons.info, color: Colors.orange),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text("Outstanding Amount",
                            style: TextStyle(color: Colors.grey.shade700)),
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

                const SizedBox(height: 14),

                // Method
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
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ---------------- UI HELPERS ----------------

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

  Widget title(String text) => Text(
    text,
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  );

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text(label,
                  style:
                  const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500))),
          Expanded(
              flex: 5,
              child: Text(value,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14))),
        ],
      ),
    );
  }

  Widget headerRow() => Row(
    children: const [
      Expanded(flex: 6, child: Text("Service")),
      Expanded(flex: 2, child: Text("Qty")),
      Expanded(flex: 3, child: Text("Price", textAlign: TextAlign.right)),
    ],
  );

  Widget serviceItem(String name, int qty, double price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(flex: 6, child: Text(name)),
          Expanded(flex: 2, child: Text(qty.toString())),
          Expanded(
            flex: 3,
            child: Text(
              "₹${(price * qty).toStringAsFixed(2)}",
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget amountRow(String label, double value,
      {bool bold = false, bool red = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: bold ? FontWeight.bold : FontWeight.w600,
              )),
          Text(
            "₹${value.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: red ? Colors.redAccent : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
