import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Reusable Drawer with go_router
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            selected: currentLocation == '/',
            onTap: () {
              context.go('/');
              Navigator.pop(context);
            },
          ),
          ExpansionTile(
            leading: Icon(Icons.widgets),
            title: Text('Design Study'),
            initiallyExpanded: true,
            children: [
              ListTile(
                leading: Icon(Icons.circle, size: 12),
                title: Text('ER'),
                selected: currentLocation == '/design/er',
                contentPadding: EdgeInsets.only(left: 72),
                onTap: () {
                  context.go('/design/er');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.smart_button),
            title: Text('Calculator'),
            initiallyExpanded: true,
            children: [
              ListTile(
                leading: Icon(Icons.circle, size: 12),
                title: Text('General'),
                selected: currentLocation == '/calc/general',
                contentPadding: EdgeInsets.only(left: 72),
                onTap: () {
                  context.go('/calc/general');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            selected: currentLocation == '/settings',
            onTap: () {
              context.go('/settings');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}