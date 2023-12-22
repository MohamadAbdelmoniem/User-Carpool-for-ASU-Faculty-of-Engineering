import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/profile_controller.dart';
import '../models/profile_model.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User user;
  Map<String, dynamic>? userData;
  late ProfileController _controller;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    _controller = ProfileController(model: ProfileModel());
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    Map<String, dynamic>? loadedData = await _controller.loadUserData(user.uid);

    setState(() {
      userData = loadedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(0xFF3498db),
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
        child: Center(
          child: userData != null
              ? _buildProfileCard(userData!)
              : CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildProfileCard(Map<String, dynamic> userData) {
    return Card(
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileInfo(
                Icons.person, 'First Name', userData['firstName']),
            _buildProfileInfo(Icons.person, 'Last Name', userData['lastName']),
            _buildProfileInfo(Icons.email, 'Email', userData['email']),
            _buildProfileInfo(
                Icons.phone, 'Mobile Number', userData['mobileNumber']),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo(IconData icon, String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.blueAccent,
            size: 30.0,
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$label:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  '$value',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
