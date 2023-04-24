import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AgeForm extends StatefulWidget {
  const AgeForm(
      {super.key,
      required this.onSelect,
      required this.onSubmit,
      required this.onBack});

  final ValueChanged<bool?> onSelect;
  final ValueChanged<double> onSubmit;
  final ValueChanged<bool?> onBack;

  @override
  State<AgeForm> createState() => _AgeFormState();
}

class _AgeFormState extends State<AgeForm> {
  double _selectedAgeValue = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("How old is your dog?"),
        Text('Age ${_selectedAgeValue.round().toString()}'),
        Slider(
            //label: _selectedAgeValue.toString(),
            min: 0,
            max: 25,
            divisions: 25,
            value: _selectedAgeValue,
            onChanged: (value) {
              setState(() {
                _selectedAgeValue = value;
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
            OutlinedButton(
                onPressed: () {
                  widget.onSubmit(_selectedAgeValue);
                  widget.onSelect(false);
                },
                child: Text('Next')),
          ],
        )
      ],
    );
  }
}
