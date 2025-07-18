import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:tanaw_app/state/tts_state.dart';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();
  final BuildContext context;

  TtsService(this.context) {
    _flutterTts.setLanguage("en-US");
    _flutterTts.setSpeechRate(0.5);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);
  }

  Future<void> speak(String text, {bool forceSpeak = false}) async {
    final ttsState = Provider.of<TtsState>(context, listen: false);
    if (ttsState.isTtsEnabled || forceSpeak) {
      await _flutterTts.speak(text);
    }
  }
} 