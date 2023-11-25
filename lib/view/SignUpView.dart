import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../controller/UserController.dart';
import '../model/UserModel.dart';
import 'LoginView.dart';
import 'UsersListView.dart';

class SignUpView extends StatelessWidget {
  final UserModel user = UserModel(email: '', password: '');
  final UserController controller = UserController();

  SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextFormField(
            onChanged: (value) => user.email = value,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextFormField(
            onChanged: (value) => user.password = value,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          ElevatedButton(
            onPressed: () async {
              String? errorMessage = await controller.signUp(user);
              if (errorMessage == null) {
                // Navigate to the next screen
              } else {
                // Display error message
              }
            },
            child: const Text('Sign Up'),
          ),
          const Text('Already Have Account?'),
          ElevatedButton(
            onPressed: () async {
              bool isAuthenticated = FirebaseAuth.instance.currentUser != null;
              if (isAuthenticated) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UsersListView()));
              } else {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginView()));
              }
            },
            child: const Text('Click SignIn'),
          ),
        ],
      ),
    );
  }
}
