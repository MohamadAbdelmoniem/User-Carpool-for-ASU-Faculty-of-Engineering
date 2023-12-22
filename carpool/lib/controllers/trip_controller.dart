import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/trip_model.dart';
import 'dart:async';

class TripController {
  final CollectionReference tripsCollection =
      FirebaseFirestore.instance.collection('trips');

  final CollectionReference requestsCollection =
      FirebaseFirestore.instance.collection('requests');

  Future<List<Trip>> getAllTrips() async {
    try {
      final querySnapshot = await tripsCollection.get();

      return querySnapshot.docs
          .map((doc) => Trip.fromMap(
                doc.id, // Pass the document ID
                doc.data() as Map<String, dynamic>,
              ))
          .toList();
    } catch (e) {
      print("Error fetching trips: $e");
      return []; // Return an empty list in case of an error
    }
  }

  Future<List<Trip>> getTripsToAbdoBasha() async {
    try {
      final currentDate = DateTime.now();
      final reservationDeadline = DateTime(currentDate.year, currentDate.month,
          currentDate.day, 22, 0, 0); // 10:00 PM same day

      final querySnapshot = await tripsCollection
          .where('to', isEqualTo: 'Abdo Basha')
          .where('availableSeats', isGreaterThan: 0)
          .get();

      final filteredTrips = querySnapshot.docs
          .where((doc) {
            final tripDate = DateTime.parse(doc['date']);
            return tripDate.isAfter(currentDate) &&
                currentDate.isBefore(reservationDeadline);
          })
          .map((doc) => Trip.fromMap(
                doc.id,
                doc.data() as Map<String, dynamic>,
              ))
          .toList();

      return filteredTrips;
    } catch (e) {
      print("Error fetching trips to Abdo Basha: $e");
      return [];
    }
  }

  Future<List<Trip>> getTripsFromAbdoBasha() async {
    try {
      final currentDate = DateTime.now();
      final reservationDeadline = DateTime(currentDate.year, currentDate.month,
          currentDate.day, 13, 0, 0); // 1:00 PM same day

      final querySnapshot = await tripsCollection
          .where('from', isEqualTo: 'Abdo Basha')
          .where('availableSeats', isGreaterThan: 0)
          .get();

      final filteredTrips = querySnapshot.docs
          .where((doc) {
            final tripDate = DateTime.parse(doc['date']);
            final isToday = isSameDay(tripDate, currentDate);

            return tripDate.isAfter(currentDate) ||
                (isToday && currentDate.isBefore(reservationDeadline));
          })
          .map((doc) => Trip.fromMap(
                doc.id,
                doc.data() as Map<String, dynamic>,
              ))
          .toList();

      return filteredTrips;
    } catch (e) {
      print("Error fetching trips from Abdo Basha: $e");
      return [];
    }
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<void> bookTrip(String selectedTripId, String userId) async {
    try {
      // Get a reference to the Firestore collections
      CollectionReference requests =
          FirebaseFirestore.instance.collection('requests');

      // Retrieve user information from the 'users' collection
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // Check if the user exists
      if (userSnapshot.exists) {
        // Generate a unique requestId using Firebase's push method
        var requestId = requests.doc().id;

        // Add a new document to the 'requests' collection
        await requests.doc(requestId).set({
          'userId': userId,
          'status': 'pending',
          'tripId': selectedTripId,
          'requestId': requestId,
          // You can add more fields as needed
        });

        // Update the number of available seats for the booked trip
        await updateSeatsInFirestore(selectedTripId);

        print('Trip booked successfully for user $userId');
      } else {
        print('User with ID $userId does not exist');
      }
    } catch (e) {
      print("Error booking trip: $e");
    }
  }

  Future<void> updateSeatsInFirestore(String tripId) async {
    try {
      // Fetch the trip data
      DocumentSnapshot tripSnapshot = await tripsCollection.doc(tripId).get();

      if (tripSnapshot.exists) {
        // Decrease the number of available seats by 1
        int newAvailableSeats = (tripSnapshot['availableSeats'] ?? 0) - 1;

        // Update the 'availableSeats' field in Firestore
        await tripsCollection.doc(tripId).update({
          'availableSeats': newAvailableSeats,
        });
      }
    } catch (e) {
      print("Error updating available seats: $e");
    }
  }

  Future<List<Trip>> getUserHistoryTrips(String userId) async {
    try {
      final querySnapshot = await requestsCollection
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'done')
          .get();

      List<Trip> userHistoryTrips = [];

      for (final doc in querySnapshot.docs) {
        // Retrieve trip information based on the 'tripId' field in the request
        DocumentSnapshot tripSnapshot =
            await tripsCollection.doc(doc['tripId']).get();

        if (tripSnapshot.exists) {
          userHistoryTrips.add(Trip.fromMap(
            tripSnapshot.id, // Pass the document ID
            tripSnapshot.data() as Map<String, dynamic>,
          ));
        }
      }

      return userHistoryTrips;
    } catch (e) {
      print("Error fetching user history trips: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getUserTripStatus(String userId) async {
    try {
      final querySnapshot = await requestsCollection
          .where('userId', isEqualTo: userId)
          .where('status', whereIn: ['pending', 'accepted', 'rejected']).get();

      List<Map<String, dynamic>> userTripStatusList = [];

      for (final doc in querySnapshot.docs) {
        // Retrieve trip information based on the 'tripId' field in the request
        DocumentSnapshot tripSnapshot =
            await tripsCollection.doc(doc['tripId']).get();

        if (tripSnapshot.exists) {
          // Add trip information and request status to the list
          userTripStatusList.add({
            'tripId': tripSnapshot.id,
            'driverName': tripSnapshot['driverName'],
            'price': tripSnapshot['price'],
            'from': tripSnapshot['from'],
            'to': tripSnapshot['to'],
            'date': tripSnapshot['date'],
            'status': doc['status'],
          });
        }
      }

      return userTripStatusList;
    } catch (e) {
      print("Error fetching user trip status: $e");
      return [];
    }
  }

  // Function to automatically reject pending requests if not confirmed by a certain time
  Future<void> autoRejectPendingRequests() async {
    try {
      final currentDate = DateTime.now();
      final morningDeadline = DateTime(currentDate.year, currentDate.month,
          currentDate.day - 1, 23, 30, 0); // 11:30 PM same day
      final afternoonDeadline = DateTime(currentDate.year, currentDate.month,
          currentDate.day, 16, 30, 0); // 4:30 PM same day

      final pendingRequests =
          await requestsCollection.where('status', isEqualTo: 'pending').get();

      for (final doc in pendingRequests.docs) {
        final tripSnapshot = await tripsCollection.doc(doc['tripId']).get();

        if (tripSnapshot.exists) {
          final tripDate = DateTime.parse(tripSnapshot['date']);
          final isMorningRide = tripDate.isBefore(morningDeadline);
          final isAfternoonRide = tripDate.isBefore(afternoonDeadline);

          if ((isMorningRide && currentDate.isAfter(morningDeadline)) ||
              (isAfternoonRide && currentDate.isAfter(afternoonDeadline))) {
            // Automatically reject the request
            await requestsCollection.doc(doc.id).update({
              'status': 'rejected',
            });

            print('Request ${doc.id} automatically rejected.');
          }
        }
      }
    } catch (e) {
      print("Error auto-rejecting pending requests: $e");
    }
  }

  // Function to schedule the auto-rejection task
  void scheduleAutoRejectionTask() {
    // Schedule the task to run periodically
    const autoRejectionInterval = const Duration(seconds: 10);
    Timer.periodic(autoRejectionInterval, (timer) async {
      await autoRejectPendingRequests();
    });
  }

  Future<List<Trip>> getAllTripsToAbdoBasha() async {
    try {
      final currentDate = DateTime.now();

      final querySnapshot = await tripsCollection
          .where('to', isEqualTo: 'Abdo Basha')
          .where('availableSeats', isGreaterThan: 0)
          .get();

      final filteredTrips = querySnapshot.docs
          .where((doc) {
            final tripDate = DateTime.parse(doc['date']);
            return tripDate.isAfter(currentDate) ||
                tripDate.year == currentDate.year &&
                    tripDate.month == currentDate.month &&
                    tripDate.day == currentDate.day;
          })
          .map((doc) => Trip.fromMap(
                doc.id,
                doc.data() as Map<String, dynamic>,
              ))
          .toList();

      return filteredTrips;
    } catch (e) {
      print("Error fetching all trips to Abdo Basha: $e");
      return [];
    }
  }

  Future<List<Trip>> getAllTripsFromAbdoBasha() async {
    try {
      final currentDate = DateTime.now();
      final currentDateWithoutTime =
          DateTime(currentDate.year, currentDate.month, currentDate.day);

      final querySnapshot = await tripsCollection
          .where('from', isEqualTo: 'Abdo Basha')
          .where('availableSeats', isGreaterThan: 0)
          .get();

      final filteredTrips = querySnapshot.docs
          .where((doc) {
            final tripDate = DateTime.parse(doc['date']);
            final tripDateWithoutTime =
                DateTime(tripDate.year, tripDate.month, tripDate.day);
            return tripDateWithoutTime
                    .isAtSameMomentAs(currentDateWithoutTime) ||
                tripDate.isAfter(currentDate);
          })
          .map((doc) => Trip.fromMap(
                doc.id,
                doc.data() as Map<String, dynamic>,
              ))
          .toList();

      return filteredTrips;
    } catch (e) {
      print("Error fetching all trips from Abdo Basha: $e");
      return [];
    }
  }
}
