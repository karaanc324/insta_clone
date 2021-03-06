import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/screens/image_dashboard.dart';
import 'dart:io';

import 'package:insta_clone/screens/update_profile.dart';
import 'package:insta_clone/service/firebase_service.dart';

class ProfilePageWidget extends StatefulWidget {
  @override
  _ProfilePageWidgetState createState() => _ProfilePageWidgetState();
}

class _ProfilePageWidgetState extends State<ProfilePageWidget> {
  _ProfilePageWidgetState() {}

  String email = FirebaseAuth.instance.currentUser.email;
  User user = FirebaseAuth.instance.currentUser;
  get orientation => null;
  File _image;
  String url;
  String name;
  String bio;
  List<String> images = [];
  List menuItems = ["Delete"];

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
    return Column(
      children: [
        Container(
          child: Container(
              child: StreamBuilder(
            stream: getUserData(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return Row(
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.blue,
                      child: ClipOval(
                        child: SizedBox(
                            width: 180.0,
                            height: 180.0,
                            child:
                                // Image.network(url)
                                (snapshot.data.docs[0].data()["url"] != null)
                                    ? Image.network(
                                        snapshot.data.docs[0].data()["url"],
                                        fit: BoxFit.fill)
                                    : Image.network(
                                        "https://i.wpimg.pl/730x0/m.gadzetomania.pl/14491711-b2c9fc651724f95e538e8e6.jpg",
                                        fit: BoxFit.fill,
                                      )),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          snapshot.data.docs[0].data()["name"] != null
                              ? Text(
                                  snapshot.data.docs[0].data()["name"],
                                  style: TextStyle(fontSize: 30),
                                )
                              : Text("Refresh Please"),
                          snapshot.data.docs[0].data()["url"] != null
                              ? Text(
                                  snapshot.data.docs[0].data()["bio"],
                                  style: TextStyle(fontSize: 20),
                                )
                              : Text("Refresh Please"),
                          TextButton(
                              onPressed: () {
                                print(email);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UpdateProfile("ProfilePage")));
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
          )),
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
                if (snapshot.connectionState == ConnectionState.done) {
                  return GridView.builder(
                      itemCount: calcLength(snapshot.data.docs),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              (orientation == Orientation.portrait) ? 2 : 3),
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: InkResponse(
                            // child: Image.network(snapshot.data.docs[index].data()["url"], fit: BoxFit.fill,),
                            child: Image.network(images[index]),
                            onLongPress: () {
                              // showDialog(context: context, builder: (context) => AlertDialog(
                              //   content: TextButton(
                              //     child: Text("Delete"),
                              //   ),
                              // ));
                              print("long press");
                            },
                            onTap: () {
                              print("lolol");
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => ImageDashboard()));
                              // Navigator.push(context, CupertinoPageRoute(builder: (context) => ImageDashboard()));
                              showDialog<void>(
                                barrierDismissible: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return new Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: new Container(
                                          height: 500,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          color: Colors.grey,
                                          child: new Column(
                                            children: <Widget>[
                                              Image.network(images[index]),
                                              TextButton(
                                                  onPressed: () {
                                                    print(
                                                        "====================");
                                                    print(images[index]);
                                                    setState(() {
                                                      FirebaseService()
                                                          .delete(images[index])
                                                          .then((value) => {
                                                                images.remove(
                                                                    images[
                                                                        index])
                                                              });
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Delete")),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        );
                      });
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
      var lol = FirebaseFirestore.instance
          .collection("user_data")
          .doc(email)
          .get()
          .then((value) => {
                print(value["url"]),
                url = value["url"],
                name = value["name"],
                bio = value["bio"],
              });
    });
    return FirebaseFirestore.instance.collection("user_data").snapshots();
  }

  getUserImages() {
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
