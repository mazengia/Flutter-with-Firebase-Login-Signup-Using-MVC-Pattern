import 'package:flutter/material.dart';
import 'package:flutter_login_signup_using_mvc_pattern_with_firebas/view/UsersListView.dart';
import 'package:flutter_login_signup_using_mvc_pattern_with_firebas/view/UsersView.dart';

class DrawerView extends StatefulWidget {
  const DrawerView({super.key});

  @override
  
  DrawerViewState createState() => DrawerViewState();
}

class DrawerViewState extends State<DrawerView> {
  String _selectedMenuItem = '';

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() async {}

  void _handleMenuItemTap(String menuItem) {
    setState(() {
      _selectedMenuItem = menuItem;
    });

    // Close the drawer after selecting a menu item
    Navigator.pop(context);

    switch (menuItem) {
      case 'Settings':
        break;
      case 'Users':
        break;
      case 'Logout':
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Of Users'),
        backgroundColor: Colors.blue,
        actions: const <Widget>[],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () => _handleMenuItemTap('Settings'),
            ),
            ListTile(
              title: const Text('Users'),
              onTap: () => _handleMenuItemTap('Users'),
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () => _handleMenuItemTap('Logout'),
            ),
          ],
        ),
      ),
      body: Center(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedMenuItem) {
      case 'Settings':
        return UsersView();
      case 'Users':
        return UsersListView();
      default:
        return const Text('No menu item selected');
    }
  }
}
