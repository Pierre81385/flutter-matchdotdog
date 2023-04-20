import 'dart:core';

import 'package:flutter/material.dart';
import 'package:matchdotdog/user/loginFormWidget.dart';
import 'package:matchdotdog/user/registerFormWidget.dart';

//page should scroll horizontally between login (left side) and signup (right side)
//background will have a picture with two dogs, facing each other, with 1 dog on either side

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late bool _selection;

  @override
  void initState() {
    _selection = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: _selection == true
              ? LoginForm(
                  onSelect: (value) {
                    setState(() {
                      _selection = value!;
                    });
                  },
                )
              : RegistrationForm(
                  onSelect: (value) {
                    setState(() {
                      _selection = value!;
                    });
                  },
                ),
        ),
      ],
    ));
    //login
    //email
    //password
    //forgot password

    //register
    //avatar
    //email
    //phone number
    //address
    //password
    //password verification
  }
}
