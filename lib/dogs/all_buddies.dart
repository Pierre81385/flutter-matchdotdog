import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:matchdotdog/chat/chat.dart';
import 'package:matchdotdog/user/home.dart';
import '../models/dog_model.dart';
import '../models/owner_model.dart';

class AllBuddies extends StatefulWidget {
  final Owner owner;
  final Dog dog;

  const AllBuddies({super.key, required this.owner, required this.dog});

  @override
  State<AllBuddies> createState() => _AllBuddiesState();
}

class _AllBuddiesState extends State<AllBuddies> {
  late Owner _currentOwner;
  late Dog _currentDog;
  late Stream<QuerySnapshot> _allBuddiesStream;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _currentDogStream;
  late int _index;
  late bool _buddyState;

  @override
  void initState() {
    _currentOwner = widget.owner;
    _currentDog = widget.dog;
    _index = 0;
    _allBuddiesStream = FirebaseFirestore.instance
        .collection('dogs')
        .where('owner', isNotEqualTo: _currentOwner.uid)
        .snapshots();
    _currentDogStream = FirebaseFirestore.instance
        .collection('dogs')
        .doc(_currentDog.id)
        .snapshots();
    _buddyState = false;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return StreamBuilder<QuerySnapshot>(
      stream: _allBuddiesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        Dog _currentBuddy = Dog.fromJson(snapshot.data?.docs[_index]);

        return Scaffold(
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        _currentBuddy.photo,
                        width: width,
                        height: height,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Text(_currentBuddy.name),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _index == 0
                            ? SizedBox(height: 10, width: 10)
                            : Container(
                                height: height,
                                width: width * .2,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _index--;
                                    });
                                  },
                                ),
                              ),
                        (_index + 1) == snapshot.data?.docs.length
                            ? SizedBox(height: 10, width: 10)
                            : Container(
                                height: height,
                                width: width * .2,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _index++;
                                    });
                                  },
                                ),
                              ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            HomePage(owner: _currentOwner)),
                                  );
                                },
                                icon: Icon(Icons.person)),
                            IconButton(
                              iconSize: 50,
                              //check if _currentDog has liked this buddy or not
                              color:
                                  _currentBuddy.buddies.contains(_currentDog.id)
                                      ? Colors.red
                                      : Colors.white,
                              icon: const Icon(Icons.pets_rounded),
                              onPressed: () {
                                //currently widget.dog.id = THIS DOG not users dog
                                if (_currentDog.buddies
                                    .contains(_currentBuddy.id)) {
                                  print("removing this buddy from current dog");
                                  FirebaseFirestore.instance
                                      .collection("dogs")
                                      .doc(_currentDog.id)
                                      .update({
                                    'buddies': FieldValue.arrayRemove(
                                        [_currentBuddy.id])
                                  });
                                  setState(() {
                                    _currentDog.buddies
                                        .remove(_currentBuddy.id);
                                  });
                                  print('removing current dog from this buddy');
                                  FirebaseFirestore.instance
                                      .collection("dogs")
                                      .doc(_currentBuddy.id)
                                      .update({
                                    'buddies':
                                        FieldValue.arrayRemove([_currentDog.id])
                                  });
                                  setState(() {
                                    _currentBuddy.buddies
                                        .remove(_currentDog.id);
                                  });
                                  print('buddy removed');
                                } else {
                                  print("adding this buddy to current dog");
                                  FirebaseFirestore.instance
                                      .collection("dogs")
                                      .doc(_currentDog.id)
                                      .update({
                                    'buddies': FieldValue.arrayUnion(
                                        [_currentBuddy.id])
                                  });
                                  setState(() {
                                    _currentDog.buddies.add(_currentBuddy.id);
                                  });
                                  print('adding this dog to current buddy');
                                  FirebaseFirestore.instance
                                      .collection("dogs")
                                      .doc(_currentBuddy.id)
                                      .update({
                                    'buddies':
                                        FieldValue.arrayUnion([_currentDog.id])
                                  });
                                  setState(() {
                                    _currentBuddy.buddies
                                        .remove(_currentDog.id);
                                  });
                                  print('buddy added');
                                  print('current buddies now ' +
                                      _currentDog.buddies.toString());
                                }
                              },
                            ),
                            IconButton(
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => Chat(
                                              owner: _currentOwner,
                                              dog: _currentDog,
                                              buddy: _currentBuddy,
                                            )),
                                  );
                                },
                                icon: Icon(Icons.chat)),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
