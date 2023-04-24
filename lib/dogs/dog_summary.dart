import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:matchdotdog/dogs/my_dogs.dart';
import 'package:matchdotdog/dogs/xmy_dogs_gallery.dart';
import 'package:matchdotdog/unused/login.dart';

import '../models/dog_model.dart';
import '../models/owner_model.dart';

class DogSummary extends StatefulWidget {
  const DogSummary(
      {super.key,
      required this.owner,
      required this.dog,
      required this.onBack});

  final ValueChanged<bool?> onBack;
  final Dog dog;
  final Owner owner;

  @override
  State<DogSummary> createState() => _DogSummaryState();
}

class _DogSummaryState extends State<DogSummary> {
  late Owner _currentOwner;
  late Dog _currentDog;
  bool _isProcessing = false;
  final firestoreInstance = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _currentDog = widget.dog;
    _currentOwner = widget.owner;
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
            _isProcessing
                ? CircularProgressIndicator()
                : OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _isProcessing = true;
                      });

                      firestoreInstance.collection("dogs").doc().set({
                        "owner": _currentDog.owner,
                        "name": _currentDog.name,
                        "photo": _currentDog.photo,
                        "activity": _currentDog.activity,
                        "age": _currentDog.age,
                        "gender": _currentDog.gender,
                        "size": _currentDog.size,
                        "buddies": [],
                      });

                      setState(() {
                        _isProcessing = false;
                      });

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => MyDogs(owner: _currentOwner)),
                      );
                    },
                    child: Text('Submit')),
          ],
        )
      ],
    );
  }
}
