//the basic user registration functionality

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:matchdotdog/dogs/register_dog.dart';
import 'package:matchdotdog/user/login.dart';
import 'package:matchdotdog/ui/main_background.dart';
import './fire_auth.dart';
import './validators.dart';
import 'package:matchdotdog/location/location.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({super.key});

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final _registerFormKey = GlobalKey<FormState>();
  final _firstNameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _zipTextController = TextEditingController();

  final _focusFirstName = FocusNode();
  final _focusLastName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  final _focusZip = FocusNode();

  late Position userPosition;

  bool _isProcessing = false;
  bool _locationAuth = false;
  final firestoreInstance = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusFirstName.unfocus();
        _focusLastName.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
        _focusZip.unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            MainBackground(),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card(
                      color: Theme.of(context).canvasColor,
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
                          Stack(
                            children: [
                              Center(
                                child: Icon(
                                  Icons.supervised_user_circle_rounded,
                                  size: 110,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              Center(
                                child: Icon(
                                  Icons.supervised_user_circle_rounded,
                                  size: 100,
                                  color: Theme.of(context).splashColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const SizedBox(
                              width: 270,
                              child: Text(
                                "Join",
                                textAlign: TextAlign.center,
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              key: _registerFormKey,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: _firstNameTextController,
                                      focusNode: _focusFirstName,
                                      validator: (value) =>
                                          Validator.validateName(
                                        name: value,
                                      ),
                                      decoration: InputDecoration(
                                          labelText: 'First Name',
                                          fillColor: Colors.white,
                                          icon: Icon(Icons.person)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: _lastNameTextController,
                                      focusNode: _focusLastName,
                                      validator: (value) =>
                                          Validator.validateName(
                                        name: value,
                                      ),
                                      decoration: InputDecoration(
                                          labelText: 'Last Name',
                                          fillColor: Colors.white,
                                          icon: Icon(Icons.add)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: _emailTextController,
                                      focusNode: _focusEmail,
                                      validator: (value) =>
                                          Validator.validateEmail(
                                        email: value,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Email Address',
                                        fillColor: Colors.white,
                                        icon: Icon(Icons.email_rounded),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: _passwordTextController,
                                      focusNode: _focusPassword,
                                      obscureText: true,
                                      validator: (value) =>
                                          Validator.validatePassword(
                                        password: value,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Password',
                                        fillColor: Colors.white,
                                        icon: Icon(Icons.key_rounded),
                                      ),
                                    ),
                                  ),
                                  LocationPage(userPosition: (value) {
                                    userPosition = value;
                                    print(userPosition);
                                    setState(() {
                                      _locationAuth = true;
                                    });
                                  }),
                                  const SizedBox(height: 24.0),
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
                                                  'CANCEL',
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 24.0),
                                            Expanded(
                                              child: OutlinedButton(
                                                onPressed: _locationAuth
                                                    ? () async {
                                                        _focusFirstName
                                                            .unfocus();
                                                        _focusLastName
                                                            .unfocus();
                                                        _focusEmail.unfocus();
                                                        _focusPassword
                                                            .unfocus();

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
                                                            //create user in Firebase Auth
                                                            User? user =
                                                                await FireAuth
                                                                    .registerUsingEmailPassword(
                                                              name:
                                                                  '${_firstNameTextController.text} ${_lastNameTextController.text}',
                                                              email:
                                                                  _emailTextController
                                                                      .text,
                                                              password:
                                                                  _passwordTextController
                                                                      .text,
                                                            );

                                                            //create user in Firestore
                                                            firestoreInstance
                                                                .collection(
                                                                    "location")
                                                                .doc()
                                                                .set({
                                                              "user": user?.uid,
                                                              "lat":
                                                                  userPosition
                                                                      .latitude,
                                                              "long":
                                                                  userPosition
                                                                      .longitude,
                                                            });

                                                            setState(() {
                                                              _isProcessing =
                                                                  false;
                                                              _locationAuth =
                                                                  false;
                                                            });

                                                            if (user != null) {
                                                              print(
                                                                  'Sending user information to dog registration page!');
                                                              Navigator.of(
                                                                      context)
                                                                  .pushReplacement(
                                                                MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      RegisterDog(
                                                                          user:
                                                                              user),
                                                                ),
                                                              );
                                                            }
                                                          }
                                                        }
                                                      }
                                                    : null,
                                                child: const Text(
                                                  'REGISTER',
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
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
