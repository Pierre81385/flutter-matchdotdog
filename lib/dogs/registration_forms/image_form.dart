import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:matchdotdog/home.dart';

import '../../models/owner_model.dart';
import '../../user/login.dart';
import '../my_dogs.dart';
import '../my_dogs_redirect.dart';
import 'dog_file_upload.dart';

class ImageForm extends StatefulWidget {
  const ImageForm(
      {super.key,
      required this.onSelect,
      required this.onSubmit,
      required this.onBack,
      required this.referrer,
      required this.owner});

  final ValueChanged<bool?> onSelect;
  final ValueChanged<String> onSubmit;
  final ValueChanged<bool?> onBack;
  final String referrer;
  final Owner owner;

  @override
  State<ImageForm> createState() => _ImageFormState();
}

class _ImageFormState extends State<ImageForm> {
  late String? _URL;
  late String _currentReferrer;
  late Owner _currentOwner;
  var buttonText;

  @override
  void initState() {
    super.initState();
    _URL = 'no image';
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
        DogImageUploads(
          onSelect: (value) {
            print(value);
            setState(() {
              _URL = value!;
            });
          },
        ),
        Text("Let's show everyone what your dog looks like!"),
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
            _URL == 'no image'
                ? OutlinedButton(
                    onPressed: () {}, child: Text('Image Required'))
                : OutlinedButton(
                    onPressed: () {
                      print(_URL);
                      widget.onSubmit(_URL!);
                      widget.onSelect(false);
                    },
                    child: Text('Next')),
          ],
        )
      ],
    );
  }
}
