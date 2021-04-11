import 'package:flutter/material.dart';

class ProfilePageWidget extends StatelessWidget {
  const ProfilePageWidget({
    Key key,
    @required this.image,
  }) : super(key: key);

  final Image image;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 100,
          width: 300,
          margin: EdgeInsets.all(5),
          color: Colors.black12,
          child: Text("Profile page"),
        );
      },
    );
  }
}