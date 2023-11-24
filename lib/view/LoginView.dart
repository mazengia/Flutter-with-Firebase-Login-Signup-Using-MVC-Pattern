import 'package:flutter/material.dart';

import '../controller/UserController.dart';
import '../model/UserModel.dart';
import 'UsersListView.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

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
      body: Column(
        children: <Widget>[
          TextFormField(
            onChanged: (value) => setState(() => _user.email = value),
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextFormField(
            onChanged: (value) => setState(() => _user.password = value),
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          ElevatedButton(
            onPressed: _login,
            child: const Text('Login'),
          ),
          Text(_errorMsg ?? '', style: const TextStyle(color: Colors.red))
        ],
      ),
    );
  }
}
