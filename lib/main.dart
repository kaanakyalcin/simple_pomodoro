import 'package:flutter/material.dart';
import 'package:simple_pomodoro/ui/Home/home.dart';
import 'core/utils/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _pages = <Widget>[
    HomeUI(),
    Icon(
      Icons.camera,
      size: 150,
    ),
    Icon(
      Icons.settings,
      size: 150,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: _pages.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: SafeArea(
              child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 3, 12, 3),
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: const BoxDecoration(
                      color: CustomColor.logoBlue,
                      borderRadius: BorderRadius.all(Radius.circular(24))),
                  child: BottomNavigationBar(
                    elevation: 0,
                    backgroundColor: CustomColor.logoBlue,
                    iconSize: 32,
                    currentIndex: _selectedIndex,
                    selectedFontSize: 18,
                    selectedIconTheme: const IconThemeData(
                        color: Colors.amberAccent, size: 40),
                    selectedItemColor: Colors.amberAccent,
                    unselectedItemColor: CustomColor.white,
                    onTap: _onItemTapped,
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                          icon: Icon(Icons.home), label: 'Home'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.report), label: 'Report'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.settings), label: 'Settings'),
                    ],
                  ))),
        ));
  }
}
