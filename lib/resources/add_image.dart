import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class AddImage {
  Future<String> uploadImageToStorage(String uid, Uint8List file) async {
    Reference ref = _storage.ref().child(uid);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downLoadURL = await snapshot.ref.getDownloadURL();
    return downLoadURL;
  }

  Future<String?> saveData({
    required String uid,
    required Uint8List file,
    required String name,
    required String descriptions,
  }) async {
    String? resp;
    try {
      String imageURL = await uploadImageToStorage(uid, file);
      FirebaseFirestore.instance.collection('Users').doc(uid).update({
        'profileData.name': name,
        'profileData.descriptions': descriptions,
        'profileData.imageLink': imageURL,
      }).catchError((error) {
        print("Error adding document: $error");
      });
    } catch (e) {
      resp = e.toString();
      print(resp);
    }
  }
}
