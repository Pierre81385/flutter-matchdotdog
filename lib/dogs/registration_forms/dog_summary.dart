import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:matchdotdog/dogs/my_dogs.dart';
import 'package:matchdotdog/unused/xmy_dogs_gallery.dart';
import 'package:matchdotdog/user/home.dart';
import 'package:matchdotdog/unused/login.dart';

import '../../models/dog_model.dart';
import '../../models/owner_model.dart';
import '../../user/auth_page.dart';
import '../my_dogs_redirect.dart';

class DogSummary extends StatefulWidget {
  const DogSummary(
      {super.key,
      required this.owner,
      required this.dog,
      required this.onBack,
      required this.referrer});

  final ValueChanged<bool?> onBack;
  final Dog dog;
  final Owner owner;
  final String referrer;

  @override
  State<DogSummary> createState() => _DogSummaryState();
}

class _DogSummaryState extends State<DogSummary> {
  late Owner _currentOwner;
  late Dog _currentDog;
  late String _currentReferrer;
  bool _isProcessing = false;
  final firestoreInstance = FirebaseFirestore.instance;
  var buttonText;

  @override
  void initState() {
    super.initState();
    _currentDog = widget.dog;
    _currentOwner = widget.owner;
    _currentReferrer = widget.referrer;
    if (_currentReferrer == 'login') {
      //logout
      buttonText = 'Logout';
    } else if (_currentReferrer == 'register') {
      //back to user registration
      buttonText = 'Finish Later';
    } else {
      //back to my dogs
      buttonText = 'Cancel';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(_currentDog.owner),
        Text(_currentDog.name),
        Text(_currentDog.photo),
        Text(_currentDog.activity.toString()),
        Text(_currentDog.age.toString()),
        Text(_currentDog.gender.toString()),
        Text(_currentDog.size.toString()),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  widget.onBack(true);
                },
                icon: Icon(Icons.arrow_back_ios)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                  onPressed: () {
                    if (_currentReferrer == 'login') {
                      //logout
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => AuthPage()),
                      );
                    } else if (_currentReferrer == 'register') {
                      //back to user registration
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) =>
                                HomePage(owner: _currentOwner)),
                      );
                    } else {
                      //back to my dogs
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => MyDogs(owner: _currentOwner)),
                      );
                    }
                  },
                  child: Text(buttonText)),
            ),
            _isProcessing
                ? CircularProgressIndicator()
                : OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _isProcessing = true;
                      });

                      String id =
                          firestoreInstance.collection("users").doc().id;

                      firestoreInstance.collection("dogs").doc(id).set({
                        "owner": _currentDog.owner,
                        "name": _currentDog.name,
                        "photo": _currentDog.photo,
                        "activity": _currentDog.activity,
                        "age": _currentDog.age,
                        "gender": _currentDog.gender,
                        "size": _currentDog.size,
                        "buddies": [],
                      });

                      firestoreInstance
                          .collection('owners')
                          .doc(_currentOwner.uid)
                          .update({
                        "dogs": FieldValue.arrayUnion([id])
                      });

                      setState(() {
                        _isProcessing = false;
                      });

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) =>
                                HomePage(owner: _currentOwner)),
                      );
                    },
                    child: Text('Submit')),
          ],
        )
      ],
    );
  }
}
