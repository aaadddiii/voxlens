import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter/material.dart';
import 'camera_service.dart';
import 'package:client/locator.dart';
import 'face_painter.dart';
import 'face_detector_service.dart';
import 'auth-action-button.dart';
import 'ml_services.dart';
import 'user_model.dart';
import 'package:client/tts.dart';

class FaceRec extends StatefulWidget {
  const FaceRec({Key? key}) : super(key: key);

  @override
  FaceRecState createState() => FaceRecState();
}

class FaceRecState extends State<FaceRec> {
  var tts = TTS();
  String? imagePath;
  Face? faceDetected;
  Size? imageSize;

  bool _detectingFaces = false;
  bool pictureTaken = false;

  bool _initializing = false;

  bool _saving = false;
  bool _bottomSheetVisible = false;

  // service injection
  CameraService _cameraService = locator<CameraService>();
  FaceDetectorService _faceDetectorService = locator<FaceDetectorService>();
  MLService _mlService = locator<MLService>();
  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }

  _start() async {
    setState(() => _initializing = true);
    await _cameraService.initialize();
    _faceDetectorService.initialize();
    setState(() => _initializing = false);

    _frameFaces();
  }

  Future<bool> onShot() async {
    if (faceDetected == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('No face detected!'),
          );
        },
      );

      return false;
    } else {
      _saving = true;
      await Future.delayed(Duration(milliseconds: 500));
      // await _cameraService.cameraController?.stopImageStream();
      await Future.delayed(Duration(milliseconds: 200));
      XFile? file = await _cameraService.takePicture();
      imagePath = file?.path;

      setState(() {
        _bottomSheetVisible = true;
        pictureTaken = true;
      });

      return true;
    }
  }

  _frameFaces() async{
    bool processing = false;
    imageSize = _cameraService.getImageSize();

    _cameraService.cameraController?.startImageStream((image) async {
      if (_cameraService.cameraController != null) {
        if (_detectingFaces) return;

        _detectingFaces = true;
        try {
          await _faceDetectorService.detectFacesFromImage(image);
          if (_faceDetectorService.faces.isNotEmpty) {
            setState(() {
              faceDetected = _faceDetectorService.faces[0];
            });
            _saving = true;
            if (_saving) {
              _mlService.setCurrentPrediction(image, faceDetected);
              // print('||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||');
              // print(_mlService.predictedData);
              // print('||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||');
              setState(() {
                _saving = false;
              });
            }
          } else {
            setState(() {
              faceDetected = null;
            });
          }
          // if (processing) return; // prevents unnecessary overprocessing
          _detectingFaces = false;
        } catch (e) {
          print(e);
          _detectingFaces = false;
        }
        // processing = true;
        // await _predictFacesFromImage(image: image);
        // print('||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||');
        // print(_mlService.predictedData);
        // print('||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||');
        // processing = false;
        // if (_faceDetectorService.faceDetected) {
        //   User? user = await _mlService.predict();
        //   String? text = user?.user;
        //   tts.speak(text!);
        // }
        try{
          bool speaking = false;
            print('||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||');
            User? u = await _mlService.predict();
            if(u==null){
              print('its null :(');
            }
            print(u);
            print("hihihihihih");
            String? name = u?.user;
            speaking = true;
            if(faceDetected != null){
              if(tts.state == 0) {
                if(name != null)
                  tts.speak("found" + name!);
                else
                  tts.speak("found unknown person");
              }
            }
            speaking = false;
            print('||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||');
        }
        catch(e){
          print("==============");
          print(e);
          print("==============");
        }
      }
    });
  }

  Future<void> _predictFacesFromImage({@required CameraImage? image}) async {
    assert(image != null, 'Image is null');
    await _faceDetectorService.detectFacesFromImage(image!);
    if (_faceDetectorService.faceDetected) {
      _mlService.setCurrentPrediction(image, _faceDetectorService.faces[0]);
    }
    if (mounted) setState(() {});
  }

  _onBackPressed() {
    Navigator.of(context).pop();
  }

  _reload() {
    setState(() {
      _bottomSheetVisible = false;
      pictureTaken = false;
    });
    this._start();
  }

  @override
  Widget build(BuildContext context) {
    final double mirror = math.pi;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    late Widget body;
    if (_initializing) {
      body = Center(
        child: CircularProgressIndicator(),
      );
    }

    if (!_initializing && pictureTaken) {
      body = Container(
        width: width,
        height: height,
        child: Transform(
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.cover,
              child: Image.file(File(imagePath!)),
            ),
            transform: Matrix4.rotationY(mirror)),
      );
    }

    if (!_initializing && !pictureTaken) {
      body = Transform.scale(
        scale: 1.0,
        child: AspectRatio(
          aspectRatio: MediaQuery.of(context).size.aspectRatio,
          child: OverflowBox(
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Container(
                width: width,
                height:
                width * _cameraService.cameraController!.value.aspectRatio,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    CameraPreview(_cameraService.cameraController!),
                    CustomPaint(
                      painter: FacePainter(
                        face: faceDetected,
                        imageSize: imageSize!
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
        body: Stack(
          children: [
            body,
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: !_bottomSheetVisible
            ? AuthActionButton(
          onPressed: onShot,
          isLogin: false,
          reload: _reload,
        )
            : Container());
  }
}
