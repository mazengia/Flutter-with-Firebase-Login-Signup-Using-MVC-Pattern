import 'package:flutter/material.dart';

import '../controller/UserController.dart';
import '../model/UserModel.dart';
import 'UsersListView.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String? _errorMsg;
  final UserModel _user = UserModel(email: '', password: '');
  final UserController _controller = UserController();

  void _login() async {
    final errorMsg = await _controller.login(_user);
    setState(() {
      _errorMsg = errorMsg;
    });

    if (errorMsg == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UsersListView()), // Replace UsersListView with the actual name of your user list view
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
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
            SizedBox(height: 20),
            TextFormField(
              onChanged: (value) => setState(() => _user.password = value),
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.all(15),
              ),
              child: const Text('Login', style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 10),
            Text(
              _errorMsg ?? '',
              style: TextStyle(color: Colors.red, fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
