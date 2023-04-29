import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matchdotdog/dogs/register_my_dog.dart';
import 'package:matchdotdog/dogs/xmy_dog.dart';
import 'package:matchdotdog/dogs/xmy_dogs_gallery.dart';
import 'package:matchdotdog/dogs/xregister_dog.dart';
import 'package:matchdotdog/home.dart';
import 'package:matchdotdog/models/owner_model.dart';
import 'package:matchdotdog/ui/main_background.dart';

import 'my_dogs.dart';

class MyDogsRedirect extends StatefulWidget {
  final Owner owner;

  const MyDogsRedirect({required this.owner});

  @override
  State<MyDogsRedirect> createState() => _MyDogsRedirectState();
}

class _MyDogsRedirectState extends State<MyDogsRedirect> {
  late Owner _currentOwner;

  @override
  void initState() {
    _currentOwner = widget.owner;
    super.initState();
  }

  Future loadDogs() async {
    return await FirebaseFirestore.instance
        .collection('dogs')
        .where('owner', isEqualTo: _currentOwner.uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadDogs(),
      builder: (context, snapshot) {
        if (snapshot.data?.docs.length == 0) {
          return RegisterMyDog(
            owner: _currentOwner,
            referrer: 'login',
          );
        }

        return HomePage(owner: _currentOwner);
      },
    );
  }
}
