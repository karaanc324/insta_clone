import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/screens/widgets.dart';
class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {

  _UploadPageState() {
    Firebase.initializeApp();
    print("============================+++++++++++++++++++++++");
    print(FirebaseAuth.instance.currentUser.email);
  }
  String email = FirebaseAuth.instance.currentUser.email;
  File _image;
  bool isLoading;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Builder(
        builder: (context) => Container(
          child: Column(
            children: [
              SizedBox(height: 20.0,),
              Align(
                alignment: Alignment.center,
                child: WidgetUtils().showSelectedImage(_image),
              ),
              Padding(
                padding: EdgeInsets.only(top: 1.0),
                child: IconButton(
                  icon: Icon(
                    Icons.camera,
                    size: 30.0,
                  ),
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                    });
                    getImage();
                  },
                ),
              ),
              RaisedButton(
                color: Colors.blueGrey,
                onPressed: () {

                  uploadPic(context);
                  Fluttertoast.showToast(msg: "uploading...");
                  Fluttertoast.showToast(msg: "uploaded...");
                },
                elevation: 4.0,
                child: Text('Submit'),
              )
            ],
          ),
        ),
      ),
    );
  }


  Future getImage() async{
    var image = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image.path);
    });
  }

  Future uploadPic(BuildContext context) async {
    String name;
    var fileName = _image.path.split("/").last;
    print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
    print(email);
    TaskSnapshot snapshot = await FirebaseStorage.instance.ref().child("images/$email/$fileName").putFile(_image);
    print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
    String downloadUrl = await snapshot.ref.getDownloadURL();
    print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
    print(downloadUrl);
    await FirebaseFirestore.instance.collection("user_data").doc(email).get().then((value) => {
      print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^6666"),
      print(value.get("name")),
      name = value.get("name"),
    });
    await FirebaseFirestore.instance.collection("images").add({"url": downloadUrl, "email": email, "name": name});
    setState(() {
      isLoading = false;
    });
  }





}
