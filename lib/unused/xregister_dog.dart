import 'dart:core';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:matchdotdog/unused/xmy_dogs_gallery.dart';
import 'package:matchdotdog/unused/login.dart';
import 'package:matchdotdog/unused/xmy_dog.dart';
import 'package:matchdotdog/ui/main_background.dart';
import 'package:matchdotdog/ui/paws.dart';
import 'location.dart';
import '../user/auth_page.dart';
import '../user/validators.dart';
import '../user/fire_auth.dart';
import '../dogs/registration_forms/dog_file_upload.dart';
//import './dog_model.dart';

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
  late Position _userPosition;
  bool _locationAuth = false;

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
        body: Stack(
          children: [
            const MainBackground(),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 10,
                        margin: const EdgeInsets.all(8),
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
                              ),
                            ),
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
                                        validator: (value) =>
                                            Validator.validateName(
                                          name: value,
                                        ),
                                        decoration: const InputDecoration(
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
                                              value: 0,
                                              child: Text(
                                                "select gender",
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            DropdownMenuItem(
                                              value: 1,
                                              child: Text(
                                                "Male",
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            DropdownMenuItem(
                                              value: 2,
                                              child: Text(
                                                "Female",
                                                textAlign: TextAlign.center,
                                              ),
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
                                    LocationPage(userPosition: (value) {
                                      _userPosition = value;
                                      print(_userPosition);
                                      setState(() {
                                        _locationAuth = true;
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
                                                            const AuthPage(),
                                                      ),
                                                    );
                                                  },
                                                  child: const Text(
                                                    'Cancel',
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 48.0),
                                              Expanded(
                                                child: OutlinedButton(
                                                  onPressed: _locationAuth
                                                      ? () async {
                                                          _focusName.unfocus();

                                                          if (_registerFormKey
                                                              .currentState!
                                                              .validate()) {
                                                            setState(() {
                                                              _isProcessing =
                                                                  true;
                                                            });

                                                            if (_registerFormKey
                                                                .currentState!
                                                                .validate()) {
                                                              //save dog to FireStore
                                                              firestoreInstance
                                                                  .collection(
                                                                      "dogs")
                                                                  .doc()
                                                                  .set({
                                                                "name":
                                                                    _nameTextController
                                                                        .text,
                                                                "image":
                                                                    _avatarPhoto,
                                                                "owner":
                                                                    _currentUser
                                                                        .uid,
                                                                "gender":
                                                                    _selectedGenderValue,
                                                                "age":
                                                                    _selectedAgeValue,
                                                                "size":
                                                                    _selectedSizeValue,
                                                                "activity":
                                                                    _selectedActivityValue,
                                                                'liked': FieldValue
                                                                    .arrayUnion(
                                                                        [null]),
                                                                'lat':
                                                                    _userPosition
                                                                        .latitude,
                                                                'long':
                                                                    _userPosition
                                                                        .longitude
                                                              });

                                                              setState(() {
                                                                _isProcessing =
                                                                    false;
                                                              });

                                                              print(
                                                                  'Dog successfully registered!');

                                                              firestoreInstance
                                                                  .collection(
                                                                      "dogs")
                                                                  .where(
                                                                      "owner",
                                                                      isEqualTo:
                                                                          _currentUser
                                                                              .uid)
                                                                  .get()
                                                                  .then(
                                                                    (res) => print(
                                                                        'successfully found ${res.toString()}'),
                                                                    onError: (e) =>
                                                                        print(
                                                                            "Error completing: $e"),
                                                                  );

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
                                                            }
                                                          }
                                                        }
                                                      : null,
                                                  child: const Text(
                                                    'Add',
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12.0),
                                              Expanded(
                                                  child: OutlinedButton(
                                                onPressed: () {
                                                  // Navigator.of(context)
                                                  //     .pushReplacement(
                                                  //   MaterialPageRoute(
                                                  //     builder: (context) =>
                                                  //         MyDogsGallery(
                                                  //             user:
                                                  //                 _currentUser),
                                                  //   ),
                                                  // );
                                                },
                                                child: const Text('Skip'),
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
            ),
          ],
        ),
      ),
    );
  }
}
