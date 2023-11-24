import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/UserModel.dart';
import '../view/LoginView.dart';

class UserController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<String?> signUp(UserModel user) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> login(UserModel user) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
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

