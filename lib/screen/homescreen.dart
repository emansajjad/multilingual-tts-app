import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:play_voice_app/models/languagemodel.dart';
import '../services/tts_service.dart';
import '../widgets/language_dropdown.dart';
import '../widgets/text_input_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TtsService _ttsService = TtsService();
  final TextEditingController _controller = TextEditingController();

  String selectedLang = 'en-US';
  double volume = 1.0;
  bool isMale = true; // Start with male voice

  final List<LanguageModel> languages = [
    LanguageModel(name: "English", code: "en-US"),
    LanguageModel(name: "Urdu", code: "ur-PK"),
    LanguageModel(name: "German", code: "de-DE"),
    LanguageModel(name: "French", code: "fr-FR"),
    LanguageModel(name: "Turkish", code: "tr-TR"),
    LanguageModel(name: "Japanese", code: "ja-JP"),
    LanguageModel(name: "Arabic", code: "ar-SA"),
    LanguageModel(name: "Spanish", code: "es-ES"),
    LanguageModel(name: "Chinese", code: "zh-CN"),
  ];

  @override
  void initState() {
    super.initState();
    _ttsService.initTts();
  }

  void _playSpeech() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter text');
      return;
    }

    final supported = await _ttsService.getSupportedLanguages();
    if (!supported.contains(selectedLang)) {
      Fluttertoast.showToast(msg: 'Language not supported on this device');
      return;
    }

    await _ttsService.speak(
      text: text,
      languageCode: selectedLang,
      volume: volume,
      isMale: isMale,
    );

    setState(() {
      isMale = !isMale;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TTS Assistant'),
        centerTitle: true,
        backgroundColor: Colors.purpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LanguageDropdown(
              languages: languages,
              code: selectedLang,
              onChanged: (code) {
                setState(() {
                  selectedLang = code;
                });
              },
            ),
            const SizedBox(height: 16),
            TextInputField(controller: _controller),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _playSpeech,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Play'),
            ),
          ],
        ),
      ),
    );
  }
}
