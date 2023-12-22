// controllers/auth_controller.dart
import '../models/auth_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController {
  final AuthModel _authModel = AuthModel();

  Future<void> signInWithEmailAndPassword(String email, String password,
      Function(String) errorCallback, BuildContext context) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        errorCallback('Please enter both email and password.');
        return;
      }

      await _authModel.signInWithEmailAndPassword(email, password);

      // If the sign-in is successful, navigate to the dashboard
      Navigator.pushReplacementNamed(context, '/dashboard');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorCallback('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        errorCallback('Wrong password provided.');
      } else {
        errorCallback('Wrong Email Or Password Please check the entered data');
      }
    }
  }
}
