import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/service/firebase_service.dart';

import 'dashboard.dart';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  _UpdateProfileState(){
    Firebase.initializeApp();
  }
  String email = FirebaseAuth.instance.currentUser.email;
  File _image;
  bool isLoading;
  FirebaseService firebaseService = FirebaseService();
  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
            title: Text('Update Profile'),
            content: Column(
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

                          child:
                          (_image != null)? Image.file(_image, fit: BoxFit.fill) :
                          Image.network("https://i.wpimg.pl/730x0/m.gadzetomania.pl/14491711-b2c9fc651724f95e538e8e6.jpg", fit: BoxFit.fill,)
                        // Image.file(_image)
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
                    onPressed: () async {
                      var image = await ImagePicker().getImage(source: ImageSource.gallery);

                      setState(() {
                        _image = File(image.path);
                      });
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: bioController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Bio',
                    ),
                  ),
                ),
                RaisedButton(
                  color: Colors.blueGrey,
                  onPressed: () {

                    firebaseService.updateProfile(context, _image, nameController.text, bioController.text, email);
                    Fluttertoast.showToast(msg: "updatinging...");
                    Fluttertoast.showToast(msg: "updated...");
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
                  },
                  elevation: 4.0,
                  child: Text('Submit'),
                ),
              ],
            ),
          )
      );
  }


  Future getImage() async{
    var image = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image.path);
    });
    // return File(image.path);
  }
}
