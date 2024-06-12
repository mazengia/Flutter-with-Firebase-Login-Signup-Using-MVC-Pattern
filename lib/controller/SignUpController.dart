import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/UserModel.dart';

class SignUpController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<String?> signUp(UserModel user) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      // return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
    return null;
  }

}

