//the basic user registration functionality

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matchdotdog/dogs/register_dog.dart';
import 'package:matchdotdog/location/location.dart';
import 'package:matchdotdog/user/login.dart';
import 'package:matchdotdog/main.dart';
import 'package:matchdotdog/ui/main_background.dart';
import 'package:matchdotdog/ui/paws.dart';
import './fire_auth.dart';
import './validators.dart';

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
  final _focusFirstName = FocusNode();
  final _focusLastName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  bool _isProcessing = false;
  final firestoreInstance = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusFirstName.unfocus();
        _focusLastName.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
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
                                  LocationPage(),
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
                                                onPressed: () async {
                                                  _focusFirstName.unfocus();
                                                  _focusLastName.unfocus();
                                                  _focusEmail.unfocus();
                                                  _focusPassword.unfocus();

                                                  if (_registerFormKey
                                                      .currentState!
                                                      .validate()) {
                                                    setState(() {
                                                      _isProcessing = true;
                                                    });

                                                    if (_registerFormKey
                                                        .currentState!
                                                        .validate()) {
                                                      User? user = await FireAuth
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

                                                      setState(() {
                                                        _isProcessing = false;
                                                      });

                                                      if (user != null) {
                                                        print(
                                                            'Sending user information to dog registration page!');
                                                        Navigator.of(context)
                                                            .pushReplacement(
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                RegisterDog(
                                                                    user: user),
                                                          ),
                                                        );
                                                      }
                                                    }
                                                  }
                                                },
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
