import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/screens/profile_page.dart';
import 'package:insta_clone/screens/widgets.dart';
import 'package:insta_clone/service/firebase_service.dart';

import 'dashboard.dart';

class UpdateProfile extends StatefulWidget {
  String caller;
  UpdateProfile(String caller) {
    this.caller = caller;
  }
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
                  child: WidgetUtils().showSelectedImage(_image),
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
                    if(widget.caller == "ProfilePage") {
                      Navigator.pop(context);
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
                    }
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
