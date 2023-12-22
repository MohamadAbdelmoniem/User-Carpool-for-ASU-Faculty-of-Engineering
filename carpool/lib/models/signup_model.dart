import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpModel {
  bool validateEmail(String email) {
    // Validate the email format
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@eng\.asu\.edu\.eg$',
    ).hasMatch(email);
  }

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String mobileNumber,
    required String password,
    required String confirmPassword,
  }) async {
    // Simulate a delay for demonstration purposes
    await Future.delayed(Duration(seconds: 2));

    // Validate the email address
    bool validEmail = validateEmail(email);

    if (!validEmail) {
      throw Exception('Invalid email address');
    }

    try {
      // Create user with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store additional user information in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'mobileNumber': mobileNumber,
      });
    } on FirebaseAuthException catch (e) {
      throw e;
    } on FirebaseException catch (e) {
      throw e;
    }
  }
}
