import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
class MainPageWidget extends StatelessWidget {
  MainPageWidget() {
    Firebase.initializeApp();
  }

  getImages() {
    return FirebaseFirestore.instance.collection("images").get();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: getImages(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 500,
                  width: 10,
                  margin: EdgeInsets.all(5),
                  color: Colors.black12,
                  child: Image.network(snapshot.data.docs[index].data()["url"], fit: BoxFit.fill,),
                );
              },
            );
          } else if (snapshot.connectionState == ConnectionState.none) {
            return Text("No data");
          }
          return CircularProgressIndicator();

        },
      ),
    );
  }
}