import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/screens/login.dart';
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
  Widget widgetToShow = MainPageWidget();
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
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text("SOCIO"),
        actions: [
          TextButton(
              onPressed: () {
                print("lohout");
                FirebaseService().logout();
                // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage().getLoginPage(context)));
                // Navigator.pop(context);
                Navigator.popUntil(
                    context, (Route<dynamic> predicate) => predicate.isFirst);
              },
              child: Icon(Icons.logout)),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.red),
          BottomNavigationBarItem(
            icon: new Icon(Icons.add_a_photo),
            label: 'Upload',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
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
    } else if (index == 1) {
      widgetToShow = UploadPage();
    } else if (index == 2) {
      widgetToShow = ProfilePageWidget();
    }
  }
}
