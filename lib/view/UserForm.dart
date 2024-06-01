import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/CityModel.dart';

Future<Object?> showUserDialog(
    BuildContext context, {
      required bool isEditMode,
      required String title,
      required Function(CityModel) onSave,
      required String documentId, // Specify the type for the name parameter
    }) async {
  final CityModel cityModel = CityModel(id: '', Name: '', State: '', Country: '');

  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  try {
    if (isEditMode) {
      DocumentReference cityRef = fireStore.collection('cities').doc(documentId);
      DocumentSnapshot<Object?> snapshot = await cityRef.get();
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>?;
        cityModel.id = data?['id'] ;
        cityModel.Name = data?['name'];
        cityModel.State = data?['state'];
        cityModel.Country = data?['country'];
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
                    initialValue: cityModel.id,
                    onChanged: (value) {
                      cityModel.id = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'ID',
                    ),
                  ),
                  TextFormField(
                    initialValue: cityModel.Name,
                    onChanged: (value) {
                      cityModel.Name = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                  TextFormField(
                    initialValue: cityModel.State,
                    onChanged: (value) {
                      cityModel.State = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'State',
                    ),
                  ),
                  TextFormField(
                    initialValue: cityModel.Country,
                    onChanged: (value) {
                      cityModel.Country = value;
                    },
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
                onSave(cityModel);
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
