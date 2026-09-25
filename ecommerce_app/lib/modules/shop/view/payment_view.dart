import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PaymentView extends StatelessWidget {
  final String qrString;
  final double amount;
  const PaymentView({super.key, required this.qrString, required this.amount});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bakong KHQR Payment")),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Scan to Pay",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                "\$${amount.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              // Container to show Qr
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: QrImageView(
                  data: qrString,
                  version: QrVersions.auto,
                  size: 220.0,
                ),
              ),
              SizedBox(height: 30),
              const Text(
                'Please open any mobile baking app to scan and pay',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Get.snackbar("Success", "Payment verfied successfully");
                  Get.offAllNamed('/shop');
                },
                child: Text("Simulate Payment Success"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
