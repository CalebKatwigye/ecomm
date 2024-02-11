
import 'package:ecomm/components/mybutton.dart';
import 'package:ecomm/components/mytextfield.dart';
import 'package:ecomm/pages/homepage.dart';
import 'package:ecomm/pages/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  LoginPage({Key? key, required this.onTap});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Flag to control the visibility of the progress indicator
  bool _isLoading = false;

  // Sign in method
  void signUserIn() async {
    // Update the UI to show the circular progress indicator and overlay
    setState(() {
      _isLoading = true;
    });

    try {
      // Attempt to sign in the user
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Navigate to the homepage once signed in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (error) {
      // Handle sign-in errors here
      print('Error signing in: $error');
    } finally {
      // Update the UI to hide the circular progress indicator and overlay
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 35),
                    // Logo
                    Icon(
                      Icons.lock,
                      size: 100,
                    ),
                    SizedBox(height: 50),
                    // Welcome message
                    Text(
                      'Welcome back you\'ve been missed',
                      style: TextStyle(
                        color: Color.fromARGB(255, 97, 86, 86),
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 50),
                    // Email text field
                    MyTextFeild(
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false,
                    ),
                    SizedBox(height: 25),
                    // Password text field
                    MyTextFeild(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                    ),
                    SizedBox(height: 15),
                    // Forgot password
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'forgot password?',
                            style: TextStyle(
                                color: Color.fromARGB(255, 97, 96, 96)),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 35),
                    // Sign in button
                    MyButton(
                      text: "Sign In",
                      onTap: signUserIn,
                    ),
                    SizedBox(height: 25),
                    // Register link
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Not a Member? ',
                            style: TextStyle(
                                color: Color.fromARGB(255, 97, 96, 96)),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterPage(
                                    onTap: () {},
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Register Now',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 30, 137, 236),
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 35),
                  ],
                ),
              ),
            ),
          ),
          // Progress indicator and overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5), // Semi-transparent black color
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
