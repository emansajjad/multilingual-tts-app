// ignore_for_file: prefer_conditional_assignment

import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();
  List<dynamic> _allVoices = [];

  Future<void> initTts() async {
    await _flutterTts.setSpeechRate(0.4);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setLanguage("en-US");

    _allVoices = await _flutterTts.getVoices;
  }

  Future<List<String>> getSupportedLanguages() async {
    final langs = await _flutterTts.getLanguages;
    return List<String>.from(langs);
  }

  Future<void> speak({
    required String text,
    required String languageCode,
    required double volume,
    required bool isMale,
  }) async {
    if (text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter text");
      return;
    }

    await _flutterTts.stop();
    await _flutterTts.setLanguage(languageCode);
    await _flutterTts.setVolume(volume);

    var voice = _selectVoice(languageCode, isMale);

    // If preferred gender (mail) voice not found, fallback to opposite gender(female)
    if (voice == null) {
      voice = _selectVoice(languageCode, !isMale);
    }

    // If still no voice we app will fallback to any available voice
    if (voice == null) {
      voice = _selectAnyVoice(languageCode);
    }

    if (voice != null) {
      await _flutterTts.setVoice(voice);
      await _flutterTts.speak(text);
    } else {
      Fluttertoast.showToast(msg: "No voice available for $languageCode");
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }

  Map<String, String>? _selectVoice(String langCode, bool isMale) {
    langCode = langCode.toLowerCase().replaceAll('_', '-');

    final genderKeywords = isMale
        ? ['male', 'man', 'boy']
        : ['female', 'woman', 'girl'];

    final matchedVoice = _allVoices.cast<Map>().firstWhere(
      (voice) {
        final locale = ((voice['locale'] ?? '') as String).toLowerCase().replaceAll('_', '-');
        final name = ((voice['name'] ?? '') as String).toLowerCase();
        final gender = ((voice['gender'] ?? '') as String).toLowerCase();

        final localeMatch = locale.startsWith(langCode) || langCode.startsWith(locale);
        final genderMatch = genderKeywords.any((keyword) =>
            name.contains(keyword) || gender.contains(keyword));

        return localeMatch && genderMatch;
      },
      orElse: () => {},
    );

    if (matchedVoice.isNotEmpty) {
      return Map<String, String>.from(matchedVoice);
    }
    return null;
  }

  Map<String, String>? _selectAnyVoice(String langCode) {
    langCode = langCode.toLowerCase().replaceAll('_', '-');

    final matchedVoice = _allVoices.cast<Map>().firstWhere(
      (voice) {
        final locale = ((voice['locale'] ?? '') as String).toLowerCase().replaceAll('_', '-');
        return locale.startsWith(langCode) || langCode.startsWith(locale);
      },
      orElse: () => {},
    );

    if (matchedVoice.isNotEmpty) {
      return Map<String, String>.from(matchedVoice);
    }
    return null;
  }
}
