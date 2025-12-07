import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../enums/screen_info.dart';
import '../router.dart';
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
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.inversePrimary),
            child: Text(
              'Menu',
              style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 24),
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
            leading: Icon(Icons.medical_information),
            title: Text('Design Study'),
            initiallyExpanded: true,
            children: [
              ListTile(
                leading: Icon(Icons.circle, size: 12),
                title: Text(ScreenInfo.designER.title),
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
            leading: Icon(Icons.calculate),
            title: Text('Calculator'),
            initiallyExpanded: true,
            children: [
              ListTile(
                leading: Icon(Icons.circle, size: 12),
                title: Text(ScreenInfo.calcAbdo.title),
                selected: currentLocation == Routes.calculatorAbdomen,
                contentPadding: EdgeInsets.only(left: 72),
                onTap: () {
                  context.go(Routes.calculatorAbdomen);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.circle, size: 12),
                title: Text(ScreenInfo.calcLiver.title),
                selected: currentLocation == Routes.calculatorLiver,
                contentPadding: EdgeInsets.only(left: 72),
                onTap: () {
                  context.go(Routes.calculatorLiver);
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