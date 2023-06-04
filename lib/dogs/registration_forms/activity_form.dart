import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:matchdotdog/dogs/my_dogs.dart';
import 'package:matchdotdog/user/home.dart';
import 'package:matchdotdog/models/owner_model.dart';
import 'package:matchdotdog/unused/login.dart';
import 'package:matchdotdog/user/auth_page.dart';

import '../my_dogs_redirect.dart';

class ActivityForm extends StatefulWidget {
  const ActivityForm(
      {super.key,
      required this.onSelect,
      required this.onSubmit,
      required this.onBack,
      required this.referrer,
      required this.owner});

  final ValueChanged<bool?> onSelect;
  final ValueChanged<double> onSubmit;
  final ValueChanged<bool?> onBack;
  final String referrer;
  final Owner owner;

  @override
  State<ActivityForm> createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  double _selectedActivityValue = 0;
  late String _currentReferrer;
  late Owner _currentOwner;
  var buttonText;

  @override
  void initState() {
    super.initState();
    _currentOwner = widget.owner;
    _currentReferrer = widget.referrer;
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('How big active your dog?'),
        _selectedActivityValue <= 5
            ? Text('and very laid back.')
            : _selectedActivityValue > 5 && _selectedActivityValue <= 10
                ? Text('and curious but chill.')
                : _selectedActivityValue > 10 && _selectedActivityValue <= 15
                    ? Text('and playful!')
                    : _selectedActivityValue > 15 &&
                            _selectedActivityValue <= 20
                        ? Text('with puppy energy!')
                        : _selectedActivityValue > 20 &&
                                _selectedActivityValue <= 24
                            ? Text('and hyper-active!')
                            : Text('and agressively hyper-active!'),
        Slider(
            //label: _selectedAgeValue.toString(),
            min: 0,
            max: 25,
            divisions: 25,
            value: _selectedActivityValue,
            onChanged: (value) {
              setState(() {
                _selectedActivityValue = value;
              });
            }),
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
                            builder: (context) => HomePage(
                                  owner: _currentOwner,
                                  referrer: 'dogRegistration',
                                )),
                      );
                    }
                  },
                  child: Text(buttonText)),
            ),
            OutlinedButton(
                onPressed: () {
                  widget.onSubmit(_selectedActivityValue);
                  widget.onSelect(false);
                },
                child: Text('Next')),
          ],
        )
      ],
    );
  }
}
