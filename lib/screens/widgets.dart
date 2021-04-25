import 'dart:io';

import 'package:flutter/material.dart';
class WidgetUtils {


  CircleAvatar showSelectedImage(File _image) {
    return CircleAvatar(
      radius: 100,
      backgroundColor: Colors.blue,
      child: ClipOval(
        child: SizedBox(
            width: 180.0,
            height: 180.0,

            child: (_image != null)? Image.file(_image, fit: BoxFit.fill) :
            Image.network("https://i.wpimg.pl/730x0/m.gadzetomania.pl/14491711-b2c9fc651724f95e538e8e6.jpg", fit: BoxFit.fill,)
        ),
      ),
    );
  }

}