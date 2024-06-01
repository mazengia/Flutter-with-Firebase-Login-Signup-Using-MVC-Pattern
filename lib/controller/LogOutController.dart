import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../view/LoginView.dart';

class LogOutController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();



  Future<void> logout() async {
    print("navigatorKey");
    await _auth.signOut();
    if (navigatorKey.currentState != null) {
      navigatorKey.currentState!.pushReplacement(
        MaterialPageRoute(builder: (context) => LoginView()),
      );
    } else {
      print("not logedout");
      // Handle the case where navigatorKey.currentState is null
      // You can log an error or take appropriate action here
    }
  }

}

