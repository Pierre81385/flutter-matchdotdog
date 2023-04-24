import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ActivityForm extends StatefulWidget {
  const ActivityForm(
      {super.key,
      required this.onSelect,
      required this.onSubmit,
      required this.onBack});

  final ValueChanged<bool?> onSelect;
  final ValueChanged<double> onSubmit;
  final ValueChanged<bool?> onBack;

  @override
  State<ActivityForm> createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  double _selectedActivityValue = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('How big active your dog?'),
        Text('Activity LVL ${_selectedActivityValue.round().toString()}'),
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
