import '../models/signup_model.dart';

class SignUpController {
  final SignUpModel model;

  SignUpController({required this.model});

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String mobileNumber,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      await model.signUp(
        firstName: firstName,
        lastName: lastName,
        email: email,
        mobileNumber: mobileNumber,
        password: password,
        confirmPassword: confirmPassword,
      );
    } catch (e) {
      throw e;
    }
  }
}
