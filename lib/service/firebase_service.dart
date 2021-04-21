import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseService extends ChangeNotifier {
  FirebaseService() {
    Firebase.initializeApp();
  }

  // String email = FirebaseAuth.instance.currentUser.email;
  File _image;
  bool isLoading;

   registerUser(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      print("------------------------------");
      return true;
      // print(userCredential.user.email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        Fluttertoast.showToast(msg: "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        Fluttertoast.showToast(msg: "The account already exists for that email.");
      }
    } catch (e) {
      print(e);
    }

  }

  login(String email, String password) async {

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      print("------------------------------");
      if(userCredential != null) {
        return true;
      }
      // print(userCredential.user.email);
    } catch (e) {
      print(e);
    }
  }

  logout() async {
    await FirebaseAuth.instance.signOut();
  }

  isProfileUpdated(email) async {
     bool exists;
    // todo
    // if (FirebaseFirestore.instance.collection("user_data").doc(email).get() != null) {
    //   return true;
    // } else {
    //   return false;
    // }
     print("111111111111");
    await FirebaseFirestore.instance.collection("user_data").doc(email).get().then((doc) => {
      if (doc.exists) {
        print("2222222222222"),
        exists = true
      } else {
        print("3333333333333"),
        exists = false
    }
    });
    return exists;
  }

  Future getImage() async{
    var image = await ImagePicker().getImage(source: ImageSource.gallery);

    // setState(() {
    //   _image = File(image.path);
    // });
    return File(image.path);
  }
  //
  // Future uploadPic(BuildContext context) async {
  //   var fileName = _image.path.split("/").last;
  //   print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
  //   print(email);
  //   TaskSnapshot snapshot = await FirebaseStorage.instance.ref().child("images/$email/$fileName").putFile(_image);
  //   print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
  //   String downloadUrl = await snapshot.ref.getDownloadURL();
  //   print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
  //   print(downloadUrl);
  //   await FirebaseFirestore.instance.collection("images").add({"url": downloadUrl, "name": email});
  // }

  Future updateProfile(BuildContext context, File image, String name, String bio, String email) async {
    var fileName = image.path.split("/").last;
    print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
    print(email);
    TaskSnapshot snapshot = await FirebaseStorage.instance.ref().child("profile/$email/$fileName").putFile(image);
    print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
    String downloadUrl = await snapshot.ref.getDownloadURL();
    print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
    print(downloadUrl);
    await FirebaseFirestore.instance.collection("user_data").doc(email).set({"url": downloadUrl, "email": email, "name": name, "bio": bio});
  }
}

// class FirebaseService extends StatefulWidget {
//   @override
//   _FirebaseServiceState createState() => _FirebaseServiceState();
// }
//
// class _FirebaseServiceState extends State<FirebaseService> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
