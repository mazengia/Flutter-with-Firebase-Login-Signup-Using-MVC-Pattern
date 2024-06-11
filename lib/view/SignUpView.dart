import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../controller/SignUpController.dart';
import '../model/UserModel.dart';
import 'DrawerVIew.dart';
import 'LoginView.dart';

class SignUpView extends StatelessWidget {
  final UserModel user = UserModel(email: '', password: '');
  final SignUpController controller = SignUpController();

  SignUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            TextFormField(
              onChanged: (value) => user.email = value,
              decoration: InputDecoration(
                labelText: 'Email',
                filled: true,
                fillColor: Colors.white,
                // border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              onChanged: (value) => user.password = value,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                filled: true,
                fillColor: Colors.white,
                // border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String? errorMessage = await controller.signUp(user);
                if (errorMessage == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Successfully signed up!"),
                    backgroundColor: Colors.green,
                  ));
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const DrawerView()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorMessage),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.all(15),
              ),
              child: Text(
                'Sign Up',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20), // Added SizedBox for spacing
            Row(
              children: [
                Text(
                  'Already Have an Account?',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    bool isAuthenticated = FirebaseAuth.instance.currentUser != null;
                    if (isAuthenticated) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DrawerView()),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginView()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    'Sign In',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
