import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ProfilePageWidget extends StatelessWidget {
  String email = FirebaseAuth.instance.currentUser.email;

  get orientation => null;
  List<String> images = [];

  @override
  Widget build(BuildContext context) {
    // return GridView.builder(
    // itemCount: data.length,
    // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    // crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
    // itemBuilder: (BuildContext context, int index) {
    // return new Card(
    // child: new GridTile(
    // footer: new Text(data[index]['name']),
    // child: new Text(data[index]
    // ['image']), //just for testing, will fill with image later
    // ),
    // );
    // },
    // ),
    return Container(
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
    );
  }

  getUserImages() {
    return FirebaseFirestore.instance.collection("images").get();
  }

  calcLength(List<QueryDocumentSnapshot> docs) {
    int length = 0;
    for (int i = 0; i < docs.length; i++) {
      if (docs[i].data()["name"] == email) {
        length++;
        images.add(docs[i].data()["url"]);
      }
    }
    return length;
  }
}