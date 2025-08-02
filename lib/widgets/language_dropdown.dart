import 'package:flutter/material.dart';
import 'package:play_voice_app/models/languagemodel.dart';

class LanguageDropdown extends StatelessWidget {
  final List<LanguageModel> languages;
  final String code;
  final Function(String) onChanged;

  const LanguageDropdown({
    super.key,
    required this.languages,
    required this.code,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: code,
      decoration: const InputDecoration(labelText: 'Select Language'),
      items: languages.map((language) {
        return DropdownMenuItem<String>(
          value: language.code,
          child: Text(language.name),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}
