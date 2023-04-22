import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:matchdotdog/models/owner_model.dart';
import 'package:matchdotdog/user/avatar_upload.dart';
import 'package:matchdotdog/user/validators.dart';
import '../dogs/register_dog.dart';
import '../dogs/register_my_dog.dart';
import 'fire_auth.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key, required this.onSelect});

  final ValueChanged<bool?> onSelect;

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _registerFormKey = GlobalKey<FormState>();
  final _nameRegisterTextController = TextEditingController();
  final _emailRegisterTextController = TextEditingController();
  final _passwordRegisterTextController1 = TextEditingController();
  final _passwordRegisterTextController2 = TextEditingController();
  final _focusRegisterName = FocusNode();
  final _focusRegisterEmail = FocusNode();
  final _focusRegisterPassword1 = FocusNode();
  final _focusRegisterPassword2 = FocusNode();
  late final bool _selection = true;
  bool _isProcessing = false;
  late Owner _owner;
  final firestoreInstance = FirebaseFirestore.instance;
  String _avatarPhoto = 'no photo';
  late Position _userPosition;
  bool _locationAuth = false;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      print('getting user location: ' + position.toString());
      setState(() {
        _userPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _registerFormKey,
      child: Column(
        children: [
          AvatarUploads(
            onSelect: (value) {
              setState(() {
                _avatarPhoto = value!;
              });
            },
          ),
          TextFormField(
            controller: _nameRegisterTextController,
            focusNode: _focusRegisterName,
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
            validator: (value) => Validator.validatePassword(
              password: value,
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
            validator: (value) => Validator.validatePassword(
              password: value,
            ),
            decoration: const InputDecoration(
              labelText: 'Verify Password',
              fillColor: Colors.white,
              icon: Icon(Icons.key),
            ),
          ),
          OutlinedButton(
              onPressed: () {
                _getCurrentPosition();
              },
              child: Text('Location')),
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
                child: _isProcessing
                    ? const CircularProgressIndicator()
                    : OutlinedButton(
                        onPressed: () async {
                          _focusRegisterName.unfocus();
                          _focusRegisterEmail.unfocus();
                          _focusRegisterPassword1.unfocus();
                          _focusRegisterPassword2.unfocus();

                          if (_registerFormKey.currentState!.validate()) {
                            setState(() {
                              _isProcessing = true;
                            });
                          }

                          if (_registerFormKey.currentState!.validate()) {
                            //create user in Firebase Auth
                            User? user =
                                await FireAuth.registerUsingEmailPassword(
                              name: _nameRegisterTextController.text,
                              email: _emailRegisterTextController.text,
                              password: _passwordRegisterTextController2.text,
                            );

                            _owner = Owner(
                                uid: user?.uid as String,
                                name: _nameRegisterTextController.text,
                                email: _emailRegisterTextController.text,
                                avatar: _avatarPhoto,
                                locationLat: _userPosition.latitude,
                                locationLong: _userPosition.longitude,
                                dogs: [],
                                friends: []);

                            Map<String, dynamic> map = {
                              'uid': _owner.uid,
                              'name': _owner.name,
                              'email': _owner.email,
                              'avatar': _owner.avatar,
                              'locationLat': _owner.locationLat,
                              'locationLong': _owner.locationLong,
                              'dogs': _owner.dogs,
                              'friends': _owner.friends
                            };

                            firestoreInstance
                                .collection('owners')
                                .doc(_owner.uid)
                                .set(map)
                                .whenComplete(() => _isProcessing = false);

                            if (user != null) {
                              print(
                                  'Sending user information to dog registration page!');
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RegisterMyDog(owner: _owner),
                                ),
                              );
                            }
                          }
                        },
                        child: Text('Register')),
              ),
            ],
          ),
        ],
      ),
    );
    ;
  }
}
