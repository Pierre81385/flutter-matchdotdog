//the basic user registration functionality

import 'package:flutter/material.dart';
import '../models/owner.dart';
import '../models/validators.dart';

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
  final _verifyPasswordTextController = TextEditingController();
  late Owner _owner;

  void setOwner() {
    _owner.name =
        '${_firstNameTextController.text} ${_lastNameTextController.text}';
    _owner.email = _emailTextController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _registerFormKey,
      child: SafeArea(
        child: Column(
          children: [
            TextFormField(
              controller: _firstNameTextController,
              validator: (value) => Validator.validateName(
                name: value,
              ),
              decoration: InputDecoration(hintText: 'First Name'),
            ),
            TextFormField(
              controller: _lastNameTextController,
              validator: (value) => Validator.validateName(
                name: value,
              ),
              decoration: InputDecoration(hintText: 'Last Name'),
            ),
            TextFormField(
              controller: _emailTextController,
              validator: (value) => Validator.validateEmail(
                email: value,
              ),
              decoration: InputDecoration(hintText: 'Email Address'),
            ),
            TextFormField(
              controller: _passwordTextController,
              validator: (value) => Validator.validatePassword(
                password: value,
              ),
              decoration: InputDecoration(hintText: 'Password'),
            ),
          ],
        ),
      ),
    );
  }
}
