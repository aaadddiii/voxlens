import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class STT{
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  STT(){
    _initSpeech();
  }
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
  }
  void startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
  }
  void _stopListening() async {
    await _speechToText.stop();
  }
  void _onSpeechResult(SpeechRecognitionResult result) {
    print(result.recognizedWords);

  }
}