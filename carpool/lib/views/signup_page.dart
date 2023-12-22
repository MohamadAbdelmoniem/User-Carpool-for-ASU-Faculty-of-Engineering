import 'package:flutter/material.dart';
import '../controllers/signup_controller.dart';
import '../models/signup_model.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late SignUpController _controller;
  late SignUpModel _model;

  @override
  void initState() {
    super.initState();
    _model = SignUpModel();
    _controller = SignUpController(model: _model);
  }

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();

  bool isEmailValid = true;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    var white = Colors.white;
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Color(0xFF3498db),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          height: screenHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3498db), Color(0xFF2980b9)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    _buildTextField(
                      controller: firstNameController,
                      label: 'First Name',
                      icon: Icons.person,
                    ),
                    SizedBox(height: 12),
                    _buildTextField(
                      controller: lastNameController,
                      label: 'Last Name',
                      icon: Icons.person,
                    ),
                    SizedBox(height: 12),
                    _buildTextField(
                      controller: emailController,
                      label: 'Email',
                      icon: Icons.email,
                      isEmail: true,
                      errorText: isEmailValid ? null : 'Invalid email address',
                    ),
                    SizedBox(height: 12),
                    _buildTextField(
                      controller: mobileNumberController,
                      label: 'Mobile Number',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 12),
                    _buildTextField(
                      controller: passwordController,
                      label: 'Password',
                      icon: Icons.lock,
                      isPassword: true,
                    ),
                    SizedBox(height: 12),
                    _buildTextField(
                      controller: confirmPasswordController,
                      label: 'Confirm Password',
                      icon: Icons.lock,
                      isPassword: true,
                    ),
                    SizedBox(height: 32),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlueAccent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        String firstName = firstNameController.text;
                        String lastName = lastNameController.text;
                        String email = emailController.text;
                        String mobileNumber = mobileNumberController.text;
                        String password = passwordController.text;
                        String confirmPassword = confirmPasswordController.text;

                        // Validate the email format
                        bool validEmail = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@eng\.asu\.edu\.eg$',
                        ).hasMatch(email);

                        setState(() {
                          isEmailValid = validEmail;
                        });

                        if (firstName.isNotEmpty &&
                            lastName.isNotEmpty &&
                            validEmail &&
                            mobileNumber.isNotEmpty &&
                            password.isNotEmpty &&
                            confirmPassword.isNotEmpty &&
                            password == confirmPassword) {
                          try {
                            await _controller.signUp(
                              firstName: firstName,
                              lastName: lastName,
                              email: email,
                              mobileNumber: mobileNumber,
                              password: password,
                              confirmPassword: confirmPassword,
                            );
                            // Show success message
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Success'),
                                  content:
                                      Text('Signup completed successfully!'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.pop(context);
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } catch (e) {
                            // Show error message for email already in use
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Error'),
                                  content:
                                      Text('This email is already in use.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        } else {
                          // Show a generic error message
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Error'),
                                content:
                                    Text('Please fill in all fields correctly'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 16, color: white),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Already have an account? Log In',
                        style: TextStyle(color: white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isEmail = false,
    bool isPassword = false,
    TextInputType? keyboardType,
    String? errorText,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      keyboardType: keyboardType ??
          (isEmail ? TextInputType.emailAddress : TextInputType.text),
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        errorText: isEmailValid ? null : errorText,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: Icon(icon, color: Colors.white),
      ),
    );
  }
}
