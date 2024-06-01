import 'package:flutter/material.dart';

import '../controller/LoginController.dart';
import '../model/UserModel.dart';
import 'DrawerVIew.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  String? _errorMsg;
  final UserModel _user = UserModel(email: '', password: '');
  final LoginController _controller = LoginController();

  void _login() async {
    final errorMsg = await _controller.login(_user);
    setState(() {
      _errorMsg = errorMsg;
    });

    if (errorMsg == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DrawerView()), // Replace UsersListView with the actual name of your user list view
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              onChanged: (value) => setState(() => _user.email = value),
              decoration: const InputDecoration(
                labelText: 'Email',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              onChanged: (value) => setState(() => _user.password = value),
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.all(15),
              ),
              child: const Text('Login', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 10),
            Text(
              _errorMsg ?? '',
              style: const TextStyle(color: Colors.red, fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
