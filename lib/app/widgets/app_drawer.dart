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
                selected: currentLocation == Routes.designER,
                contentPadding: EdgeInsets.only(left: 72),
                onTap: () {
                  context.go(Routes.designER);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.grid_view, size: 16),
                title: Text(ScreenInfo.designWard.title),
                selected: currentLocation == Routes.designWard,
                contentPadding: EdgeInsets.only(left: 72),
                onTap: () {
                  context.go(Routes.designWard);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.circle, size: 12),
                title: Text(ScreenInfo.designCvs.title),
                selected: currentLocation == Routes.designCvs,
                contentPadding: EdgeInsets.only(left: 72),
                onTap: () {
                  context.go(Routes.designCvs);
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
                leading: Icon(Icons.grid_view, size: 16),
                title: Text(ScreenInfo.calcGallery.title),
                selected: currentLocation == Routes.calculatorGallery,
                contentPadding: EdgeInsets.only(left: 72),
                onTap: () {
                  context.go(Routes.calculatorGallery);
                  Navigator.pop(context);
                },
              ),
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
              ListTile(
                leading: Icon(Icons.circle, size: 12),
                title: Text(ScreenInfo.calcTirads.title),
                selected: currentLocation == Routes.calculatorTirads,
                contentPadding: EdgeInsets.only(left: 72),
                onTap: () {
                  context.go(Routes.calculatorTirads);
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