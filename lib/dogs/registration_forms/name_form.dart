import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:matchdotdog/user/home.dart';

import '../../models/owner_model.dart';
import '../../user/auth_page.dart';
import '../../user/validators.dart';
import '../my_dogs.dart';
import '../my_dogs_redirect.dart';

class NameForm extends StatefulWidget {
  const NameForm(
      {super.key,
      required this.onSelect,
      required this.onSubmit,
      required this.referrer,
      required this.owner});

  final ValueChanged<bool?> onSelect;
  final ValueChanged<String> onSubmit;
  final String referrer;
  final Owner owner;

  @override
  State<NameForm> createState() => _NameFormState();
}

class _NameFormState extends State<NameForm> {
  final _nameRegisterTextController = TextEditingController();
  final _focusRegisterName = FocusNode();
  late String _currentReferrer;
  late Owner _currentOwner;
  var buttonText;

  @override
  void initState() {
    super.initState();
    _currentReferrer = widget.referrer;
    _currentOwner = widget.owner;
    if (_currentReferrer == 'login') {
      //logout
      buttonText = 'Logout';
    } else if (_currentReferrer == 'register') {
      //back to user registration
      buttonText = 'Finish Later';
    } else {
      //back to my dogs
      buttonText = 'Cancel';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("What's your dog's name?"),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            child: TextFormField(
              controller: _nameRegisterTextController,
              focusNode: _focusRegisterName,
              validator: (value) => Validator.validateName(
                name: value,
              ),
              decoration: const InputDecoration(
                  labelText: 'ex. Fido',
                  fillColor: Colors.white,
                  icon: Icon(Icons.add)),
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
                    if (_currentReferrer == 'login') {
                      //logout
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => AuthPage()),
                      );
                    } else if (_currentReferrer == 'register') {
                      //back to user registration
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) =>
                                MyDogsRedirect(owner: _currentOwner)),
                      );
                    } else {
                      //back to my dogs
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) =>
                                HomePage(owner: _currentOwner)),
                      );
                    }
                  },
                  child: Text(buttonText)),
            ),
            OutlinedButton(
                onPressed: () {
                  widget.onSubmit(_nameRegisterTextController.text);
                  widget.onSelect(false);
                },
                child: Text('Next')),
          ],
        )
      ],
    );
  }
}
