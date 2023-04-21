import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../models/dog_model.dart';

class DogSummary extends StatefulWidget {
  const DogSummary({super.key, required this.onSelect, required this.dog});

  final ValueChanged<bool?> onSelect;
  final Dog dog;

  @override
  State<DogSummary> createState() => _DogSummaryState();
}

class _DogSummaryState extends State<DogSummary> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
