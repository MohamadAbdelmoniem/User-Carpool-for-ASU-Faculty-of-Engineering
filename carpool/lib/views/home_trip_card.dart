// home_trip_card.dart
import 'package:flutter/material.dart';
import '../models/trip_model.dart';

class HomeTripCard extends StatelessWidget {
  final Trip trip;

  HomeTripCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.directions_car,
                  color: Color(0xFF3498db),
                  size: 30,
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Color(0xFF3498db),
                          size: 20,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'To: ${trip.to}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Color(0xFF3498db),
                          size: 20,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Time: ${trip.time}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.event,
                          color: Color(0xFF3498db),
                          size: 20,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Date: ${trip.date}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Driver: ${trip.driverName}',
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            Text(
              'Gate Number: ${trip.gate}',
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            SizedBox(height: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.attach_money,
                      color: Colors.green,
                      size: 20,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Price: ${trip.price}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.event_seat,
                      color: Colors.red,
                      size: 20,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Available Seats: ${trip.availableSeats}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
