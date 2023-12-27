import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> SignUpData(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      print('error');
    }
  }

// ignore: body_might_complete_normally_nullable
  Future<User?> SignIpData(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      print('error');
    }
  }

  Future<User?> SignIpWithCredetial(getCredential) async {
    UserCredential credential = await _auth.signInWithCredential(getCredential);

    try {
      return credential.user;
    } catch (e) {
      print('error');
    }
  }

  getProfileImage() {
    if (_auth.currentUser?.photoURL != null) {
      return ClipOval(
        child: Image.network('${_auth.currentUser?.photoURL}',
            height: 100, width: 100, fit: BoxFit.cover),
      );
    } else {
      return const Icon(Icons.account_circle, size: 100);
    }
  }
}
