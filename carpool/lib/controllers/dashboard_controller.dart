import 'package:flutter/material.dart';
import '../views/uni_routes_page.dart';
import '../views/home_routes_page.dart';
import '../views/history_screen.dart';
import '../views/trip_status_page.dart';
import '../views/profile_page.dart';

class DashboardController {
  void onHomeItemPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeRoutesPage()),
    );
  }

  void onUniversityItemPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UniRoutesPage()),
    );
  }

  void onHistoryItemPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HistoryScreen()),
    );
  }

  void onTripStatusItemPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TripStatusPage()),
    );
  }

  void onProfileItemPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
    );
  }
}
