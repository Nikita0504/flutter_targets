import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices{

FirebaseAuth _auth = FirebaseAuth.instance;

// ignore: body_might_complete_normally_nullable
Future<User?> SignUpData(String email, String password) async {

try {
  UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
  return credential.user;
} catch(e){
print('error');
}}

// ignore: body_might_complete_normally_nullable
Future<User?> SignIpData(String email, String password) async {

try {
  UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
  return credential.user;
} catch(e){
print('error');
}}

  signUpWithEmailAndPassword(String email, String password) {}

}