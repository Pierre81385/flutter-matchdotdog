import 'dart:core';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matchdotdog/auth/login.dart';
import 'package:matchdotdog/dogs/my_dogs.dart';
import 'package:matchdotdog/dogs/widgets/dog_file_upload.dart';
import '../auth/validators.dart';
import '../auth/fire_auth.dart';

class RegisterDog extends StatefulWidget {
  const RegisterDog({required this.user});

  final User user;

  @override
  State<RegisterDog> createState() => _RegisterDogState();
}

class _RegisterDogState extends State<RegisterDog> {
  final _registerFormKey = GlobalKey<FormState>();
  final _nameTextController = TextEditingController();
  final _focusName = FocusNode();
  bool _isProcessing = false;
  final firestoreInstance = FirebaseFirestore.instance;
  late User _currentUser;
  String? _avatarPhoto = 'no photo';
  int? _selectedGenderValue = 0;
  double _selectedAgeValue = 0;
  double _selectedSizeValue = 0;
  double _selectedActivityValue = 0;

  @override
  void initState() {
    super.initState();

    _currentUser = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusName.unfocus();
      },
      child: Scaffold(
          body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.0),
          gradient: const LinearGradient(
            colors: [Colors.amber, Colors.pink],
            stops: [0.0, 1.0],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      DogImageUploads(
                        onSelect: (value) {
                          _avatarPhoto = value;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                          width: 270,
                          child: Text(
                            "Tell everyone about your dog!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: _registerFormKey,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: _nameTextController,
                                  focusNode: _focusName,
                                  validator: (value) => Validator.validateName(
                                    name: value,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Name',
                                    fillColor: Colors.white,
                                    icon: Icon(Icons.pets_rounded),
                                  ),
                                ),
                              ),
                              //gender drop down

                              const SizedBox(width: 24.0),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButton(
                                    isExpanded: true,
                                    value: _selectedGenderValue,
                                    items: const [
                                      DropdownMenuItem(
                                        child: Text("select gender"),
                                        value: 0,
                                      ),
                                      DropdownMenuItem(
                                        child: Text("Male"),
                                        value: 1,
                                      ),
                                      DropdownMenuItem(
                                        child: Text("Female"),
                                        value: 2,
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedGenderValue = value;
                                      });
                                    }),
                              ),

                              const SizedBox(width: 24.0),

                              Text(
                                  'Age ${_selectedAgeValue.round().toString()}'),
                              Slider(
                                  //label: _selectedAgeValue.toString(),
                                  min: 0,
                                  max: 25,
                                  divisions: 25,
                                  value: _selectedAgeValue,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedAgeValue = value;
                                    });
                                  }),

                              const SizedBox(width: 24.0),

                              Text(
                                  'Size ${_selectedSizeValue.round().toString()}'),
                              Slider(
                                  //label: _selectedAgeValue.toString(),
                                  min: 0,
                                  max: 25,
                                  divisions: 25,
                                  value: _selectedSizeValue,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedSizeValue = value;
                                    });
                                  }),

                              const SizedBox(width: 24.0),

                              Text(
                                  'Activity LVL ${_selectedActivityValue.round().toString()}'),
                              Slider(
                                  //label: _selectedAgeValue.toString(),
                                  min: 0,
                                  max: 25,
                                  divisions: 25,
                                  value: _selectedActivityValue,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedActivityValue = value;
                                    });
                                  }),

                              const SizedBox(width: 24.0),

                              _isProcessing
                                  ? const CircularProgressIndicator()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: () {
                                              print(
                                                  'Take user back to Home page');
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginPage(),
                                                ),
                                              );
                                            },
                                            child: const Text(
                                              'Cancel',
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 24.0),
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: () async {
                                              _focusName.unfocus();

                                              if (_registerFormKey.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  _isProcessing = true;
                                                });

                                                if (_registerFormKey
                                                    .currentState!
                                                    .validate()) {
                                                  //save dog to FireStore
                                                  firestoreInstance
                                                      .collection("dogs")
                                                      .doc()
                                                      .set({
                                                    "name": _nameTextController
                                                        .text,
                                                    "image": _avatarPhoto,
                                                    "owner": _currentUser.uid,
                                                    "gender":
                                                        _selectedGenderValue,
                                                    "age": _selectedAgeValue,
                                                    "size": _selectedSizeValue,
                                                    "activity":
                                                        _selectedActivityValue
                                                  });

                                                  setState(() {
                                                    _isProcessing = false;
                                                  });

                                                  print(
                                                      'Dog successfully registered!');

                                                  firestoreInstance
                                                      .collection("dogs")
                                                      .where("owner",
                                                          isEqualTo:
                                                              _currentUser.uid)
                                                      .get()
                                                      .then(
                                                        (res) => print(
                                                            'successfully found ${res.toString()}'),
                                                        onError: (e) => print(
                                                            "Error completing: $e"),
                                                      );

                                                  // if (user != null) {

                                                  //   Navigator.of(context).pushReplacement(
                                                  //     MaterialPageRoute(
                                                  //       builder: (context) =>
                                                  //           ProfilePage(user: user),
                                                  //     ),
                                                  //   );
                                                  // }
                                                }
                                              }
                                            },
                                            child: const Text(
                                              'Add',
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 24.0),
                                        Expanded(
                                            child: OutlinedButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MyDogs(user: _currentUser),
                                              ),
                                            );
                                          },
                                          child: const Text('Review'),
                                        ))
                                      ],
                                    )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      )),
    );
  }
}
