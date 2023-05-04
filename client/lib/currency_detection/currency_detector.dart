import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class CurrencyDetector extends StatefulWidget {
  final List<CameraDescription> cameras;
  CurrencyDetector({required this.cameras});

  @override
  _CurrencyDetectorState createState() => _CurrencyDetectorState();
}

class _CurrencyDetectorState extends State<CurrencyDetector> {
  late CameraController _cameraController;
  bool _isDetecting = false;
  late Interpreter _interpreter;

  @override
  void initState() {
    super.initState();

    // Initialize the camera controller
    _cameraController = CameraController(widget.cameras[0], ResolutionPreset.medium);
    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});

      // Load the TFLite model
      loadModel().then((value) {
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('currency_detector.tflite');
      print('Interpreter loaded successfully');
    } catch (e) {
      print('Failed to load interpreter: $e');
    }
  }

  void startDetection() {
    _cameraController.startImageStream((CameraImage image) {
      if (!_isDetecting) {
        _isDetecting = true;

        // Run inference on the current frame
        runInference(image).then((_) {
          _isDetecting = false;
        });
      }
    });
  }

  Future<void> runInference(CameraImage image) async {
    if (_interpreter == null) {
      return;
    }

    // Preprocess the image
    var input = image.planes.map((plane) {
      return TensorImage.fromBytes(plane.bytes, image.width, image.height, 1);
    }).toList();

    // Run inference
    var output = List.filled(1, null);
    _interpreter.runForMultipleInputs(input, output);

    // Process the output
    var prediction = output[0][0];
    print('Prediction: $prediction');
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraController.value.isInitialized) {
      return Container();
    }

    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(_cameraController),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        onPressed: () {
          startDetection();
        },
      ),
    );
  }
}
