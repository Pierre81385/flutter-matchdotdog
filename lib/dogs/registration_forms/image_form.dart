import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'dog_file_upload.dart';

class ImageForm extends StatefulWidget {
  const ImageForm(
      {super.key,
      required this.onSelect,
      required this.onSubmit,
      required this.onBack});

  final ValueChanged<bool?> onSelect;
  final ValueChanged<String> onSubmit;
  final ValueChanged<bool?> onBack;

  @override
  State<ImageForm> createState() => _ImageFormState();
}

class _ImageFormState extends State<ImageForm> {
  late String? _URL;

  @override
  void initState() {
    super.initState();
    _URL = 'no image';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DogImageUploads(
          onSelect: (value) {
            _URL = value!;
          },
        ),
        Text("Let's show everyone what your dog looks like!"),
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
                  print(_URL);
                  widget.onSubmit(_URL!);
                  widget.onSelect(false);
                },
                child: Text('Next')),
          ],
        )
      ],
    );
  }
}
