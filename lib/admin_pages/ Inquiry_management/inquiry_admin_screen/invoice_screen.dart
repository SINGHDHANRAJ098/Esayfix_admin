import 'package:flutter/material.dart';
import '../inquiry_model/inquiry.model.dart';

class InvoiceScreen extends StatelessWidget {
  final Inquiry inquiry;

  const InvoiceScreen({super.key, required this.inquiry});

  double get bookingAmount =>
      inquiry.price != null ? inquiry.price! : 0;

  double get additionalServiceAmount =>
      inquiry.additionalAmount ?? 0;

  double get totalAmount =>
      bookingAmount + additionalServiceAmount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Invoice",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.redAccent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ------------------ SERVICE ID + TOTAL AMOUNT ------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Service ID: ${inquiry.id}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Total Amount: ₹${totalAmount.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ------------------ USER DETAILS ------------------
            _label("User Name"),
            _value(inquiry.customer),

            const SizedBox(height: 8),
            _label("User Mobile"),
            _value(inquiry.customerPhone ?? "N/A"),

            const SizedBox(height: 8),
            _label("Address"),
            _value(inquiry.customerAddress ?? inquiry.location),

            const SizedBox(height: 20),
            const Divider(thickness: 1),

            // ------------------ SERVICE LIST HEADER ------------------
            Row(
              children: const [
                Expanded(
                  flex: 4,
                  child: Text(
                    "Service Name",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "Qty",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "Price",
                    textAlign: TextAlign.end,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // ------------------ MAIN SERVICE ------------------
            _serviceRow(
              inquiry.service,
              "1",
              "₹${bookingAmount.toStringAsFixed(2)}",
            ),

            const SizedBox(height: 20),
            const Divider(thickness: 1),

            // ------------------ ADDITIONAL SERVICE SECTION ------------------
            _sectionTitle("Additional Service"),

            const SizedBox(height: 10),

            if ((inquiry.additionalServices ?? []).isEmpty)
              const Text(
                "No additional services added.",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              )
            else
              Column(
                children: inquiry.additionalServices!.map((item) {
                  return _serviceRow(
                    item.name,
                    item.qty.toString(),
                    "₹${item.price.toStringAsFixed(2)}",
                  );
                }).toList(),
              ),

            const SizedBox(height: 20),
            const Divider(thickness: 1),

            // ------------------ TOTAL SECTION ------------------
            _amountRow("Booking Amount", bookingAmount),
            _amountRow("Additional Service", additionalServiceAmount),
            _amountRow("Total Payable Amount", totalAmount, bold: true),

            const SizedBox(height: 20),
            const Divider(thickness: 1),

            // ------------------ PAYMENT INFO ------------------
            _paymentRow("Payment Status", inquiry.paymentStatus.label),
            _paymentRow("Payment Method", inquiry.paymentMethod?.label ?? "N/A"),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ------------------ UI HELPERS ------------------

  Widget _label(String text) => Text(
    text,
    style: TextStyle(
      fontSize: 13,
      color: Colors.grey.shade600,
      fontWeight: FontWeight.w500,
    ),
  );

  Widget _value(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
    ),
  );

  Widget _sectionTitle(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
    ),
  );

  Widget _serviceRow(String name, String qty, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(flex: 4, child: Text(name, style: _rowStyle())),
          Expanded(flex: 2, child: Text(qty, style: _rowStyle())),
          Expanded(
            flex: 2,
            child: Text(
              price,
              textAlign: TextAlign.end,
              style: _rowStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _amountRow(String label, double amount, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: bold ? FontWeight.bold : FontWeight.w600,
              )),
          Text(
            "₹${amount.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: bold ? Colors.redAccent : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              )),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _rowStyle({FontWeight fontWeight = FontWeight.normal}) {
    return TextStyle(
      fontSize: 14,
      fontWeight: fontWeight,
    );
  }
}
