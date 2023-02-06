import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matchdotdog/pages/login.dart';
import '../models/validators.dart';
import '../models/fire_auth.dart';

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

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
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
                TextFormField(
                  controller: _nameTextController,
                  focusNode: _focusName,
                  validator: (value) => Validator.validateName(
                    name: value,
                  ),
                  decoration: InputDecoration(hintText: 'Name'),
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
                                        .doc(_currentUser.uid)
                                        .set({
                                      "name": _nameTextController.text,
                                      "owner": _currentUser.displayName
                                    });

                                    setState(() {
                                      _isProcessing = false;
                                    });

                                    print('Dog successfully registered!');

                                    firestoreInstance
                                        .collection("dogs")
                                        .where("owner",
                                            isEqualTo: _currentUser.displayName)
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
