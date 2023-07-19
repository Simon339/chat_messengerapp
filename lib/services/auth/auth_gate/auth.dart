import 'package:chat_messengerapp/pages/homepage.dart';
import 'package:chat_messengerapp/services/auth/login_or_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return  const HomePage();
          }

          // user is Not Logged in
          else{
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
