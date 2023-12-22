import 'package:flutter/material.dart';
import '../controllers/dashboard_controller.dart';

class DashboardPage extends StatelessWidget {
  final DashboardController _controller = DashboardController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Color(0xFF3498db),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3498db), Color(0xFF2980b9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Where do you want to go?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 32),
              buildDashboardItem(
                context,
                'Home',
                Icons.home,
                _controller.onHomeItemPressed,
              ),
              SizedBox(height: 16),
              buildDashboardItem(
                context,
                'University',
                Icons.school,
                _controller.onUniversityItemPressed,
              ),
              SizedBox(height: 16),
              buildDashboardItem(
                context,
                'History',
                Icons.history,
                _controller.onHistoryItemPressed,
              ),
              SizedBox(height: 16),
              buildDashboardItem(
                context,
                'Trip Status',
                Icons.check_circle,
                _controller.onTripStatusItemPressed,
              ),
              SizedBox(height: 16),
              buildDashboardItem(
                context,
                'Profile',
                Icons.person,
                _controller.onProfileItemPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDashboardItem(
    BuildContext context,
    String title,
    IconData icon,
    Function(BuildContext) onTap,
  ) {
    return GestureDetector(
      onTap: () => onTap(context),
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Color(0xFF3498db),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Color(0xFF3498db),
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
