import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SizeForm extends StatefulWidget {
  const SizeForm({super.key, required this.onSelect, required this.onSubmit});

  final ValueChanged<bool?> onSelect;
  final ValueChanged<double> onSubmit;

  @override
  State<SizeForm> createState() => _SizeFormState();
}

class _SizeFormState extends State<SizeForm> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
