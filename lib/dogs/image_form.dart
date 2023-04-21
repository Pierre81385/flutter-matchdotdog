import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ImageForm extends StatefulWidget {
  const ImageForm({super.key, required this.onSelect, required this.onSubmit});

  final ValueChanged<bool?> onSelect;
  final ValueChanged<String> onSubmit;

  @override
  State<ImageForm> createState() => _ImageFormState();
}

class _ImageFormState extends State<ImageForm> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
