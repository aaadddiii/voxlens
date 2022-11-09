import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TTS {
  final FlutterTts tts = FlutterTts();
  TTS() {
    tts.setLanguage('en');
    tts.setSpeechRate(0.3);
  }
  Future speak(String text) async{
    await tts.speak(text);
  }
  void stop(){
    tts.stop();
  }
}
