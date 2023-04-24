import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matchdotdog/unused/dog_model.dart';
import 'package:matchdotdog/dogs/xregister_dog.dart';
import 'package:matchdotdog/ui/main_background.dart';
import 'package:matchdotdog/unused/login.dart';
import 'package:matchdotdog/dogs/xmy_dog.dart';

import '../models/owner_model.dart';

class MyDogsGallery extends StatefulWidget {
  const MyDogsGallery({super.key, required this.owner});

  final Owner owner;

  @override
  State<MyDogsGallery> createState() => _MyDogsGalleryState();
}

class _MyDogsGalleryState extends State<MyDogsGallery> {
  late Owner _currentOwner;
  late Stream<QuerySnapshot> _myDogsStream;
  static const mainColor = Color.fromARGB(255, 94, 168, 172);
  static const secondaryColor = const Color(0xFFFBF7F4);
  static const accentColor = Color.fromARGB(255, 242, 202, 25);

  @override
  void initState() {
    _currentOwner = widget.owner;
    _myDogsStream = FirebaseFirestore.instance
        .collection('dogs')
        .where('owner', isEqualTo: _currentOwner.uid)
        .snapshots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        MainBackground(),
        StreamBuilder<QuerySnapshot>(
          stream: _myDogsStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
            if (snapshot2.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot2.connectionState == ConnectionState.waiting) {
              return const Text("Looking for dogs!");
            }
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        physics: const ScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot2.data?.docs.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 5,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onLongPress: () {
                              // Navigator.of(context).pushReplacement(
                              //   MaterialPageRoute(
                              //     builder: (context) => MyDog(
                              //       user: _currentOwner,
                              //       dog: snapshot2.data?.docs[index],
                              //     ),
                              //   ),
                              // );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              elevation: 10,
                              margin: const EdgeInsets.all(8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Stack(
                                  children: [
                                    Image.network(
                                      snapshot2.data?.docs[index]['photo'],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
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
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            iconSize: 50,
                            icon: const Icon(
                              color: mainColor,
                              Icons.arrow_back_ios_new_rounded,
                            ),
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            iconSize: 50,
                            icon: const Icon(
                              color: mainColor,
                              Icons.add_box_rounded,
                            ),
                            onPressed: () {
                              // Navigator.of(context).pushReplacement(
                              //   MaterialPageRoute(
                              //     builder: (context) => RegisterDog(
                              //       user: _currentUser,
                              //     ),
                              //   ),
                              // );
                            },
                          ),
                          IconButton(
                            iconSize: 50,
                            icon: const Icon(
                              color: mainColor,
                              Icons.chat_bubble_rounded,
                            ),
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ]),
    );
  }
}
