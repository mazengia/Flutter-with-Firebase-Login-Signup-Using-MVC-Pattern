import 'package:flutter/material.dart';
import '../controller/UserController.dart';
import '../model/UserModel.dart';
import 'LoginView.dart';

class SignUpView extends StatelessWidget {
  final UserModel user = UserModel(email: '', password: '');
  final UserController controller = UserController();

  SignUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            TextFormField(
              onChanged: (value) => user.email = value,
              decoration: const InputDecoration(
                labelText: 'Email',
                filled: true,
                fillColor: Colors.white,
                // border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              onChanged: (value) => user.password = value,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                filled: true,
                fillColor: Colors.white,
                // border: OutlineInputBorder(),
              ),
            ),





            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String? errorMessage = await controller.signUp(user);
                if (errorMessage == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Successfully signed up!"),
                      backgroundColor: Colors.green,
                    ),
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
              child: const Text(
                'Sign Up',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Already Have Account?',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                // Ensure Firebase is initialized properly before using FirebaseAuth.instance
                // await FirebaseAuth.instance.signInAnonymously();

                // bool isAuthenticated =
                //     FirebaseAuth.instance.currentUser != null;
                // print(FirebaseAuth.instance.currentUser?.email);
                // if (isAuthenticated) {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) => UsersListView()),
                //   );
                // } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginView()),
                  );
                // }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[400],
                padding: const EdgeInsets.all(15),
              ),
              child: const Text(
                'Click SignIn',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
