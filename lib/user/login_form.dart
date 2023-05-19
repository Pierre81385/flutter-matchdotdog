import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:matchdotdog/dogs/my_dogs_redirect.dart';
import 'package:matchdotdog/dogs/register_my_dog.dart';
import 'package:matchdotdog/user/reset.dart';

import '../models/owner_model.dart';
import 'fire_auth.dart';
import 'validators.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key, required this.onSelect});

  final ValueChanged<bool?> onSelect;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _loginFormKey = GlobalKey<FormState>();
  final _emailLoginTextController = TextEditingController();
  final _passwordLoginTextController = TextEditingController();
  final _focusLoginEmail = FocusNode();
  final _focusLoginPassword = FocusNode();
  late final bool _selection = false;
  bool _isProcessing = false;
  late Future<QuerySnapshot<Owner>> _ownerDoc;
  late Owner _owner;
  final firestoreInstance = FirebaseFirestore.instance;
  late Position _userPosition;
  bool _locationAuth = false;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      print('getting user location: ' + position.toString());
      setState(() {
        _userPosition = position;
        _owner.locationLat = _userPosition.latitude;
        _owner.locationLong = _userPosition.longitude;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Form(
        key: _loginFormKey,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _emailLoginTextController,
                          focusNode: _focusLoginEmail,
                          validator: (value) => Validator.validateEmail(
                            email: value,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            fillColor: Colors.white,
                            icon: Icon(Icons.email),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 25),
                        child: TextFormField(
                          controller: _passwordLoginTextController,
                          focusNode: _focusLoginPassword,
                          validator: (value) => Validator.validatePassword(
                            password: value,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            fillColor: Colors.white,
                            icon: Icon(Icons.key),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => PasswordReset()),
                    );
                  },
                  child: Text('I forgot my password.')),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton(
                      onPressed: () {
                        widget.onSelect(_selection);
                      },
                      child: const Text("I'm a new user"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _isProcessing
                        ? CircularProgressIndicator()
                        : OutlinedButton(
                            onPressed: () async {
                              setState(() {
                                _isProcessing = true;
                              });

                              _focusLoginEmail.unfocus();
                              _focusLoginPassword.unfocus();

                              if (_loginFormKey.currentState!.validate()) {
                                setState(() {
                                  _isProcessing = true;
                                });

                                User? user =
                                    await FireAuth.signInUsingEmailPassword(
                                  email: _emailLoginTextController.text,
                                  password: _passwordLoginTextController.text,
                                );

                                if (user != null) {
                                  print("User is successfully logged in!");

                                  final ref = firestoreInstance
                                      .collection("owners")
                                      .doc(user.uid)
                                      .withConverter(
                                        fromFirestore: Owner.fromFirestore,
                                        toFirestore: (Owner owner, _) =>
                                            owner.toFirestore(),
                                      );

                                  final docSnap = await ref.get();

                                  _owner = docSnap.data()!;

                                  _getCurrentPosition();

                                  FirebaseFirestore.instance
                                      .collection('owners')
                                      .doc(_owner.uid)
                                      .update({
                                    'locationLat': _owner.locationLat,
                                    'locationLong': _owner.locationLong
                                  });

                                  print(
                                      'owner doc updated with current position!');

                                  if (_owner.dogs.length > 0) {
                                    for (var i = 0;
                                        i < _owner.dogs.length;
                                        i++) {
                                      FirebaseFirestore.instance
                                          .collection('dogs')
                                          .doc(_owner.dogs[i])
                                          .update({
                                        'ownerLat': _owner.locationLat,
                                        'ownerLong': _owner.locationLong
                                      });
                                    }

                                    print(
                                        'dog doc updated with current position!');
                                  }

                                  if (_owner != null) {
                                    print('found owner:');
                                    print(_owner);
                                  } else {
                                    print("No such document.");
                                  }

                                  setState(() {
                                    _isProcessing = false;
                                  });

                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MyDogsRedirect(owner: _owner)),
                                  );
                                }
                              }
                            },
                            child: Text('Login')),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
