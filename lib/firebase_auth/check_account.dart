import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trenning/screens/home_page.dart';
import 'package:trenning/screens/sign_in.dart';

class CheckAccount extends StatefulWidget {
  const CheckAccount({super.key});

  @override
  State<CheckAccount> createState() => _CheckAccountState();
}

class _CheckAccountState extends State<CheckAccount> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
  stream: FirebaseAuth.instance.authStateChanges(),
  builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
    if (snapshot.connectionState == ConnectionState.active) {
      final User? user = snapshot.data;
      if (user == null) {
        return const signIn();
      } else {
        return const MyHomePage();
      }
    } else {
      return const CircularProgressIndicator();
    }
  },
);
  }
}


