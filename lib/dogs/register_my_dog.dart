import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../models/dog_model.dart';
import '../models/owner_model.dart';
import 'registration_forms/activity_form.dart';
import 'registration_forms/age_form.dart';
import 'registration_forms/dog_summary.dart';
import 'registration_forms/gender_form.dart';
import 'registration_forms/image_form.dart';
import 'registration_forms/name_form.dart';
import 'registration_forms/size_form.dart';

class RegisterMyDog extends StatefulWidget {
  const RegisterMyDog({super.key, required this.owner});

  final Owner owner;

  @override
  State<RegisterMyDog> createState() => _RegisterMyDogState();
}

class _RegisterMyDogState extends State<RegisterMyDog> {
  late Owner _currentOwner;
  late Dog _currentDog = Dog(
      owner: _currentOwner.uid,
      photo: "",
      name: "",
      gender: 0,
      size: 0,
      activity: 0,
      age: 0,
      buddies: []);
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
        age: 0,
        buddies: []);

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
              ? NameForm(onSelect: (value) {
                  setState(() {
                    _nameForm = value!;
                    _genderForm = true;
                  });
                }, onSubmit: (value) {
                  setState(() {
                    _currentDog.name = value;
                    print(_currentDog.name);
                  });
                })
              : _genderForm
                  ? GenderForm(
                      onSelect: (value) {
                        setState(() {
                          _genderForm = value!;
                          _ageForm = true;
                        });
                      },
                      onSubmit: (value) {
                        setState(() {
                          _currentDog.gender = value;
                        });
                      },
                      onBack: (value) {
                        setState(() {
                          _nameForm = value!;
                        });
                      },
                    )
                  : _ageForm
                      ? AgeForm(
                          onSelect: (value) {
                            setState(() {
                              _ageForm = value!;
                              _sizeForm = true;
                            });
                          },
                          onSubmit: (value) {
                            setState(() {
                              _currentDog.age = value;
                            });
                          },
                          onBack: (value) {
                            setState(() {
                              _genderForm = value!;
                            });
                          },
                        )
                      : _sizeForm
                          ? SizeForm(
                              onSelect: (value) {
                                setState(() {
                                  _sizeForm = value!;
                                  _activityForm = true;
                                });
                              },
                              onSubmit: (value) {
                                setState(() {
                                  _currentDog.size = value;
                                });
                              },
                              onBack: (value) {
                                setState(() {
                                  _ageForm = value!;
                                });
                              },
                            )
                          : _activityForm
                              ? ActivityForm(
                                  onSelect: (value) {
                                    setState(() {
                                      _activityForm = value!;
                                      _imageForm = true;
                                    });
                                  },
                                  onSubmit: (value) {
                                    setState(() {
                                      _currentDog.activity = value;
                                    });
                                  },
                                  onBack: (value) {
                                    setState(() {
                                      _sizeForm = value!;
                                    });
                                  },
                                )
                              : _imageForm
                                  ? ImageForm(
                                      onSelect: (value) {
                                        setState(() {
                                          _imageForm = value!;
                                          _summaryForm = true;
                                        });
                                      },
                                      onSubmit: (value) {
                                        setState(() {
                                          _currentDog.photo = value;
                                        });
                                      },
                                      onBack: (value) {
                                        setState(() {
                                          _activityForm = value!;
                                        });
                                      },
                                    )
                                  : DogSummary(
                                      onBack: (value) {
                                        setState(() {
                                          _imageForm = value!;
                                        });
                                      },
                                      dog: _currentDog,
                                      owner: _currentOwner,
                                    )
        ],
      ),
    );
  }
}
