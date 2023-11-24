import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../controller/UserController.dart';

class UsersListView extends StatefulWidget {
  final UserController controller = UserController();
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  UsersListView({super.key});
  @override
  _UsersListViewState createState() => _UsersListViewState();
}

class _UsersListViewState extends State<UsersListView> {

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() async {
    final CollectionReference usersRef = widget._fireStore.collection('cities');
    final snapshot = await usersRef.get();
    if (snapshot.docs.isNotEmpty) {
      final cities = snapshot.docs.map((document) {
        final userData = document.data();
        if (userData is Map<String, dynamic>) {
          final userMap = Map<String, dynamic>.from(userData);
          final name = userMap['name'] as String?;
          if (name == null) {
            print('Missing "name" property in document data');
            return null;
          }
          final state = userMap['state'] as String?;
          if (state == null) {
            print('Missing "state" property in document data');
            return null;
          }

          return {
            'name': name,
            'state': state,
          };
        } else {
          print('Document data is not a map');
          return null;
        }
      }).toList();

      final filteredUsers = cities.where((user) => user != null).toList();

      setState(() {
        _users = filteredUsers.cast<Map<String, dynamic>>();
      });
    } else {
      print('No users found');
    }
  }

  void addData() {
    widget._fireStore.collection('cities').doc('LA').set({
      'id': '002',
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
        title: const Text('Cloud Firestore Users'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await widget.controller.logout();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 200, // Adjust the height as needed
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return ListTile(
                  title: Text(user['name']),
                  subtitle: Text(user['state']),
                );
              },
            ),
          ),

          ElevatedButton(
            onPressed: () {
              // Wait for the widget to be built
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // Interact with the widget here
              });
            },
            child: const Text('Insert Data'),
          ),
        ],
      ),

    );
  }


}
