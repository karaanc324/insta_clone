import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: EdgeInsets.all(10),
                  // height: 500,
                  // width: 100,
                  // margin: EdgeInsets.all(5),
                  // color: Colors.black12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          snapshot.data.docs[index].data()["name"],
                          style: TextStyle(
                            fontSize: 20,
                            // fontFamily:
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        child: snapshot.data.docs[index] != null
                            ? Image.network(
                                snapshot.data.docs[index].data()["url"])
                            : CircularProgressIndicator(),
                        // Image.network(
                        //   snapshot.data.docs[index].data()["url"],
                        // ),
                      )
                    ],
                  ),
                  // child: CachedNetworkImage(
                  //   imageUrl: snapshot.data.docs[index].data()["url"],
                  //   fit: BoxFit.fill,
                  //   placeholder: (context, url) => SizedBox( height: 10, width: 10, child: CircularProgressIndicator(),),
                  //   errorWidget: (context, url, error) => Icon(Icons.error),
                  // ),
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
