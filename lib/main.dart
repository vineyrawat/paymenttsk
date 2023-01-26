import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var razorpay = Razorpay();

    handlePaymentSuccess(PaymentSuccessResponse response) {
      log(response.toString());
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaymentStatus(
                  successResponse: response,
                )),
      );
    }

    handlePaymentError(PaymentFailureResponse response) {
      log(response.toString());
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaymentStatus(
                  failureResponse: response,
                )),
      );
    }

    handleExternalWallet(ExternalWalletResponse response) {
      log(response.toString());
    }

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);

    var options = {
      'key': 'rzp_test_dRnTf8C2uTHYA7',
      'amount': 100,
      'name': 'Testing order.',
      'description': 'Test order',
      'prefill': {'contact': '9675705065', 'email': 'vineyrawat@yahoo.com'}
    };

    handlePaymentClick() {
      razorpay.open(options);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Razorpay Integration"),
      ),
      body: Center(
        child: OutlinedButton(
            onPressed: handlePaymentClick,
            child: const Text("Open Payment Page")),
      ),
    );
  }
}

class PaymentStatus extends StatelessWidget {
  final PaymentSuccessResponse? successResponse;
  final PaymentFailureResponse? failureResponse;
  const PaymentStatus({super.key, this.failureResponse, this.successResponse});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color:
            successResponse != null ? Colors.green.shade50 : Colors.red.shade50,
        width: double.maxFinite,
        height: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: successResponse != null
                      ? Colors.green.shade200
                      : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(50000)),
              padding: const EdgeInsets.all(20),
              child: Icon(
                successResponse != null
                    ? Icons.check_circle_rounded
                    : Icons.warning_rounded,
                size: 100,
                color: successResponse != null ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              successResponse != null ? "Payment Success" : "Payment Failed",
              style: const TextStyle(
                fontSize: 25,
              ),
            ),
            Text(
              successResponse != null
                  ? "Payment is successfull"
                  : "Payment is failed",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.blueGrey.shade500),
            )
          ],
        ),
      ),
    );
  }
}
