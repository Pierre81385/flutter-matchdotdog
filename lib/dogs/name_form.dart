import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class NameForm extends StatefulWidget {
  const NameForm({super.key, required this.onSelect, required this.onSubmit});

  final ValueChanged<bool?> onSelect;
  final ValueChanged<String> onSubmit;

  @override
  State<NameForm> createState() => _NameFormState();
}

class _NameFormState extends State<NameForm> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
