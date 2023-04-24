import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../user/validators.dart';

class NameForm extends StatefulWidget {
  const NameForm({super.key, required this.onSelect, required this.onSubmit});

  final ValueChanged<bool?> onSelect;
  final ValueChanged<String> onSubmit;

  @override
  State<NameForm> createState() => _NameFormState();
}

class _NameFormState extends State<NameForm> {
  final _nameRegisterTextController = TextEditingController();
  final _focusRegisterName = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("What's your dog's name?"),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            child: TextFormField(
              controller: _nameRegisterTextController,
              focusNode: _focusRegisterName,
              validator: (value) => Validator.validateName(
                name: value,
              ),
              decoration: const InputDecoration(
                  labelText: 'ex. Fido',
                  fillColor: Colors.white,
                  icon: Icon(Icons.add)),
            ),
          ),
        ),
        OutlinedButton(
            onPressed: () {
              widget.onSubmit(_nameRegisterTextController.text);
              widget.onSelect(false);
            },
            child: Text('Next'))
      ],
    );
  }
}
