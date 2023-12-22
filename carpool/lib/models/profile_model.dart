//ProfileModel
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';
import '../local_database.dart';
import 'package:connectivity/connectivity.dart';

class ProfileModel {
  final LocalDatabase localDatabase = LocalDatabase.instance;

  Future<Map<String, dynamic>?> loadUserData(String userId) async {
    try {
      // Check for internet connection using the connectivity package
      var connectivityResult = await Connectivity().checkConnectivity();
      bool hasInternetConnection =
          connectivityResult == ConnectivityResult.mobile ||
              connectivityResult == ConnectivityResult.wifi;

      if (hasInternetConnection) {
        // If there is an internet connection, fetch data from Firebase
        print(
            'User has internet connection. Fetching user data from Firebase...');
        return await _fetchUserDataFromFirebase(userId);
      } else {
        // If there is no internet connection, read data from the local database
        print(
            'No internet connection. Reading user data from local database...');
        return await _loadLocalUserData(userId);
      }
    } catch (e) {
      print('Error loading user data: $e');
      return null;
    }
  }

  // Fetches user data from Firebase based on the provided [userId].
  Future<Map<String, dynamic>?> _fetchUserDataFromFirebase(
      String userId) async {
    try {
      // Fetch data from Firebase
      DocumentSnapshot<Map<String, dynamic>> userDocument =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();

      final userData = userDocument.data();

      // Save data to local database
      if (userData != null) {
        print('Saving user data to local database: $userData');
        await _saveLocalUserData(userId, userData);
      }
      print('User data loaded from Firebase: $userData');
      return userData;
    } catch (e) {
      print('Error fetching user data from Firebase: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> _loadLocalUserData(String userId) async {
    final db = await localDatabase.database;

    try {
      // Fetch data from local database
      final result =
          await db.query('profile', where: 'id = ?', whereArgs: [userId]);

      if (result.isNotEmpty) {
        final localUserData = result.first;
        print('User data loaded from local database: $localUserData');
        return localUserData;
      } else {
        print('User data not found in local database.');
        return null;
      }
    } catch (e) {
      print('Error loading user data from local database: $e');
      return null;
    }
  }

  Future<void> _saveLocalUserData(
      String userId, Map<String, dynamic> userData) async {
    final db = await localDatabase.database;

    await db.insert('profile', {...userData, 'id': userId},
        conflictAlgorithm: ConflictAlgorithm.replace);

    print('User data saved to local database: $userData');
  }

  Future<String?> getCurrentUserId() async {
    try {
      // Get the current authenticated user
      var user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        return user.uid;
      } else {
        return null;
      }
    } catch (e) {
      // Handle error, e.g., logging or throwing a custom exception
      print('Error getting current user ID: $e');
      return null;
    }
  }
}
