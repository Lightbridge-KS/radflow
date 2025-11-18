import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RadFlow',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Index 0: Home Screen'),
    Text('Index 1: Design ER Screen'),
    Text('Index 2: General Calculator Screen'),
    Text('Index 3: Setting Screen'),
  ];
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RadFlow'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            // Collapsible Section
            ExpansionTile(
              leading: Icon(Icons.widgets),
              title: Text('Design Study'),
              initiallyExpanded: true, 
              children: [
                ListTile(
                  leading: Icon(Icons.circle, size: 12),
                  title: Text('ER'),
                  selected: _selectedIndex == 1,
                  contentPadding: EdgeInsets.only(left: 72),
                  onTap: () {
                    _onItemTapped(1);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            // Another Collapsible Section
            ExpansionTile(
              leading: Icon(Icons.smart_button),
              title: Text('Calculator'),
              initiallyExpanded: true,
              children: [
                ListTile(
                  leading: Icon(Icons.circle, size: 12),
                  title: Text('General'),
                  selected: _selectedIndex == 2,
                  contentPadding: EdgeInsets.only(left: 72),
                  onTap: () {
                    _onItemTapped(2);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              selected: _selectedIndex == 3,
              onTap: () {
                _onItemTapped(3);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Center(child: _widgetOptions[_selectedIndex]),
    );
  }
}
