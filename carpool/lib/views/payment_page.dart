import 'package:flutter/material.dart';
import '../controllers/payment_controller.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final PaymentController _controller = PaymentController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Page'),
        backgroundColor: Color(0xFF3498db),
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3498db), Color(0xFF2980b9)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Choose Payment Method:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 32),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _controller.setPaymentMethod('Cash');
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: _controller.selectedPaymentMethod == 'Cash'
                        ? Colors.green
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.attach_money,
                        size: 60,
                        color: _controller.selectedPaymentMethod == 'Cash'
                            ? Colors.white
                            : Colors.black,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Cash',
                        style: TextStyle(
                          color: _controller.selectedPaymentMethod == 'Cash'
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _controller.setPaymentMethod('Credit Card');
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: _controller.selectedPaymentMethod == 'Credit Card'
                        ? Colors.green
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.credit_card,
                        size: 60,
                        color:
                            _controller.selectedPaymentMethod == 'Credit Card'
                                ? Colors.white
                                : Colors.black,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Credit Card',
                        style: TextStyle(
                          color:
                              _controller.selectedPaymentMethod == 'Credit Card'
                                  ? Colors.white
                                  : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => _controller.processPayment(context),
                child: Text('Proceed to Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
