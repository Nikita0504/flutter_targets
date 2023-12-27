import 'dart:async';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:trenning/firebase_api/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:trenning/firebase_auth/firebase_auth_services.dart';
import 'package:trenning/resources/add_image.dart';
import 'package:trenning/resources/add_image.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  String? uid;
  var name;
  var descriptions;
  var _nameController;
  var _descriptionsController;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  bool? showWidget;
  Uint8List? _image;
  String? ImageAvatar;
  @override
  void initState() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    uid = user?.uid;
    showWidget = true;
    super.initState();
  }

  Widget checkAvatar() {
    var Avatar;
    if (ImageAvatar == null) {
      if (_image != null) {
        Avatar = CircleAvatar(
          radius: 54,
          backgroundImage: MemoryImage(_image!),
        );
      } else if (_image == null) {
        Avatar = Container(
          margin: const EdgeInsets.all(10),
          child: _auth.getProfileImage(),
        );
      }
    } else if (ImageAvatar != null) {
      if (showWidget == true) {
        Avatar = ClipOval(
          child: Image.network(ImageAvatar!,
              height: 125, width: 125, fit: BoxFit.cover),
        );
      } else {
        if (_image != null) {
          Avatar = CircleAvatar(
            radius: 54,
            backgroundImage: MemoryImage(_image!),
          );
        } else if (_image == null) {
          Avatar = Container(
            margin: const EdgeInsets.all(10),
            child: _auth.getProfileImage(),
          );
        }
      }
    }
    return Avatar;
  }

  void pushData() async {
    if (_image != null) {
      String? resp = await AddImage().saveData(
          uid: uid!,
          file: _image!,
          name: _nameController,
          descriptions: _descriptionsController);
    } else {
      FirebaseFirestore.instance.collection('Users').doc(uid).update({
        'profileData.name': _nameController,
        'profileData.descriptions': _descriptionsController,
      }).catchError((error) {
        print("Error adding document: $error");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).primaryTextTheme.displayLarge!;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text('Account', style: textStyle.copyWith(fontSize: 20)),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        titleTextStyle: Theme.of(context)
                            .primaryTextTheme
                            .displayLarge!
                            .copyWith(fontSize: 20),
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                        title: const Text(
                          'Сhange profile details',
                        ),
                        content: StatefulBuilder(builder: (context, setState) {
                          void selectFile() async {
                            Uint8List img = await picImage(ImageSource.gallery);
                            setState(() {
                              _image = img;
                            });
                          }

                          return Container(
                            height: MediaQuery.of(context).size.height * 0.25,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    checkAvatar(),
                                    IconButton(
                                        onPressed: () {
                                          selectFile();
                                          showWidget = false;
                                        },
                                        icon: const Icon(Icons.add_a_photo))
                                  ],
                                ),
                                TextFormField(
                                  onChanged: (value) {
                                    _nameController = value;
                                  },
                                  initialValue: name,
                                  decoration:
                                      const InputDecoration(hintText: 'Name'),
                                ),
                                TextFormField(
                                  onChanged: (value) {
                                    _descriptionsController = value;
                                  },
                                  initialValue: descriptions,
                                  decoration: const InputDecoration(
                                      hintText: 'Descriptions'),
                                ),
                              ],
                            ),
                          );
                        }),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              'Cancel',
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .displayLarge!
                                  .copyWith(fontSize: 14),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              pushData();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'OK',
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .displayLarge!
                                  .copyWith(fontSize: 14),
                            ),
                          ),
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.border_color))
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Error'),
              );
            } else if (snapshot.hasData) {
              Map<String, dynamic>? data =
                  snapshot.data!.data() as Map<String, dynamic>?;
              return ListView.builder(
                  itemCount: data?.length,
                  itemBuilder: (
                    BuildContext context,
                    int index,
                  ) {
                    var key = data?.keys.elementAt(index);
                    var dataMap = data?[key];
                    ImageAvatar = dataMap['imageLink'];
                    print(ImageAvatar);
                    if (_nameController == null &&
                        _descriptionsController == null) {
                      _nameController = dataMap['name'];
                      _descriptionsController = dataMap['descriptions'];
                    }
                    if (key == 'profileData') {
                      name = dataMap['name'];
                      descriptions = dataMap['descriptions'];
                      return Container(
                        margin: EdgeInsets.fromLTRB(
                            0, MediaQuery.of(context).size.height * 0.25, 0, 0),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: ClipOval(
                                child: dataMap['imageLink'] == null
                                    ? _auth.getProfileImage()
                                    : Image.network(dataMap['imageLink'],
                                        height: 125,
                                        width: 125,
                                        fit: BoxFit.cover),
                              ),
                            ),
                            Text(
                              'Name: ${dataMap['name']}',
                              style: textStyle.copyWith(fontSize: 30),
                            ),
                            Container(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                'Descriptions: ${dataMap['descriptions']}',
                                style: textStyle.copyWith(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return null;
                  });
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
