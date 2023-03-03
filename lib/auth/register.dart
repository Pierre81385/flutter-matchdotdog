//the basic user registration functionality

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matchdotdog/dogs/register_dog.dart';
import 'package:matchdotdog/auth/login.dart';
import 'package:matchdotdog/main.dart';
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
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          _focusFirstName.unfocus();
          _focusLastName.unfocus();
          _focusEmail.unfocus();
          _focusPassword.unfocus();
        },
        child: Scaffold(
          body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              border:
                  Border.all(color: Colors.white.withOpacity(0.2), width: 1.0),
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
                        Icon(
                          Icons.supervised_user_circle_rounded,
                          size: 100,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                            width: 270,
                            child: Text(
                              "Join",
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
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
