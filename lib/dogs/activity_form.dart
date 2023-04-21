import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ActivityForm extends StatefulWidget {
  const ActivityForm(
      {super.key, required this.onSelect, required this.onSubmit});

  final ValueChanged<bool?> onSelect;
  final ValueChanged<double> onSubmit;

  @override
  State<ActivityForm> createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
