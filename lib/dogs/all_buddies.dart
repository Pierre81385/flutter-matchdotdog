import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:matchdotdog/chat/chat.dart';
import 'package:matchdotdog/chat/chat_menu_contd.dart';
import 'package:matchdotdog/dogs/details/my_dogs_details.dart';
import 'package:matchdotdog/user/home.dart';
import '../models/dog_model.dart';
import '../models/owner_model.dart';

class AllBuddies extends StatefulWidget {
  const AllBuddies({
    super.key,
    required this.owner,
    required this.dog,
  });

  final Owner owner;
  final Dog dog;

  @override
  State<AllBuddies> createState() => _AllBuddiesState();
}

class _AllBuddiesState extends State<AllBuddies> {
  late Owner _currentOwner;
  late Dog _currentDog;
  late String _referrer;
  late Stream<QuerySnapshot> _allBuddiesStream;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _currentDogStream;
  late int _index;
  late bool _buddyState;
  bool _showDetails = false;
  late double _distance;

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
    _showDetails = false;
    _distance = 0;
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

        _distance = Geolocator.distanceBetween(
            _currentDog.ownerLat,
            _currentDog.ownerLong,
            _currentBuddy.ownerLat,
            _currentBuddy.ownerLong);

        return Scaffold(
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          _currentBuddy.photo,
                          width: width,
                          height: height,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
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
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(24),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.grey.withOpacity(0.5),
                            //     spreadRadius: 5,
                            //     blurRadius: 7,
                            //     offset:
                            //         Offset(0, 3), // changes position of shadow
                            //   ),
                            // ],
                          ),
                          child: Column(
                            children: [
                              _showDetails
                                  ? IconButton(
                                      color: Colors.black,
                                      onPressed: () {
                                        setState(() {
                                          _showDetails = false;
                                        });
                                      },
                                      icon: Icon(Icons.keyboard_arrow_down))
                                  : IconButton(
                                      color: Colors.black,
                                      onPressed: () {
                                        setState(() {
                                          _showDetails = true;
                                        });
                                      },
                                      icon: Icon(Icons.keyboard_arrow_up)),
                              _showDetails
                                  ? MyDogsDetails(dog: _currentBuddy)
                                  : Text(_currentBuddy.name),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                      color: Colors.black,
                                      onPressed: () {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) => HomePage(
                                                    owner: _currentOwner,
                                                    referrer: 'allBuddies',
                                                  )),
                                        );
                                      },
                                      icon: Icon(Icons.arrow_back_ios_new)),
                                  Column(
                                    children: [
                                      Text(
                                        _distance.roundToDouble().toString() +
                                            ' miles away',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      IconButton(
                                        iconSize: 50,
                                        //check if _currentDog has liked this buddy or not
                                        color: _currentBuddy.buddies
                                                .contains(_currentDog.id)
                                            ? Colors.red
                                            : Colors.black,
                                        icon: const Icon(Icons.pets_rounded),
                                        onPressed: () {
                                          //currently widget.dog.id = THIS DOG not users dog
                                          if (_currentDog.buddies
                                              .contains(_currentBuddy.id)) {
                                            print(
                                                "removing this buddy from current dog");
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
                                            print(
                                                'removing current dog from this buddy');
                                            FirebaseFirestore.instance
                                                .collection("dogs")
                                                .doc(_currentBuddy.id)
                                                .update({
                                              'buddies': FieldValue.arrayRemove(
                                                  [_currentDog.id])
                                            });
                                            setState(() {
                                              _currentBuddy.buddies
                                                  .remove(_currentDog.id);
                                            });
                                            print('buddy removed');
                                          } else {
                                            print(
                                                "adding this buddy to current dog");
                                            FirebaseFirestore.instance
                                                .collection("dogs")
                                                .doc(_currentDog.id)
                                                .update({
                                              'buddies': FieldValue.arrayUnion(
                                                  [_currentBuddy.id])
                                            });
                                            setState(() {
                                              _currentDog.buddies
                                                  .add(_currentBuddy.id);
                                            });
                                            print(
                                                'adding this dog to current buddy');
                                            FirebaseFirestore.instance
                                                .collection("dogs")
                                                .doc(_currentBuddy.id)
                                                .update({
                                              'buddies': FieldValue.arrayUnion(
                                                  [_currentDog.id])
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
                                    ],
                                  ),
                                  IconButton(
                                      color: Colors.black,
                                      onPressed: () {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) => ChatView(
                                                    owner: _currentOwner,
                                                    dog: _currentDog,
                                                    buddy: _currentBuddy,
                                                    referrer: 'allBuddies',
                                                  )),
                                        );
                                      },
                                      icon: Icon(Icons.chat)),
                                ],
                              ),
                            ],
                          ),
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
