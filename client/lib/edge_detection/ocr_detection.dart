import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:client/tts.dart';
import 'ocr_camera_service.dart';
import 'text_detector_painter.dart';
import 'package:vibration/vibration.dart';


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

  @override
  void dispose() async {
    _canProcess = false;
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      title: 'Text Detector',
      customPaint: _customPaint,
      text: _text,
      onImage: (inputImage) {
        processImage(inputImage);
      },
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if(_speaking) return;
    if (!_canProcess) return;
    if(_isBusy)
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final recognizedText = await _textRecognizer.processImage(inputImage);
    for(var block in recognizedText.blocks){
      if(block.boundingBox.left < 10 && block.cornerPoints[1].y < 10){
        await TTS().speak("move away");
      }
      else if(block.boundingBox.left < 5){
        await TTS().speak("move left");
      }
      else if(block.cornerPoints[1].y < 5){
        await TTS().speak("move right");
      }
      else if(block.boundingBox.top< 10){
        await TTS().speak("move up");
      }
      else if(block.boundingBox.bottom > 1100){
        await TTS().speak("move down");
      }
      // else if(!(block.boundingBox.left < 10) || !(block.cornerPoints[1].y < 10)){
      //     Vibration.vibrate(duration: 1000);
      //     await TTS().speak("capture");
      // }

      print('=======================================================================');
      print(MediaQuery.of(context).size.width);
      print(block.boundingBox.right);
      print(block.cornerPoints);
    }
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