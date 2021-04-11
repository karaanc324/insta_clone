import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/screens/home_page.dart';
import 'package:insta_clone/screens/profile_page.dart';
import 'package:insta_clone/screens/upload_page.dart';
import 'package:insta_clone/service/firebase_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_login/flutter_login.dart';



void main() {
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Socio',
      theme: ThemeData.dark(),
      home: MyHomePage(title: 'Socio'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Image image;
  Widget widgetToShow;
  bool _initialized = false;
  bool _error = false;
  var _selectedIndex = 0; // this will be set when a new tab is tapped
  var firebaseService = FirebaseService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    //  return FlutterLogin(
    //   title: 'SOCIO',
    //   // logo: 'assets/images/ecorp-lightblue.png',
    //   onLogin: firebaseService.authUser,
    //   onSignup: firebaseService.authUser,
    //   onSubmitAnimationCompleted: () {
    //     Navigator.of(context).pushReplacement(MaterialPageRoute(
    //       builder: (context) => getDashboard(),
    //     ));
    //   },
    //   onRecoverPassword: firebaseService.recoverPassword,
    // );
    return getDashboard();
  }

  Scaffold getDashboard() {
    return Scaffold(
    appBar: AppBar(
      title: Text(widget.title),
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
  Future<QuerySnapshot> getImages() async {
    final FirebaseFirestore fb = FirebaseFirestore.instance;
    // await Firebase.initializeApp();
    return await fb.collection("lol").get();
  }

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
      widgetToShow = ProfilePageWidget(image: image);
    }
  }
}