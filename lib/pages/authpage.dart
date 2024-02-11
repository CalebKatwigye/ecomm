
import 'package:ecomm/pages/homepage.dart';
import 'package:ecomm/pages/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user is looged in
          if (snapshot.hasData){
            return HomePage();
          }

          //user not logged in
          else {
            return LoginPage(onTap: () {},);
          }
        },
        ),
    );
  }
}