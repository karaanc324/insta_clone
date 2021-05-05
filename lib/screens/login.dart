import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insta_clone/screens/signup.dart';
import 'package:insta_clone/screens/update_profile.dart';
import 'package:insta_clone/service/firebase_service.dart';

import 'dashboard.dart';

class LoginPage {
  // LoginPage() {
  //   Firebase.initializeApp();
  // }
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  File _image;

  Padding getLoginPage(BuildContext context) {
    // Firebase.initializeApp();
    return Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: Text(
                  'SOCIO',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: Text(
                  'Sign in',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                //forgot password screen
              },
              child: Text('Forgot Password'),
            ),
            Container(
                height: 50,
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: RaisedButton(
                  textColor: Colors.white,
                  color: Colors.blue,
                  child: Text('Login'),
                  onPressed: () async {
                    print(nameController.text);
                    print(passwordController.text);
                    bool authSuccess = await FirebaseService()
                        .login(nameController.text, passwordController.text);
                    print(authSuccess);
                    if (authSuccess) {
                      bool profileValid = await FirebaseService()
                          .isProfileUpdated(nameController.text);
                      if (profileValid) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Dashboard()));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    UpdateProfile("LoginPage")));
                      }
                    }
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateProfile()));
                  },
                )),
            Container(
                child: Row(
              children: <Widget>[
                Text('Does not have account?'),
                FlatButton(
                  textColor: Colors.blue,
                  child: Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SignupPage().getSignupPage(context)));
                  },
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ))
          ],
        ));
  }
}
