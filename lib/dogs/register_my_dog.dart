import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:matchdotdog/dogs/activity_form.dart';
import 'package:matchdotdog/dogs/age_form.dart';
import 'package:matchdotdog/dogs/dog_summary.dart';
import 'package:matchdotdog/dogs/gender_form.dart';
import 'package:matchdotdog/dogs/image_form.dart';
import 'package:matchdotdog/dogs/name_form.dart';
import 'package:matchdotdog/dogs/size_form.dart';
import 'package:matchdotdog/models/dog_model.dart';
import 'package:matchdotdog/models/owner_model.dart';

class RegisterMyDog extends StatefulWidget {
  const RegisterMyDog({required this.owner});

  final Owner owner;

  @override
  State<RegisterMyDog> createState() => _RegisterMyDogState();
}

class _RegisterMyDogState extends State<RegisterMyDog> {
  late Owner _currentOwner;
  late Dog _currentDog;
  late bool _nameForm;
  late bool _genderForm;
  late bool _ageForm;
  late bool _sizeForm;
  late bool _activityForm;
  late bool _imageForm;
  late bool _summaryForm;

  @override
  void initState() {
    super.initState();

    _currentOwner = widget.owner;
    _currentDog = Dog(
        owner: _currentOwner.uid,
        photo: "",
        name: "",
        gender: 0,
        size: 0,
        activity: 0,
        age: 0);

    _nameForm = true;
    _genderForm = false;
    _ageForm = false;
    _sizeForm = false;
    _activityForm = false;
    _imageForm = false;
    _summaryForm = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _nameForm
              ? Text(_currentOwner.name + ', Tell us about your dog!')
              : Text(''),
          _nameForm
              ? NameForm(onSelect: (value) {
                  setState(() {
                    _nameForm = value!;
                    _genderForm = true;
                  });
                }, onSubmit: (value) {
                  setState(() {
                    _currentDog.name = value;
                  });
                })
              : _genderForm
                  ? GenderForm(onSelect: (value) {
                      setState(() {
                        _genderForm = value!;
                        _ageForm = true;
                      });
                    }, onSubmit: (value) {
                      setState(() {
                        _currentDog.gender = value;
                      });
                    })
                  : _ageForm
                      ? AgeForm(onSelect: (value) {
                          setState(() {
                            _ageForm = value!;
                            _sizeForm = true;
                          });
                        }, onSubmit: (value) {
                          setState(() {
                            _currentDog.age = value;
                          });
                        })
                      : _sizeForm
                          ? SizeForm(onSelect: (value) {
                              setState(() {
                                _sizeForm = value!;
                                _activityForm = true;
                              });
                            }, onSubmit: (value) {
                              setState(() {
                                _currentDog.size = value;
                              });
                            })
                          : _activityForm
                              ? ActivityForm(onSelect: (value) {
                                  setState(() {
                                    _activityForm = value!;
                                    _imageForm = true;
                                  });
                                }, onSubmit: (value) {
                                  setState(() {
                                    _currentDog.activity = value;
                                  });
                                })
                              : _imageForm
                                  ? ImageForm(onSelect: (value) {
                                      setState(() {
                                        _imageForm = value!;
                                        _summaryForm = true;
                                      });
                                    }, onSubmit: (value) {
                                      setState(() {
                                        _currentDog.photo = value;
                                      });
                                    })
                                  : DogSummary(
                                      onSelect: (value) {
                                        setState(() {
                                          _imageForm = value!;
                                        });
                                      },
                                      dog: _currentDog)
        ],
      ),
    );
  }
}
