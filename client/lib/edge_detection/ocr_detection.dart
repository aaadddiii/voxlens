import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:client/tts.dart';
import 'ocr_camera_service.dart';
import 'text_detector_painter.dart';
import 'package:vibration/vibration.dart';
import 'ocr_camera_service.dart';


class TextRecognizerView extends StatefulWidget {
  @override
  State<TextRecognizerView> createState() => _TextRecognizerViewState();
}

class _TextRecognizerViewState extends State<TextRecognizerView> {
  final TextRecognizer _textRecognizer =
  TextRecognizer(script: TextRecognitionScript.latin);
  bool _canProcess = true;
  bool _speaking = false;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  var tts = TTS();
  var cameraView;
  @override
  void dispose() async {
    _canProcess = false;
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    cameraView = CameraView(
      title: 'Text Detector',
      customPaint: _customPaint,
      text: _text,

      onImage: (inputImage) {
        processImage(inputImage);
      },
    );
    return cameraView;
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if(_isBusy)
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final recognizedText = await _textRecognizer.processImage(inputImage);
    String scannedText = "";
    for(var block in recognizedText.blocks){
      if(cameraView.is_captured == true){
        for(TextLine line in block.lines){
          scannedText = scannedText + line.text + "\n";
        }
      }
      else if(block.boundingBox.left < 10 && block.cornerPoints[1].y < 10){
        if(tts.state == 0)
          tts.speak("move away");
      }
      else if(block.boundingBox.left < 5){
        if(tts.state == 0)
          tts.speak("move left");
      }
      else if(block.cornerPoints[1].y < 5){
        if(tts.state == 0)
          tts.speak("move right");
      }
      else if(block.boundingBox.top< 10){
        if(tts.state == 0)
          tts.speak("move up");
      }
      else if(block.boundingBox.bottom > 1100){
        if(tts.state == 0)
          tts.speak("move down");
      }
      // else if(!(block.boundingBox.left < 10) || !(block.cornerPoints[1].y < 10)){
      //     Vibration.vibrate(duration: 1000);
      //     await tts.speak("capture");
      // }

      print('=======================================================================');
      print(MediaQuery.of(context).size.width);
      print(block.boundingBox.right);
      print(block.cornerPoints);
    }
    tts.speak(scannedText);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = TextRecognizerPainter(
          recognizedText,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation);
      _customPaint = CustomPaint(painter: painter);
    }
      else {
      _text = 'Recognized text:\n\n${recognizedText.text}';
      // TODO: set _customPaint to draw boundingRect on top of image
      _customPaint = null;
    }
    // print(recognizedText);
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}