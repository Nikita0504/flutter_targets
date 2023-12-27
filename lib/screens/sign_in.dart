import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trenning/models/CustomClipper/signInOrsignUpCustomClipper.dart';

import '../firebase_auth/firebase_auth_services.dart';

class signIn extends StatefulWidget {
  const signIn({super.key});

  @override
  State<signIn> createState() => _signInState();
}

class _signInState extends State<signIn> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.all(15),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: TextButton(
                      onPressed: _singInButton,
                      child: Text(
                        'Login',
                        style: Theme.of(context)
                            .primaryTextTheme
                            .displayLarge!
                            .copyWith(fontSize: 14),
                      ),
                      style: Theme.of(context).textButtonTheme.style,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: TextButton(
                        onPressed: () {
                          _singUpGoogle();
                        },
                        style: Theme.of(context).textButtonTheme.style,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  child: Image.asset(
                                      'assets/images/icons/googleLogo.png')),
                              Text(
                                'Sign in to or create a Google account',
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .displayLarge!
                                    .copyWith(fontSize: 14),
                              ),
                            ],
                          ),
                        )),
                  ),
                  const Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 0)),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'if you do not have an account,',
                          style: Theme.of(context)
                              .primaryTextTheme
                              .displayLarge!
                              .copyWith(fontSize: 14),
                        ),
                        TextSpan(
                            text: ' click here',
                            style: Theme.of(context)
                                .primaryTextTheme
                                .displayLarge!
                                .copyWith(
                                    fontSize: 14, color: Colors.blueAccent),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/sign_up', (route) => false);
                              })
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ClipPath(
              clipper: MyCustomClipper(),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _singInButton() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    User? user = await _auth.SignIpData(email, password);
    // ignore: unused_local_variable
    final uid = user?.uid;
    if (user != null) {
      var docRef = FirebaseFirestore.instance.collection('Users').doc(uid);

      docRef.get().then((doc) => {
            if (doc.exists)
              {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (route) => false),
              }
            else
              {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/createAccount', (route) => false),
              }
          });
    } else {
      print('error');
    }
  }

  void _singUpGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    print('object');
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );
        await _auth.SignIpWithCredetial(credential);
        // ignore: use_build_context_synchronously
        User? user = await _auth.SignIpWithCredetial(credential);
        final uid = user?.uid;

        var docRef = FirebaseFirestore.instance.collection('Users').doc(uid);

        docRef.get().then((doc) => {
              if (doc.exists)
                {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false),
                }
              else
                {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/createAccount', (route) => false),
                }
            });
      }
    } catch (e) {
      print(e);
    }
  }
}
