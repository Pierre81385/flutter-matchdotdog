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
import '../details/my_dogs_details.dart';
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
  bool _showDetails = true;

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
    _showDetails = true;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Stack(
        alignment: Alignment.bottomCenter,
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
                _currentDog.photo,
                width: width,
                height: height * .9,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
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
                        ? MyDogsDetails(dog: _currentDog)
                        : Text(
                            _currentDog.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
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
                                    MaterialPageRoute(
                                        builder: (context) => AuthPage()),
                                  );
                                } else if (_currentReferrer == 'register') {
                                  //back to user registration
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => HomePage(
                                            owner: _currentOwner,
                                            referrer: 'dogRegistration')),
                                  );
                                } else {
                                  //back to my dogs
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MyDogs(owner: _currentOwner)),
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

                                  String id = firestoreInstance
                                      .collection("dogs")
                                      .doc()
                                      .id;

                                  firestoreInstance
                                      .collection("dogs")
                                      .doc(id)
                                      .set({
                                    "id": id,
                                    "owner": _currentDog.owner,
                                    "ownerLat": _currentOwner.locationLat,
                                    "ownerLong": _currentOwner.locationLong,
                                    "name": _currentDog.name,
                                    "photo": _currentDog.photo,
                                    "activity": _currentDog.activity,
                                    "age": _currentDog.age,
                                    "gender": _currentDog.gender,
                                    "size": _currentDog.size,
                                    "buddies": [],
                                    "description": _currentDog.description
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
                                        builder: (context) => HomePage(
                                            owner: _currentOwner,
                                            referrer: 'dogRegistration')),
                                  );
                                },
                                child: Text('Submit')),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
