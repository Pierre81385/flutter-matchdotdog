//the basic user registration functionality

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matchdotdog/pages/dog.dart';
import 'package:matchdotdog/pages/login.dart';
import '../models/validators.dart';
import '../models/fire_auth.dart';

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
        body: Form(
          key: _registerFormKey,
          child: SafeArea(
            child: Column(
              children: [
                TextFormField(
                  controller: _firstNameTextController,
                  focusNode: _focusFirstName,
                  validator: (value) => Validator.validateName(
                    name: value,
                  ),
                  decoration: InputDecoration(hintText: 'First Name'),
                ),
                TextFormField(
                  controller: _lastNameTextController,
                  focusNode: _focusLastName,
                  validator: (value) => Validator.validateName(
                    name: value,
                  ),
                  decoration: InputDecoration(hintText: 'Last Name'),
                ),
                TextFormField(
                  controller: _emailTextController,
                  focusNode: _focusEmail,
                  validator: (value) => Validator.validateEmail(
                    email: value,
                  ),
                  decoration: InputDecoration(hintText: 'Email Address'),
                ),
                TextFormField(
                  controller: _passwordTextController,
                  focusNode: _focusPassword,
                  validator: (value) => Validator.validatePassword(
                    password: value,
                  ),
                  decoration: InputDecoration(hintText: 'Password'),
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
                                _focusFirstName.unfocus();
                                _focusLastName.unfocus();
                                _focusEmail.unfocus();
                                _focusPassword.unfocus();

                                if (_registerFormKey.currentState!.validate()) {
                                  setState(() {
                                    _isProcessing = true;
                                  });

                                  if (_registerFormKey.currentState!
                                      .validate()) {
                                    User? user = await FireAuth
                                        .registerUsingEmailPassword(
                                      name:
                                          '${_firstNameTextController.text} ${_lastNameTextController.text}',
                                      email: _emailTextController.text,
                                      password: _passwordTextController.text,
                                    );

                                    setState(() {
                                      _isProcessing = false;
                                    });

                                    if (user != null) {
                                      print(
                                          'Sending user information to dog registration page!');
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterDog(user: user),
                                        ),
                                      );
                                    }
                                  }
                                }
                              },
                              child: const Text(
                                'Register',
                              ),
                            ),
                          ),
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
