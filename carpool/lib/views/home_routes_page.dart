import 'package:flutter/material.dart';
import '../controllers/trip_controller.dart';
import 'home_trip_card.dart';
import 'payment_page.dart';
import '../models/profile_model.dart';
import '../models/trip_model.dart';

class HomeRoutesPage extends StatefulWidget {
  @override
  _HomeRoutesPageState createState() => _HomeRoutesPageState();
}

class _HomeRoutesPageState extends State<HomeRoutesPage> {
  final TripController _tripController = TripController();
  final ProfileModel _profileModel = ProfileModel();

  late Future<List<Trip>> Function() _getTripsFunction;

  @override
  void initState() {
    super.initState();
    // Default to showing restricted trips
    _getTripsFunction = _tripController.getTripsFromAbdoBasha;
  }

  Future<void> _showConfirmationDialog(BuildContext context, Trip trip) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Booking'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Do you want to book the trip to ${trip.to} at ${trip.time}?',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Book'),
              onPressed: () async {
                // Get the current user ID
                String? userId = await _profileModel.getCurrentUserId();

                if (userId != null) {
                  try {
                    // Book the trip by updating the document in Firestore
                    await _tripController.bookTrip(trip.id, userId);

                    // Close the dialog
                    Navigator.of(context).pop();

                    // Navigate to the payment page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage(),
                      ),
                    );
                  } catch (e) {
                    print('Error booking trip: $e');
                    // Handle error, e.g., show an error message
                    if (e.toString() == 'No available seats for this trip') {
                      // Handle case where there are no available seats
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('No Available Seats'),
                            content: Text(
                                'Sorry, there are no available seats for this trip.'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }
                } else {
                  print('User ID is null');
                  // Handle case where user ID is null
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Trips from Abdo Basha',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
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
        child: Column(
          children: [
            DropdownButton<String>(
              value: _getTripsFunction == _tripController.getTripsFromAbdoBasha
                  ? 'Show Trips (Restricted)'
                  : 'Show All Trips',
              items: [
                DropdownMenuItem(
                  value: 'Show Trips (Restricted)',
                  child: Text('Show Trips (Restricted)'),
                ),
                DropdownMenuItem(
                  value: 'Show All Trips',
                  child: Text('Show All Trips'),
                ),
              ],
              onChanged: (String? value) {
                if (value == 'Show Trips (Restricted)') {
                  setState(() {
                    _getTripsFunction = _tripController.getTripsFromAbdoBasha;
                  });
                } else {
                  setState(() {
                    _getTripsFunction =
                        _tripController.getAllTripsFromAbdoBasha;
                  });
                }
              },
            ),
            SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Trip>>(
                future: _getTripsFunction(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    List<Trip> trips = snapshot.data ?? [];

                    return ListView.builder(
                      itemCount: trips.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (index == 0 ||
                                trips[index].to != trips[index - 1].to)
                              Padding(
                                padding: EdgeInsets.only(bottom: 16),
                                child: Text(
                                  'Trips to ${trips[index].to}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            GestureDetector(
                              onTap: () => _showConfirmationDialog(
                                  context, trips[index]),
                              child: HomeTripCard(trip: trips[index]),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
