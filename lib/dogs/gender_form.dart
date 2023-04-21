import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class GenderForm extends StatefulWidget {
  const GenderForm({super.key, required this.onSelect, required this.onSubmit});

  final ValueChanged<bool?> onSelect;
  final ValueChanged<int> onSubmit;

  @override
  State<GenderForm> createState() => _GenderFormState();
}

class _GenderFormState extends State<GenderForm> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
