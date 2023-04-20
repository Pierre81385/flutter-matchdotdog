import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:matchdotdog/user/validators.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key, required this.onSelect});

  final ValueChanged<bool?> onSelect;

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _registrationFormKey = GlobalKey<FormState>();
  final _nameTextController = TextEditingController();
  final _emailRegisterTextController = TextEditingController();
  final _passwordRegisterTextController1 = TextEditingController();
  final _passwordRegisterTextController2 = TextEditingController();
  final _focusName = FocusNode();
  final _focusRegisterEmail = FocusNode();
  final _focusRegisterPassword1 = FocusNode();
  final _focusRegisterPassword2 = FocusNode();
  late final bool _selection = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _registrationFormKey,
      child: Column(children: [
        TextFormField(
          controller: _nameTextController,
          focusNode: _focusName,
          validator: (value) => Validator.validateName(
            name: value,
          ),
          decoration: const InputDecoration(
              labelText: 'User Name',
              fillColor: Colors.white,
              icon: Icon(Icons.add)),
        ),
        TextFormField(
          controller: _emailRegisterTextController,
          focusNode: _focusRegisterEmail,
          validator: (value) => Validator.validateEmail(
            email: value,
          ),
          decoration: const InputDecoration(
            labelText: 'Email',
            fillColor: Colors.white,
            icon: Icon(Icons.email),
          ),
        ),
        TextFormField(
          controller: _passwordRegisterTextController1,
          focusNode: _focusRegisterPassword1,
          validator: (value) => Validator.validateEmail(
            email: value,
          ),
          decoration: const InputDecoration(
            labelText: 'Password',
            fillColor: Colors.white,
            icon: Icon(Icons.key),
          ),
        ),
        TextFormField(
          controller: _passwordRegisterTextController2,
          focusNode: _focusRegisterPassword2,
          validator: (value) => Validator.validateEmail(
            email: value,
          ),
          decoration: const InputDecoration(
            labelText: 'Verify Password',
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
                child: Text("I already have an account."),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(onPressed: () {}, child: Text('Register')),
            ),
          ],
        ),
      ]),
    );
    ;
  }
}
