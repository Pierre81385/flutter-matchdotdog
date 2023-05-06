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
      Icon(Icons.location_on_outlined),
      Icon(
        Icons.chat_bubble_outline,
        size: 150,
      ),
    ];

    return Scaffold(
      body: SafeArea(child: _bottomNavPages.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, //New
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => AuthPage()
                        //MyDogsRedirect(user: user)
                        ),
                  );
                },
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                )),
            label: 'Me',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.list,
              color: Colors.amber,
            ),
            label: 'My Dogs',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.location_on,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.location_on,
              color: Colors.amber,
            ),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat_bubble_outline,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.chat_bubble_outline,
              color: Colors.amber,
            ),
            label: 'Chats',
          ),
        ],
      ),
    );
  }
}
