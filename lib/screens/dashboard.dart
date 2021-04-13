import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/screens/profile_page.dart';
import 'package:insta_clone/screens/upload_page.dart';
import 'package:insta_clone/service/firebase_service.dart';

import 'home_page.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  _DashboardState() {
    User user = FirebaseAuth.instance.currentUser;
    print(user.email);
  }
  Widget widgetToShow;
  bool _initialized = false;
  bool _error = false;
  var _selectedIndex = 0; // this will be set when a new tab is tapped
  var firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return getDashboard();
  }

  Scaffold getDashboard() {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text('Home'),
              backgroundColor: Colors.red

          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.add_a_photo),
            title: new Text('Upload'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile')
          )
        ],
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        currentIndex: _selectedIndex,
      ),
      body: widgetToShow,
    );
  }
  // Future<QuerySnapshot> getImages() async {
  //   final FirebaseFirestore fb = FirebaseFirestore.instance;
  //   // await Firebase.initializeApp();
  //   return await fb.collection("lol").get();
  // }

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print(_selectedIndex);
    if (index == 0) {
      widgetToShow = MainPageWidget();
    }
    else if (index == 1) {
      widgetToShow = UploadPage();
    }
    else if ( index == 2) {
      widgetToShow = ProfilePageWidget();
    }
  }
}
