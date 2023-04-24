import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:matchdotdog/dogs/xmy_dog.dart';
import 'package:matchdotdog/dogs/xmy_dogs_gallery.dart';
import 'package:matchdotdog/dogs/xregister_dog.dart';
import 'package:flip_card/flip_card.dart';
import 'package:matchdotdog/main.dart';
import '../ui/size.dart';
//import 'dog_model.dart';

//dog object is friend dog.id, but liked needs currentuser.id + user dog.id not friend dog

class AllDogs extends StatefulWidget {
  final User user;
  final QueryDocumentSnapshot<Object?>? dog;
  final bool? oneDog;
  final String? myDogId;

  const AllDogs(
      {required this.user, required this.dog, this.oneDog, this.myDogId});

  @override
  State<AllDogs> createState() => _AllDogsState();
}

class _AllDogsState extends State<AllDogs> {
  late User _currentUser;
  //late Dog? _currentDog;
  late Stream<QuerySnapshot> _allDogsStream;
  late Stream<QuerySnapshot> _locationsStream;
  late Stream<QuerySnapshot> _oneDogStream;
  late Map<String, dynamic> _dogLocation;

  final firestoreInstance = FirebaseFirestore.instance;
  static const mainColor = Color.fromARGB(255, 94, 168, 172);
  static const secondaryColor = const Color(0xFFFBF7F4);
  static const accentColor = Color.fromARGB(255, 242, 202, 25);

  late Position _userPostion;
  late double _distance;
  bool _checkedDistance = false;

  @override
  void initState() {
    _currentUser = widget.user;
    //_currentDog = Dog.fromJson(widget.dog);

    _allDogsStream = FirebaseFirestore.instance
        .collection('dogs')
        .where('owner', isNotEqualTo: _currentUser.uid)
        .snapshots();

    _oneDogStream = FirebaseFirestore.instance
        .collection('dogs')
        .where(FieldPath.documentId, isEqualTo: widget.dog?.id)
        .snapshots();

    _distance = 0;

    super.initState();
  }

  // void getDistance(dogLat, dogLong) async {
  //   _userPostion = await Geolocator.getCurrentPosition();

  //   _distance = await Geolocator.distanceBetween(
  //     _userPostion.latitude,
  //     _userPostion.longitude,
  //     dogLat,
  //     dogLong,
  //   );

  //   print('distance: ' + _distance.toString());

  //   setState(() {
  //     _distance;
  //     _checkedDistance = true;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: widget.oneDog == true ? _oneDogStream : _allDogsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return Scaffold(
            body: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.white.withOpacity(0.2), width: 1.0),
                gradient: const LinearGradient(
                  colors: [mainColor, mainColor],
                  stops: [0.0, 1.0],
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: SafeArea(
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView(
                              clipBehavior: Clip.none,
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data!.docs.map(
                                (DocumentSnapshot document) {
                                  Map<String, dynamic> data =
                                      document.data()! as Map<String, dynamic>;

                                  return FlipCard(
                                    onFlip: () async {
                                      _userPostion =
                                          await Geolocator.getCurrentPosition();

                                      _distance =
                                          await Geolocator.distanceBetween(
                                        _userPostion.latitude,
                                        _userPostion.longitude,
                                        data['lat'],
                                        data['long'],
                                      );

                                      print(
                                          'distance: ' + _distance.toString());

                                      setState(() {
                                        _distance;
                                        _checkedDistance = true;
                                      });
                                    },
                                    flipOnTouch: true,
                                    direction: FlipDirection.VERTICAL,
                                    front: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      elevation: 5,
                                      margin: const EdgeInsets.all(8),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.network(
                                          data['image'],
                                          width: displayWidth(context) * .95,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ),
                                    back: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      elevation: 10,
                                      margin: const EdgeInsets.all(8),
                                      child: SizedBox(
                                        width: displayWidth(context) * .95,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Flex(
                                                  direction: Axis.vertical,
                                                  // mainAxisAlignment:
                                                  //     MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        IconButton(
                                                          iconSize: 50,
                                                          icon: const Icon(
                                                            color: mainColor,
                                                            Icons
                                                                .arrow_back_ios_new_rounded,
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              _checkedDistance =
                                                                  false;
                                                            });
                                                            // Navigator.of(
                                                            //         context)
                                                            //     .pushReplacement(
                                                            //   MaterialPageRoute(
                                                            //     builder: (context) =>
                                                            //         MyDogsGallery(
                                                            //             user:
                                                            //                 _currentUser),
                                                            //   ),
                                                            // );
                                                          },
                                                        ),
                                                        IconButton(
                                                          iconSize: 50,
                                                          icon: const Icon(
                                                            color: mainColor,
                                                            Icons
                                                                .chat_bubble_rounded,
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              _checkedDistance =
                                                                  false;
                                                            });
                                                            // Navigator.of(
                                                            //         context)
                                                            //     .pushReplacement(
                                                            //   MaterialPageRoute(
                                                            //     builder: (context) => AllDogs(
                                                            //         user:
                                                            //             _currentUser,
                                                            //         dog: _currentDog
                                                            //             as QueryDocumentSnapshot<
                                                            //                 Object?>?),
                                                            //   ),
                                                            // );
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        150),
                                                            child:
                                                                Image.network(
                                                              data['image'],
                                                              width: 250,
                                                              height: 250,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 25,
                                                          ),
                                                          Text(data['name']),
                                                          const SizedBox(
                                                            height: 25,
                                                          ),
                                                          Text((_distance /
                                                                      1609)
                                                                  .truncate()
                                                                  .toString() +
                                                              ' miles away'),
                                                        ],
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        // IconButton(
                                                        //   iconSize: 50,
                                                        //   icon: const Icon(
                                                        //     color: mainColor,
                                                        //     Icons.location_on,
                                                        //   ),
                                                        //   onPressed: () {
                                                        //     Navigator.of(
                                                        //             context)
                                                        //         .pushReplacement(
                                                        //       MaterialPageRoute(
                                                        //         builder: (context) => AllDogs(
                                                        //             user:
                                                        //                 _currentUser,
                                                        //             dog: _currentDog
                                                        //                 as QueryDocumentSnapshot<
                                                        //                     Object?>?),
                                                        //       ),
                                                        //     );
                                                        //   },
                                                        // ),
                                                        ///////////////////////////////////////////////////////////////////////////
                                                        IconButton(
                                                          iconSize: 50,
                                                          color: data['liked'].contains(
                                                                  _currentUser
                                                                          .uid +
                                                                      widget
                                                                          .dog!
                                                                          .id)
                                                              ? accentColor
                                                              : mainColor,
                                                          icon: const Icon(Icons
                                                              .pets_rounded),
                                                          onPressed: () {
                                                            //currently widget.dog.id = THIS DOG not users dog
                                                            if (data['liked']
                                                                .toString()
                                                                .contains(_currentUser
                                                                        .uid +
                                                                    widget.dog!
                                                                        .id)) {
                                                              firestoreInstance
                                                                  .collection(
                                                                      "dogs")
                                                                  .doc(document
                                                                      .id)
                                                                  .update({
                                                                    'liked':
                                                                        FieldValue
                                                                            .arrayRemove([
                                                                      _currentUser
                                                                              .uid +
                                                                          widget
                                                                              .dog!
                                                                              .id
                                                                    ])
                                                                  })
                                                                  .then((value) =>
                                                                      print(
                                                                          "Like Removed"))
                                                                  .catchError(
                                                                      (error) =>
                                                                          print(
                                                                              "Failed to remove like: $error"));
                                                            } else {
                                                              firestoreInstance
                                                                  .collection(
                                                                      "dogs")
                                                                  .doc(document
                                                                      .id)
                                                                  .update({
                                                                    'liked':
                                                                        FieldValue
                                                                            .arrayUnion([
                                                                      _currentUser
                                                                              .uid +
                                                                          widget
                                                                              .dog!
                                                                              .id
                                                                    ])
                                                                  })
                                                                  .then((value) =>
                                                                      print(
                                                                          "Like Added"))
                                                                  .catchError(
                                                                      (error) =>
                                                                          print(
                                                                              "Failed to add like: $error"));
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
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
                ],
              ),
            ),
          );
        });
  }
}
