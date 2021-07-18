import 'package:flutter/material.dart';

class CustomSnackbar {
  static showSnackBar(msg, context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          msg,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        duration: new Duration(seconds: 2),
        behavior: SnackBarBehavior.fixed,
        elevation: 3.0,
        backgroundColor: Colors.black,
      ),
    );
  }
}
