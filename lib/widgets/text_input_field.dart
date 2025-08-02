import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;

  const TextInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: 7,
      maxLines: null,
      decoration: InputDecoration(
        labelText: 'Enter Text to Speak',
        suffixIcon: IconButton(
          icon: const Icon(Icons.delete_forever_rounded),
          onPressed: () => controller.clear(),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
    );
  }
}
