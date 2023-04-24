import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class GenderForm extends StatefulWidget {
  const GenderForm(
      {super.key,
      required this.onSelect,
      required this.onSubmit,
      required this.onBack});

  final ValueChanged<bool?> onSelect;
  final ValueChanged<int> onSubmit;
  final ValueChanged<bool?> onBack;

  @override
  State<GenderForm> createState() => _GenderFormState();
}

class _GenderFormState extends State<GenderForm> {
  int _selectedGenderValue = 0;

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
