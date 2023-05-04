import 'dart:core';
import 'package:flutter/material.dart';
import 'package:matchdotdog/user/login_form.dart';
import 'package:matchdotdog/user/register_form.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late bool _selection;

  @override
  void initState() {
    super.initState();
    _selection = true; //true for Login form, false for Registration form
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
      ),
    );
  }
}
