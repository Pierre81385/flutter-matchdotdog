import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:matchdotdog/dogs/xmy_dogs_gallery.dart';
import 'package:matchdotdog/dogs/xmy_dogs_redirect.dart';
import 'package:matchdotdog/dogs/xregister_dog.dart';
import 'package:matchdotdog/ui/paws.dart';
import '../ui/size.dart';

import './xall_dogs.dart';
import '../unused/dog_model.dart';

class MyDog extends StatefulWidget {
  final User user;
  final QueryDocumentSnapshot<Object?>? dog;
  const MyDog({required this.user, required this.dog});

  @override
  State<MyDog> createState() => _MyDogState();
}

class _MyDogState extends State<MyDog> {
  late User _currentUser;
  late QueryDocumentSnapshot<Object?>? _currentDog;
  late Stream<QuerySnapshot> _oneDogStream;
  late Stream<QuerySnapshot> _friendStream;
  late Position _userPosition;

  static const mainColor = Color.fromARGB(255, 94, 168, 172);
  static const secondaryColor = const Color(0xFFFBF7F4);
  static const accentColor = Color.fromARGB(255, 242, 202, 25);

  @override
  void initState() {
    _currentUser = widget.user;
    _currentDog = widget.dog!;

    _oneDogStream = FirebaseFirestore.instance
        .collection('dogs')
        .where(FieldPath.documentId, isEqualTo: _currentDog!.id)
        .snapshots();
    _friendStream = FirebaseFirestore.instance
        .collection('dogs')
        .where('liked', arrayContains: _currentUser.uid + _currentDog!.id)
        .snapshots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _oneDogStream,
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
                  Paws(),
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
                                    flipOnTouch: true,
                                    direction: FlipDirection.VERTICAL,
                                    front: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      elevation: 10,
                                      //margin: const EdgeInsets.all(8),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.network(
                                          data['image'],
                                          width: displayWidth(context) * .95,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                      //),
                                    ),
                                    back: Card(
                                      color: secondaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      elevation: 10,
                                      margin: const EdgeInsets.all(8),
                                      child: SizedBox(
                                        width: displayWidth(context) * .95,
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: Icon(
                                                Icons.pets,
                                                size: 400,
                                                color: accentColor,
                                              ),
                                            ),
                                            Center(
                                              child: Icon(
                                                Icons.pets,
                                                size: 380,
                                                color: mainColor,
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                /// Friends List START
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: StreamBuilder<
                                                        QuerySnapshot>(
                                                      stream: _friendStream,
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<
                                                                  QuerySnapshot>
                                                              snapshot2) {
                                                        if (snapshot2
                                                            .hasError) {
                                                          return const Text(
                                                              'Something went wrong');
                                                        }

                                                        if (snapshot2
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return const Text(
                                                              "Looking for dogs!");
                                                        }

                                                        return Flex(
                                                            direction:
                                                                Axis.vertical,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  IconButton(
                                                                    iconSize:
                                                                        50,
                                                                    icon:
                                                                        const Icon(
                                                                      color:
                                                                          mainColor,
                                                                      Icons
                                                                          .arrow_back_ios_new_rounded,
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      // Navigator.of(
                                                                      //         context)
                                                                      //     .pushReplacement(
                                                                      //   MaterialPageRoute(
                                                                      //     builder: (context) =>
                                                                      //         MyDogsGallery(user: _currentUser),
                                                                      //   ),
                                                                      // );
                                                                    },
                                                                  ),
                                                                  IconButton(
                                                                    iconSize:
                                                                        50,
                                                                    icon:
                                                                        const Icon(
                                                                      color:
                                                                          mainColor,
                                                                      Icons
                                                                          .chat_bubble_rounded,
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      // Navigator.of(
                                                                      //         context)
                                                                      //     .pushReplacement(
                                                                      //   MaterialPageRoute(
                                                                      //     builder: (context) =>
                                                                      //         MyDogsGallery(user: _currentUser),
                                                                      //   ),
                                                                      // );
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                width: double
                                                                    .infinity,
                                                                height: 25,
                                                              ),
                                                              Expanded(
                                                                child: GridView
                                                                    .builder(
                                                                  physics:
                                                                      const ScrollPhysics(),
                                                                  scrollDirection:
                                                                      Axis.vertical,
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemCount:
                                                                      snapshot2
                                                                          .data
                                                                          ?.docs
                                                                          .length,
                                                                  gridDelegate:
                                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                                    crossAxisCount:
                                                                        3,
                                                                    crossAxisSpacing:
                                                                        10.0,
                                                                    mainAxisSpacing:
                                                                        10,
                                                                  ),
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                              context,
                                                                          int index) {
                                                                    return Card(
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(20.0),
                                                                      ),
                                                                      elevation:
                                                                          10,
                                                                      margin:
                                                                          const EdgeInsets.all(
                                                                              8),
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(20),
                                                                        child:
                                                                            Stack(
                                                                          children: [
                                                                            GestureDetector(
                                                                              onLongPress: () {
                                                                                Navigator.of(context).pushReplacement(
                                                                                  MaterialPageRoute(
                                                                                    builder: (context) => AllDogs(
                                                                                      user: _currentUser,
                                                                                      dog: snapshot2.data?.docs[index],
                                                                                      oneDog: true,
                                                                                      myDogId: _currentDog!.id,
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              },
                                                                              child: Image.network(
                                                                                snapshot2.data?.docs[index]['image'],
                                                                                fit: BoxFit.cover,
                                                                                width: double.infinity,
                                                                                height: double.infinity,
                                                                              ),
                                                                            ),
                                                                            Positioned(
                                                                              left: 0,
                                                                              bottom: 0,
                                                                              child: Container(
                                                                                height: 20,
                                                                                width: 150,
                                                                                decoration: const BoxDecoration(
                                                                                    gradient: LinearGradient(
                                                                                  colors: [
                                                                                    Colors.black38,
                                                                                    Colors.black38,
                                                                                  ],
                                                                                  begin: Alignment.bottomCenter,
                                                                                  end: Alignment.topCenter,
                                                                                )),
                                                                              ),
                                                                            ),
                                                                            Positioned(
                                                                              left: 4,
                                                                              bottom: 5,
                                                                              child: Text(
                                                                                snapshot2.data?.docs[index]['name'],
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: double
                                                                    .infinity,
                                                                height: 25,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  IconButton(
                                                                    iconSize:
                                                                        50,
                                                                    icon:
                                                                        const Icon(
                                                                      color:
                                                                          mainColor,
                                                                      Icons
                                                                          .edit_rounded,
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      // Navigator.of(
                                                                      //         context)
                                                                      //     .pushReplacement(
                                                                      //   MaterialPageRoute(
                                                                      //     builder: (context) =>
                                                                      //         MyDogsGallery(
                                                                      //       user:
                                                                      //           _currentUser,
                                                                      //     ),
                                                                      //   ),
                                                                      // );
                                                                    },
                                                                  ),
                                                                  IconButton(
                                                                    iconSize:
                                                                        50,
                                                                    icon: const Icon(
                                                                        color:
                                                                            mainColor,
                                                                        Icons
                                                                            .people_alt_rounded),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pushReplacement(
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              AllDogs(
                                                                            user:
                                                                                _currentUser,
                                                                            dog:
                                                                                _currentDog,
                                                                            oneDog:
                                                                                false,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            ]);
                                                      },
                                                    ),
                                                  ),
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

                          /// bottom control row
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
