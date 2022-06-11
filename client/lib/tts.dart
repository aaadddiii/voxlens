import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TTS {
  final FlutterTts tts = FlutterTts();
  TTS() {
    tts.setLanguage('en');
    tts.setSpeechRate(0.4);
  }
  void speak(String text){
    tts.speak(text);
  }
}
