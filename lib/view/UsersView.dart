import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../controller/LogOutController.dart';
import '../model/UserModel.dart';
class UsersView extends StatefulWidget {
  final LogOutController controller = LogOutController();
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  UsersView({super.key});

  @override
  UsersState createState() => UsersState();
}

class UsersState extends State<UsersView> {
  int _rowIndex = 1;
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() async {
    final CollectionReference usersRef = widget._fireStore.collection('users');
    QuerySnapshot<Object?> response;
    response = await usersRef.get();
    if (response.docs.isNotEmpty) {
      final users = response.docs.map((document) {
        final userData = document.data();
        if (userData is Map<String, dynamic>) {
          final userMap = Map<String, dynamic>.from(userData);
          final id = userMap['email'] as String?;
          final name = userMap['password'] as String?;
          return {
            'email': id,
            'password': name
          };
        } else {
          return null;
        }
      }).toList();

      final filteredUsers = users.where((user) => user != null).toList();

      setState(() {
        _users = filteredUsers.cast<Map<String, dynamic>>();
      });
    } else {
    }
  }

  void addData(UserModel userModel) {
    widget._fireStore.collection('cities').add({
      'email': userModel.email,
      'password': userModel.password
    }).then((value) {
      _fetchUsers();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data inserted successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  void updateData(UserModel userModel) {
    widget._fireStore.collection('users').doc('LA').set({
      'email': userModel.email,
      'password': userModel.password
    }).then((value) {
      _fetchUsers();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data updated successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Of Users'),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              // await widget.controller.logout();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: DataTable(
              columns: const [
                DataColumn(label: Text('#')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Password')),
                DataColumn(label: Text('Action')),
              ],
              rows: _users
                  .map((user) => DataRow(cells: [
                        DataCell(Text((_rowIndex++).toString())),
                        DataCell(Text(user['email'] ?? '')),
                        DataCell(Text(user['password'] ?? '')) ,
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              // await showUserDialog(context, isEditMode: true, title: 'Edit User', onSave: updateData,name:user['name']);

                            },
                          ),
                        ),
                      ]))
                  .toList(),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // await showUserDialog(context, isEditMode: false, title: 'Add New User', onSave: addData,name:'');
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
