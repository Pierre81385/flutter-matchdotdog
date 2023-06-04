import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../models/dog_model.dart';

class MyDogsDetails extends StatefulWidget {
  const MyDogsDetails({
    super.key,
    required this.dog,
  });

  final Dog dog;

  @override
  State<MyDogsDetails> createState() => _MyDogsDetailsState();
}

class _MyDogsDetailsState extends State<MyDogsDetails> {
  late Dog _currentDog;

  @override
  void initState() {
    _currentDog = widget.dog;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //name & gender
                Text(
                  _currentDog.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //age
                _currentDog.gender == 0
                    ? Icon(
                        Icons.female,
                        color: Colors.pink,
                      )
                    : Icon(
                        Icons.male,
                        color: Colors.blue,
                      ),
                Text(_currentDog.age.round().toString() + ' years old')
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //size
                _currentDog.size <= 5
                    ? Text('Size extra-smol.')
                    : _currentDog.size > 5 && _currentDog.size <= 10
                        ? Text('Size smeeedium')
                        : _currentDog.size > 10 && _currentDog.size <= 15
                            ? Text('Size medium.')
                            : _currentDog.size > 15 && _currentDog.size <= 20
                                ? Text('Size large')
                                : _currentDog.size > 20 &&
                                        _currentDog.size <= 24
                                    ? Text('Size XL')
                                    : Text('Size BIG'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //activity
                _currentDog.activity <= 5
                    ? Text('and very laid back.')
                    : _currentDog.activity > 5 && _currentDog.activity <= 10
                        ? Text('and curious but chill.')
                        : _currentDog.activity > 10 &&
                                _currentDog.activity <= 15
                            ? Text('and playful!')
                            : _currentDog.activity > 15 &&
                                    _currentDog.activity <= 20
                                ? Text('with puppy energy!')
                                : _currentDog.activity > 20 &&
                                        _currentDog.activity <= 24
                                    ? Text('and hyper-active!')
                                    : Text('and agressively hyper-active!'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //description
                //Text(_currentDog.description)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
