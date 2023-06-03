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
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/mainWallpaper.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
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
        ),
      ),
    );
  }
}
