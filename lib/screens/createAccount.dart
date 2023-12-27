import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:trenning/models/target_info.dart';
import 'package:trenning/notifications/notifications.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionsController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Name',
            ),
          ),
          const SizedBox(
            height: 7,
          ),
          TextField(
            controller: _descriptionsController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Descriptions',
            ),
          ),
          const SizedBox(
            height: 7,
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.05,
            child: TextButton(
              onPressed: () {
                setState(() {
                  createAccount();
                });
              },
              child: Text(
                "Create a new account",
                style: Theme.of(context)
                    .primaryTextTheme
                    .displayLarge!
                    .copyWith(fontSize: 16),
              ),
            ),
          )
        ],
      )),
    );
  }

  void createAccount() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    var uid = user?.uid;
    FirebaseFirestore.instance.collection('Users').doc(uid).set({});
    FirebaseFirestore.instance.collection('Users').doc(uid).update({
      'profileData.name': _nameController.text,
      'profileData.descriptions': _descriptionsController.text,
    }).catchError((error) {
      print("Error adding document: $error");
    });
    var docRef = FirebaseFirestore.instance.collection('Users').doc(uid);

    docRef.get().then((doc) => {
          if (doc.exists)
            {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
            }
          else
            {
              FirebaseFirestore.instance.collection('Users').doc(uid).update({
                'profileData.name': _nameController.text,
                'profileData.descriptions': _descriptionsController.text,
              }),
              docRef.get().then((doc) => {
                    if (doc.exists)
                      {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/', (route) => false),
                      }
                  }),
            }
        });
  }
}
