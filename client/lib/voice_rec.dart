import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class STT{
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String command_word = 'default';
  STT(){
    _initSpeech();
  }
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
  }
  Future startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
  }
  void _stopListening() async {
    await _speechToText.stop();
  }
  void _onSpeechResult(SpeechRecognitionResult result) {
    command_word=result.recognizedWords;
    // print(command_word);

  }
}