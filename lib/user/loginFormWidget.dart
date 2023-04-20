import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:matchdotdog/user/nLogin.dart';
import 'package:matchdotdog/user/registerFormWidget.dart';

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
            validator: (value) => Validator.validateEmail(
              email: value,
            ),
            decoration: InputDecoration(
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
                  child: Text("I\'m a new user"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(onPressed: () {}, child: Text('Login')),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
