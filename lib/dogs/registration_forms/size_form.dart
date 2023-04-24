import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SizeForm extends StatefulWidget {
  const SizeForm(
      {super.key,
      required this.onSelect,
      required this.onSubmit,
      required this.onBack});

  final ValueChanged<bool?> onSelect;
  final ValueChanged<double> onSubmit;
  final ValueChanged<bool?> onBack;

  @override
  State<SizeForm> createState() => _SizeFormState();
}

class _SizeFormState extends State<SizeForm> {
  double _selectedSizeValue = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('How big is your dog?'),
        Text('Size ${_selectedSizeValue.round().toString()}'),
        Slider(
            //label: _selectedAgeValue.toString(),
            min: 0,
            max: 25,
            divisions: 25,
            value: _selectedSizeValue,
            onChanged: (value) {
              setState(() {
                _selectedSizeValue = value;
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
                  widget.onSubmit(_selectedSizeValue);
                  widget.onSelect(false);
                },
                child: Text('Next')),
          ],
        )
      ],
    );
  }
}
