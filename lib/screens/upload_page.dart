import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
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

    Future getImage() async{
      var image = await ImagePicker().getImage(source: ImageSource.gallery);

      setState(() {
        _image = File(image.path);
      });
    }

    Future uploadPic(BuildContext context) async {
      var fileName = _image.path.split("/").last;
      print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
      print(email);
      TaskSnapshot snapshot = await FirebaseStorage.instance.ref().child("images/$email/$fileName").putFile(_image);
      print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
      print(downloadUrl);
      await FirebaseFirestore.instance.collection("images").add({"url": downloadUrl, "name": email});
      setState(() {
        isLoading = false;
      });
    }

    return Scaffold(
      body: Builder(
        builder: (context) => Container(
          child: Column(
            children: [
              SizedBox(height: 20.0,),
              Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.blue,
                  child: ClipOval(
                    child: SizedBox(
                        width: 180.0,
                        height: 180.0,

                        child: (_image != null)? Image.file(_image, fit: BoxFit.fill) :
                        Image.network("https://i.wpimg.pl/730x0/m.gadzetomania.pl/14491711-b2c9fc651724f95e538e8e6.jpg", fit: BoxFit.fill,)
                    ),
                  ),
                ),
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
}
