import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../view/LoginView.dart';

class LogOutController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginView()),
    );
  }
}
