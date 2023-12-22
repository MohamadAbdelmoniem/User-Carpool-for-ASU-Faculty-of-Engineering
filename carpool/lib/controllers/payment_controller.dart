import 'package:flutter/material.dart';
import '../models/payment_model.dart';

class PaymentController {
  final PaymentModel _model = PaymentModel();

  String get selectedPaymentMethod => _model.selectedPaymentMethod;

  void setPaymentMethod(String method) {
    _model.setSelectedPaymentMethod(method);
  }

  Future<void> processPayment(BuildContext context) async {
    if (selectedPaymentMethod == 'Cash') {
      // Display a congratulatory message for Cash payment
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Congratulations!'),
            content: Text(
                'Your trip has been booked. Please pay the trip money to the driver when you arrive.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pop(context); // Pop the PaymentPage
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else if (selectedPaymentMethod == 'Credit Card') {
      // Display a message for unsupported Credit Card payment
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Unsupported Payment Method'),
            content: Text(
                'Credit Card payment is not supported yet. Please choose another payment method.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Show an error message if no payment method is selected.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please choose a payment method.'),
        ),
      );
    }
  }
}
