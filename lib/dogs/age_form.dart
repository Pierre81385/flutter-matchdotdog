import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AgeForm extends StatefulWidget {
  const AgeForm({super.key, required this.onSelect, required this.onSubmit});

  final ValueChanged<bool?> onSelect;
  final ValueChanged<int> onSubmit;

  @override
  State<AgeForm> createState() => _AgeFormState();
}

class _AgeFormState extends State<AgeForm> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
