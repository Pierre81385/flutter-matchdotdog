import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:matchdotdog/user/home.dart';

import '../../models/owner_model.dart';
import '../../user/auth_page.dart';
import '../my_dogs.dart';
import '../my_dogs_redirect.dart';

class GenderForm extends StatefulWidget {
  const GenderForm(
      {super.key,
      required this.onSelect,
      required this.onSubmit,
      required this.onBack,
      required this.referrer,
      required this.owner});

  final ValueChanged<bool?> onSelect;
  final ValueChanged<int> onSubmit;
  final ValueChanged<bool?> onBack;
  final String referrer;
  final Owner owner;

  @override
  State<GenderForm> createState() => _GenderFormState();
}

class _GenderFormState extends State<GenderForm> {
  int _selectedGenderValue = 0;
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
        const Text("Is your dog a boy or girl? "),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton(
              isExpanded: true,
              value: _selectedGenderValue,
              items: const [
                DropdownMenuItem(
                  value: 0,
                  child: Text(
                    "select gender",
                    textAlign: TextAlign.center,
                  ),
                ),
                DropdownMenuItem(
                  value: 1,
                  child: Text(
                    "Male",
                    textAlign: TextAlign.center,
                  ),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text(
                    "Female",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedGenderValue = value!;
                });
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  widget.onBack(true);
                },
                icon: Icon(Icons.arrow_back_ios)),
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
                  widget.onSubmit(_selectedGenderValue);
                  widget.onSelect(false);
                },
                child: Text('Next')),
          ],
        )
      ],
    );
    ;
  }
}
