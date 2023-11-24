import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../controller/UserController.dart';

class UsersListView extends StatelessWidget {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final UserController controller = UserController();

  UsersListView({super.key});

  void addData() {
    _fireStore.collection('cities').doc('LA').set({
      'name': 'Los Angeles',
      'state': 'CA',
      'country': 'USA',
    }).then((value) {
      print("Data inserted successfully!");
    }).catchError((error) {
      print("Failed to insert data: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FireStore Insert Example'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app),
              onPressed: () async {
                await controller.logout();
              },
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: addData,
          child: const Text('Insert Data'),
        ),
      ),
    );
  }
}