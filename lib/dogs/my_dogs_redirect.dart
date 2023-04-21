import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matchdotdog/dogs/my_dog.dart';
import 'package:matchdotdog/dogs/my_dogs_gallery.dart';
import 'package:matchdotdog/dogs/register_dog.dart';
import 'package:matchdotdog/ui/main_background.dart';

class MyDogsRedirect extends StatefulWidget {
  final User user;

  const MyDogsRedirect({required this.user});

  @override
  State<MyDogsRedirect> createState() => _MyDogsRedirectState();
}

class _MyDogsRedirectState extends State<MyDogsRedirect> {
  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  Future loadDogs() async {
    return await FirebaseFirestore.instance
        .collection('dogs')
        .where('owner', isEqualTo: _currentUser.uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadDogs(),
      builder: (context, snapshot) {
        if (snapshot.data?.docs.length == 0) {
          return RegisterDog(user: _currentUser);
        }

        return MyDogsGallery(user: _currentUser);
      },
    );
  }
}
