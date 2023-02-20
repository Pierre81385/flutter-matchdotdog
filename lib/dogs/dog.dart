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
  int? _selectedAgeValue = 0;
  int? _selectedSizeValue = 0;
  int? _selectedActivityValue = 0;

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
        body: Form(
          key: _registerFormKey,
          child: SafeArea(
            child: Column(
              children: [
                DogImageUploads(
                  onSelect: (value) {
                    _avatarPhoto = value;
                  },
                ),
                TextFormField(
                  controller: _nameTextController,
                  focusNode: _focusName,
                  validator: (value) => Validator.validateName(
                    name: value,
                  ),
                  decoration: InputDecoration(hintText: 'Name'),
                ),
                //gender drop down
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: DropdownButton(
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

                    //age drop down
                    Expanded(
                      child: DropdownButton(
                          value: _selectedAgeValue,
                          items: const [
                            DropdownMenuItem(
                              child: Text("select age"),
                              value: 0,
                            ),
                            DropdownMenuItem(
                              child: Text("0-2 yrs"),
                              value: 1,
                            ),
                            DropdownMenuItem(
                              child: Text("2-5 yrs"),
                              value: 2,
                            ),
                            DropdownMenuItem(
                              child: Text("5-10 yrs"),
                              value: 3,
                            ),
                            DropdownMenuItem(
                              child: Text("10+ yrs"),
                              value: 4,
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedAgeValue = value;
                            });
                          }),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: DropdownButton(
                          value: _selectedSizeValue,
                          items: const [
                            DropdownMenuItem(
                              child: Text("select size"),
                              value: 0,
                            ),
                            DropdownMenuItem(
                              child: Text("Extra Small"),
                              value: 1,
                            ),
                            DropdownMenuItem(
                              child: Text("Small"),
                              value: 2,
                            ),
                            DropdownMenuItem(
                              child: Text("Medium"),
                              value: 3,
                            ),
                            DropdownMenuItem(
                              child: Text("Large"),
                              value: 4,
                            ),
                            DropdownMenuItem(
                              child: Text("Extra Large"),
                              value: 5,
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedSizeValue = value;
                            });
                          }),
                    ),
                    const SizedBox(width: 24.0),

                    //age drop down
                    Expanded(
                      child: DropdownButton(
                          value: _selectedActivityValue,
                          items: const [
                            DropdownMenuItem(
                              child: Text("select play style"),
                              value: 0,
                            ),
                            DropdownMenuItem(
                              child: Text("Lounger"),
                              value: 1,
                            ),
                            DropdownMenuItem(
                              child: Text("Kid Gloves"),
                              value: 2,
                            ),
                            DropdownMenuItem(
                              child: Text("Active"),
                              value: 3,
                            ),
                            DropdownMenuItem(
                              child: Text("Agressive"),
                              value: 4,
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedActivityValue = value;
                            });
                          }),
                    ),
                  ],
                ),

                _isProcessing
                    ? const CircularProgressIndicator()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                print('Take user back to Home page');
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
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

                                if (_registerFormKey.currentState!.validate()) {
                                  setState(() {
                                    _isProcessing = true;
                                  });

                                  if (_registerFormKey.currentState!
                                      .validate()) {
                                    //save dog to FireStore
                                    firestoreInstance
                                        .collection("dogs")
                                        .doc()
                                        .set({
                                      "name": _nameTextController.text,
                                      "image": _avatarPhoto,
                                      "owner": _currentUser.uid,
                                      "gender": _selectedGenderValue,
                                      "age": _selectedAgeValue,
                                      "size": _selectedSizeValue,
                                      "activity": _selectedActivityValue
                                    });

                                    setState(() {
                                      _isProcessing = false;
                                    });

                                    print('Dog successfully registered!');

                                    firestoreInstance
                                        .collection("dogs")
                                        .where("owner",
                                            isEqualTo: _currentUser.uid)
                                        .get()
                                        .then(
                                          (res) => print(
                                              'successfully found ${res.toString()}'),
                                          onError: (e) =>
                                              print("Error completing: $e"),
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
                              Navigator.of(context).pushReplacement(
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
      ),
    );
  }
}
