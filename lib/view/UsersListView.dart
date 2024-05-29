import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../controller/UserController.dart';
import '../model/CityModel.dart';

class UsersListView extends StatefulWidget {
  final UserController controller = UserController();
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  UsersListView({Key? key}) : super(key: key);

  @override
  _UsersListViewState createState() => _UsersListViewState();
}

class _UsersListViewState extends State<UsersListView> {
  int _rowIndex = 1;
  final CityModel _cityModel =
      CityModel(id: '', Name: '', State: '', Country: '');
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
          final id = userMap['id'] as String?;
          final name = userMap['name'] as String?;
          final state = userMap['state'] as String?;
          final country = userMap['country'] as String?;
          return {
            'id': id,
            'name': name,
            'state': state,
            'country': country,
          };
        } else {
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

  void addData(CityModel cityModel) {
    widget._fireStore.collection('cities').add({
      'id': cityModel.id,
      'name': cityModel.Name,
      'state': cityModel.State,
      'country': cityModel.Country,
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

  void updateData(CityModel cityModel) {
    widget._fireStore.collection('cities').doc('LA').set({
      'id': cityModel.id,
      'name': cityModel.Name,
      'state': cityModel.State,
      'country': cityModel.Country,
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
              await widget.controller.logout();
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
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('State')),
                DataColumn(label: Text('Country')),
                DataColumn(label: Text('Action')),
              ],
              rows: _users
                  .map((user) => DataRow(cells: [
                        DataCell(Text((_rowIndex++).toString())),
                        DataCell(Text(user['id'] ?? '')),
                        DataCell(Text(user['name'] ?? '')),
                        DataCell(Text(user['state'] ?? '')),
                        DataCell(Text(user['country'] ?? '')),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              getDataByEmail(true, user['name']);
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
          getDataByEmail(false, "");
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Future<Map<String, dynamic>?> getDataByEmail(
      bool isEditMode, String email) async {
    String title = isEditMode ? 'Edit User' : 'Add New User';
    var response = <String, dynamic>{};
    try {
      if (isEditMode) {
        QuerySnapshot<Map<String, dynamic>> querySnapshot = await widget
            ._fireStore
            .collection('cities')
            .where('name', isEqualTo: email)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          response = querySnapshot.docs.first.data();
        }
      }
      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: response['id'] ?? '',
                      onChanged: (value) =>
                          setState(() => _cityModel.id = value),
                      decoration: const InputDecoration(
                        labelText: 'ID',
                      ),
                    ),
                    TextFormField(
                      initialValue: response['name'] ?? '',
                      onChanged: (value) =>
                          setState(() => _cityModel.Name = value),
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                    ),
                    TextFormField(
                      initialValue: response['state'] ?? '',
                      onChanged: (value) =>
                          setState(() => _cityModel.State = value),
                      decoration: const InputDecoration(
                        labelText: 'State',
                      ),
                    ),
                    TextFormField(
                      initialValue: response['country'] ?? '',
                      onChanged: (value) =>
                          setState(() => _cityModel.Country = value),
                      decoration: const InputDecoration(
                        labelText: 'Country',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (isEditMode) {
                    updateData(_cityModel);
                  } else {
                    addData(_cityModel);
                  }
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
    return null;
  }
}
