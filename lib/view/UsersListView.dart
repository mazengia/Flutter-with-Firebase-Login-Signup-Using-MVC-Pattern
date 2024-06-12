import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/CityModel.dart'; // Assuming you have a CityModel class
import 'UserForm.dart';

class UsersListView extends StatefulWidget {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  UsersListView({super.key});

  @override
  UsersListViewState createState() => UsersListViewState();
}

class UsersListViewState extends State<UsersListView> {
  List<City> _users = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() async {
    setState(() {
      _isLoading = true;
    });
    final CollectionReference usersRef = widget._fireStore.collection('cities');
    QuerySnapshot<Object?> response;
    response = await usersRef.get();
    if (response.docs.isNotEmpty) {
      final cities = response.docs.map((doc) {
        return City(id: doc.id, data: doc.data() as Map<String, dynamic>);
      }).toList();
      setState(() {
        _users = cities;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
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
          content: Text(error.toString()),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  void updateData(CityModel cityModel) {
    widget._fireStore.collection('cities').doc(cityModel.id).set({
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
          content: Text(error.toString()),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  void deleteData(String userId) async {
    await widget._fireStore.collection('cities').doc(userId).delete();
    _fetchUsers(); // Refresh the user list after deletion
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("User deleted successfully!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildAppBar(context),
          _isLoading
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : Expanded(
            child: Padding(
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
                        .asMap() // Use asMap() to get index for row number
                        .entries
                        .map((entry) {
                      final index = entry.key;
                      final city = entry.value;
                      return DataRow(cells: [
                        DataCell(Text((index + 1).toString())),
                        DataCell(Text(city.data['id'] ?? '')),
                        DataCell(Text(city.data['name'] ?? '')),
                        DataCell(Text(city.data['state'] ?? '')),
                        DataCell(Text(city.data['country'] ?? '')),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () async {
                                  await showUserDialog(
                                    context,
                                    isEditMode: true,
                                    title: 'Edit User',
                                    onSave: updateData,
                                    documentId: city.id,
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Confirm Deletion'),
                                        content: const Text('Are you sure you want to delete this user?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(); // Close the dialog
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              deleteData(city.id); // Pass the user ID to the delete function
                                              Navigator.of(context).pop(); // Close the dialog
                                            },
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showUserDialog(
            context,
            isEditMode: false,
            title: 'Add New User',
            onSave: addData,
             documentId: '',
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: AppBar(
        automaticallyImplyLeading: false, // Set this to false to remove the back arrow
        title: const Text('List Of Users'),
        centerTitle: true, // Center the title text
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}

class City {
  final String id;
  final Map<String, dynamic> data;

  City({required this.id, required this.data});
}
