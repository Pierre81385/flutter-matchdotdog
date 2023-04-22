import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matchdotdog/dogs/register_my_dog.dart';

import '../dogs/my_dogs_redirect.dart';
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginFormKey,
      child: Container(
        child: Column(children: [
          TextFormField(
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
          TextFormField(
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
                child: OutlinedButton(
                    onPressed: () async {
                      _focusLoginEmail.unfocus();
                      _focusLoginPassword.unfocus();

                      if (_loginFormKey.currentState!.validate()) {
                        setState(() {
                          _isProcessing = true;
                        });

                        User? user = await FireAuth.signInUsingEmailPassword(
                          email: _emailLoginTextController.text,
                          password: _passwordLoginTextController.text,
                        );

                        setState(() {
                          _isProcessing = false;
                        });

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

                          if (_owner != null) {
                            print('found owner:');
                            print(_owner);
                          } else {
                            print("No such document.");
                          }

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) =>
                                    RegisterMyDog(owner: _owner)
                                //MyDogsRedirect(user: user)
                                ),
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
    );
  }
}
