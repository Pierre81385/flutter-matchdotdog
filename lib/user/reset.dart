import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:matchdotdog/user/auth_page.dart';

import 'validators.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({super.key});

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final _emailTextController = TextEditingController();
  final _focusReset = FocusNode();
  bool _sent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _sent
              ? Text('Password reset sent to your email!')
              : Text('Need to reset your password?'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _emailTextController,
              focusNode: _focusReset,
              validator: (value) => Validator.validateEmail(
                email: value,
              ),
              decoration: const InputDecoration(
                labelText: 'Confirm Your Email address',
                fillColor: Colors.white,
                icon: Icon(Icons.mail),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => AuthPage()),
                    );
                  },
                  child: const Text("Back to Login"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => AuthPage()),
                    );
                  },
                  child: const Text("Send Reset"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
