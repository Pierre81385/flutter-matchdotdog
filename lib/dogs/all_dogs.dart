import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matchdotdog/dogs/my_dogs.dart';
import 'package:matchdotdog/dogs/register_dog.dart';
import 'package:flip_card/flip_card.dart';
import '../ui/size.dart';

class AllDogs extends StatefulWidget {
  final User user;

  const AllDogs({required this.user});

  @override
  State<AllDogs> createState() => _AllDogsState();
}

class _AllDogsState extends State<AllDogs> {
  late User _currentUser;
  late Stream<QuerySnapshot> _allDogsStream;
  final firestoreInstance = FirebaseFirestore.instance;

  @override
  void initState() {
    _currentUser = widget.user;
    _allDogsStream = FirebaseFirestore.instance
        .collection('dogs')
        .where('owner', isNotEqualTo: _currentUser.uid)
        .snapshots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _allDogsStream,
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
                                  elevation: 5,
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
                                  elevation: 5,
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
                                                        MyDogs(
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
                                                Icons.location_on,
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
                                              color: data['liked']
                                                      .toString()
                                                      .contains(
                                                          _currentUser.uid)
                                                  ? Colors.red
                                                  : Colors.black,
                                              icon: const Icon(
                                                Icons.thumb_up_alt_rounded,
                                              ),
                                              onPressed: () {
                                                //needs a check to see if this dog has already been liked by user
                                                firestoreInstance
                                                    .collection("dogs")
                                                    .doc(document.id)
                                                    .update({
                                                      'liked': FieldValue
                                                          .arrayUnion([
                                                        _currentUser.uid
                                                      ])
                                                    })
                                                    .then((value) =>
                                                        print("Like Added"))
                                                    .catchError((error) => print(
                                                        "Failed to add like: $error"));
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
