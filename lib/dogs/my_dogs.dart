import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:matchdotdog/dogs/register_dog.dart';
import '../ui/size.dart';

import 'all_dogs.dart';

class MyDogs extends StatefulWidget {
  final User user;
  const MyDogs({required this.user});

  @override
  State<MyDogs> createState() => _MyDogsState();
}

class _MyDogsState extends State<MyDogs> {
  late User _currentUser;
  late Stream<QuerySnapshot> _myDogsStream;

  @override
  void initState() {
    _currentUser = widget.user;
    _myDogsStream = FirebaseFirestore.instance
        .collection('dogs')
        .where('owner', isEqualTo: _currentUser.uid)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _myDogsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return Scaffold(
            body: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.white.withOpacity(0.2), width: 1.0),
                gradient: const LinearGradient(
                  colors: [Colors.amber, Colors.pink],
                  stops: [0.0, 1.0],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data!.docs.map(
                            (DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;
                              return FlipCard(
                                flipOnTouch: true,
                                direction: FlipDirection.VERTICAL,
                                front: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 50,
                                  margin: EdgeInsets.all(8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      data['image'],
                                      width: displayWidth(context) - 20,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                                back: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 50,
                                  margin: EdgeInsets.all(8),
                                  child: SizedBox(
                                    width: displayWidth(context) - 20,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                              iconSize: 50,
                                              icon: const Icon(
                                                color: Colors.black,
                                                Icons
                                                    .arrow_back_ios_new_rounded,
                                              ),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        RegisterDog(
                                                            user: _currentUser),
                                                  ),
                                                );
                                              },
                                            ),
                                            IconButton(
                                              iconSize: 50,
                                              icon: const Icon(
                                                color: Colors.black,
                                                Icons.chat_bubble_rounded,
                                              ),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AllDogs(
                                                            user: _currentUser),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                        Container(
                                          child: Column(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(150),
                                                child: Image.network(
                                                  data['image'],
                                                  width: 250,
                                                  height: 250,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 25,
                                              ),
                                              Text(data['name']),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                              iconSize: 50,
                                              icon: const Icon(
                                                color: Colors.black,
                                                Icons.edit_rounded,
                                              ),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AllDogs(
                                                            user: _currentUser),
                                                  ),
                                                );
                                              },
                                            ),
                                            IconButton(
                                              iconSize: 50,
                                              icon: const Icon(
                                                  color: Colors.black,
                                                  Icons.people_alt_rounded),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AllDogs(
                                                            user: _currentUser),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
