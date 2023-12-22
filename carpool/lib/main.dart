import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'views/dashboard_page.dart';
import 'views/login_page.dart';
import 'controllers/trip_controller.dart'; // Import your TripController

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Create an instance of TripController
  final TripController tripController = TripController();

  // Schedule the auto-rejection task
  tripController.scheduleAutoRejectionTask();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      routes: {
        '/dashboard': (context) => DashboardPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
