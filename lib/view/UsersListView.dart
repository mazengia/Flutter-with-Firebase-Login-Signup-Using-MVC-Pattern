import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../controller/UserController.dart';
import '../model/CityModel.dart';

class UsersListView extends StatefulWidget {
  final UserController controller = UserController();
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  UsersListView({super.key});

  @override
  _UsersListViewState createState() => _UsersListViewState();
}

class _UsersListViewState extends State<UsersListView> {
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
          if (id == null) {
            print('Missing "name" property in document data');
            return null;
          }
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
          final country = userMap['country'] as String?;
          if (country == null) {
            print('Missing "name" property in document data');
            return null;
          }

          return {
            'id': id,
            'name': name,
            'state': state,
            'country': country,
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
    widget._fireStore.collection('cities').add({
      'id': '003',
      'name': 'mtesfa',
      'state': 'CAe',
      'country': 'USAe',
    }).then((value) {
      print("Data inserted successfully!");
    }).catchError((error) {
      print("Failed to insert data: $error");
    });
  }

  void updateData(CityModel cityModel) {
    widget._fireStore.collection('cities').doc('LA').set({
      'id': cityModel.id,
      'name': cityModel.Name,
      'state': cityModel.State,
      'country': cityModel.Country,
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
        title: const Text('Cloud Fire store Users'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await widget.controller.logout();
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: constraints.maxHeight * 0.8,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('id')),
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('State')),
                          DataColumn(label: Text('Country')),
                          DataColumn(label: Text('Action')),
                        ],
                        rows: _users
                            .map((user) => DataRow(
                                  cells: [
                                    DataCell(Text(user['id'])),
                                    DataCell(Text(user['name'])),
                                    DataCell(Text(user['state'])),
                                    DataCell(Text(user['country'])),
                                    DataCell(
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () async {
                                          await showDialog<void>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Edit User'),
                                                content: SingleChildScrollView(
                                                  child: Form(
                                                    child: Column(
                                                      children: [
                                                        TextFormField(
                                                          initialValue:
                                                              user['id'],
                                                          onChanged: (value) =>
                                                              setState(() =>
                                                                  _cityModel
                                                                          .id =
                                                                      value),
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText: 'Id',
                                                          ),
                                                        ),
                                                        TextFormField(
                                                          initialValue:
                                                              user['name'],
                                                          onChanged: (value) =>
                                                              setState(() =>
                                                                  _cityModel
                                                                          .Name =
                                                                      value),
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText: 'Name',
                                                          ),
                                                        ),
                                                        TextFormField(
                                                          initialValue:
                                                              user['state'],
                                                          onChanged: (value) =>
                                                              setState(() =>
                                                                  _cityModel
                                                                          .State =
                                                                      value),
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText: 'State',
                                                          ),
                                                        ),
                                                        TextFormField(
                                                          initialValue:
                                                              user['country'],
                                                          onChanged: (value) =>
                                                              setState(() =>
                                                                  _cityModel
                                                                          .Country =
                                                                      value),
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText:
                                                                'Country',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      updateData(_cityModel);
                                                      _fetchUsers();
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('Save'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    addData();
                    _fetchUsers();
                  },
                  child: const Text('Insert Data'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
