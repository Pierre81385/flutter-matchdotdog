import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:matchdotdog/dogs/my_dogs.dart';
import 'package:matchdotdog/user/auth_page.dart';
import '../models/owner_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.owner});

  final Owner owner;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Owner _currentOwner;
  int _selectedIndex = 1; //New

  @override
  void initState() {
    super.initState();
    _currentOwner = widget.owner;
  }

  @override
  Widget build(BuildContext context) {
    void _onItemTapped(int index) {
      print('selected index ' + index.toString());
      setState(() {
        _selectedIndex = index;
      });
    }

    List<Widget> _bottomNavPages = <Widget>[
      AuthPage(),
      MyDogs(owner: _currentOwner),
      Icon(
        Icons.chat,
        size: 150,
      ),
    ];

    return Scaffold(
      body: SafeArea(child: _bottomNavPages.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, //New
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts_sharp),
            label: 'Me',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'My Dogs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Map',
          ),
        ],
      ),
    );
  }
}
