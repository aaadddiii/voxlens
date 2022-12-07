import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TTS {
  final FlutterTts tts = FlutterTts();
  int state = 0;
  TTS() {
    tts.setLanguage('en');
    tts.setSpeechRate(0.3);
    tts.awaitSpeakCompletion(true);
    tts.awaitSynthCompletion(true);
  }
  Future<void> speak(String text) async {
    tts.setStartHandler(() {
      state = 1;
    });
    await tts.speak(text);
    tts.setCompletionHandler(() {
      state = 0;
    });
  }
  void stop(){
    tts.stop();
  }
}
