// trip_status_page.dart

import 'package:flutter/material.dart';
import '../controllers/trip_controller.dart';
import '../models/profile_model.dart';

class TripStatusPage extends StatefulWidget {
  @override
  _TripStatusPageState createState() => _TripStatusPageState();
}

class _TripStatusPageState extends State<TripStatusPage> {
  final TripController _tripController = TripController();
  final ProfileModel _profileModel = ProfileModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip Status'),
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
        child: FutureBuilder<String?>(
          future: _profileModel.getCurrentUserId(),
          builder: (context, userIdSnapshot) {
            if (userIdSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (userIdSnapshot.hasError || userIdSnapshot.data == null) {
              return Center(
                child: Text('Error fetching user ID'),
              );
            } else {
              String userId = userIdSnapshot.data!;

              return FutureBuilder<List<Map<String, dynamic>>>(
                future: _tripController.getUserTripStatus(userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text('No trips available.'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> tripStatus = snapshot.data![index];

                        // Determine the color and icon based on the status
                        Color statusColor;
                        IconData statusIcon;
                        switch (tripStatus['status']) {
                          case 'accepted':
                            statusColor = Colors.green;
                            statusIcon = Icons.check_circle;
                            break;
                          case 'rejected':
                            statusColor = Colors.red;
                            statusIcon = Icons.cancel;
                            break;
                          case 'pending':
                          default:
                            statusColor = Colors.orange;
                            statusIcon = Icons.access_time;
                            break;
                        }

                        return Card(
                          elevation: 4,
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Date: ${tripStatus['date']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      statusIcon,
                                      color: statusColor,
                                      size: 40,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Status: ${tripStatus['status']}',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: statusColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.attach_money,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Price: ${tripStatus['price']} EGP',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: Color(0xFF3498db),
                                      size: 30,
                                    ),
                                    SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'From: ${tripStatus['from']}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          'To: ${tripStatus['to']}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Driver: ${tripStatus['driverName']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}
