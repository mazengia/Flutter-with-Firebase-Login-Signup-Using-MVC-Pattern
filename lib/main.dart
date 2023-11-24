import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_signup_using_mvc_pattern_with_firebas/view/SignUpView.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBVFTXBDvPYmM6zYf9jU2aO93A0wh6nIUU",
      appId: "1:688607727391:android:51329fdfe7dcbfc28e2a2a",
      messagingSenderId: "688607727391",
      projectId: "loginmvc-32778",
    ),
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:   SignUpView(),
    );
  }
}
