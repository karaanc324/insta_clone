import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:insta_clone/screens/update_profile.dart';


class ProfilePageWidget extends StatefulWidget {
  @override
  _ProfilePageWidgetState createState() => _ProfilePageWidgetState();
}

class _ProfilePageWidgetState extends State<ProfilePageWidget> {
  _ProfilePageWidgetState() {}

  String email = FirebaseAuth.instance.currentUser.email;
  User user =  FirebaseAuth.instance.currentUser;
  get orientation => null;
  File _image;
  String url;
  String name;
  String bio;
  List<String> images = [];

  @override
  void initState() {
    // TODO: implement initState
    // setState(() {
    //   getUserData();
    // });
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) => getUserData());
    // Future.delayed(Duration(seconds: 5), () => getUserData());
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
             Container(
              child:
                  Container(
                    child: FutureBuilder(
                      future: getUserData(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if(snapshot.connectionState == ConnectionState.done) {
                          return Row(
                            children: [
                              CircleAvatar(
                                radius: 100,
                                backgroundColor: Colors.blue,
                                child: ClipOval(
                                  child: SizedBox(
                                      width: 180.0,
                                      height: 180.0,

                                      child:
                                      // Image.network(url)
                                      (url != null)? Image.network(url, fit: BoxFit.fill) :
                                      Image.network("https://i.wpimg.pl/730x0/m.gadzetomania.pl/14491711-b2c9fc651724f95e538e8e6.jpg", fit: BoxFit.fill,)
                                  ),
                                ),
                              ),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    name != null?
                                    Text(name, style: TextStyle(
                                        fontSize: 30
                                    ),) : Text("Refresh Please"),
                                    bio != null?
                                    Text(bio, style: TextStyle(
                                        fontSize: 20
                                    ),) : Text("Refresh Please"),
                                    TextButton(
                                        onPressed: () {
                                          print(email);
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateProfile("ProfilePage")));
                                        },
                                        child: Text("Edit Profile"))
                                  ],
                                ),
                              )
                            ],
                          );

                        }
                        return CircularProgressIndicator();
                      },
                    )
                  ),
            ),
        SizedBox(
          height: 50,
          width: 50,
        ),
        Container(
          child: Expanded(
            child: FutureBuilder(
              future: getUserImages(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.connectionState == ConnectionState.done) {
                return GridView.builder(
                    itemCount: calcLength(snapshot.data.docs),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: GridTile(
                          // child: Image.network(snapshot.data.docs[index].data()["url"], fit: BoxFit.fill,),
                          child: Image.network(images[index]),
                        ),
                      );
                    }
                );
              } else if (snapshot.connectionState == ConnectionState.none) {
                return Text("No data");
              }
              return CircularProgressIndicator();
              },
            ),
          ),
        ),
      ],
    );
  }

  getUserData() {
    print("++++++++++++++++++++++++++++++++++++++");
    setState(() {
      var lol = FirebaseFirestore.instance.collection("user_data").doc(email).get().then((value) => {
        print(value["url"]),
        url = value["url"],
        name = value["name"],
        bio = value["bio"],
      });
    });
    return FirebaseFirestore.instance.collection("user_data").get();
  }

  getUserImages() {
    print("getUserimages========================");
    return FirebaseFirestore.instance.collection("images").get();
  }

  calcLength(List<QueryDocumentSnapshot> docs) {
    int length = 0;
    for (int i = 0; i < docs.length; i++) {
      if (docs[i].data()["email"] == email) {
        length++;
        images.add(docs[i].data()["url"]);
      }
    }
    return length;
  }
}