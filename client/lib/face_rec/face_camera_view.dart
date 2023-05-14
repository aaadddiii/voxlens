import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'auth-action-button.dart';
import '../main.dart';
import 'package:client/locator.dart';
import 'face_detect.dart';
import 'ml_services.dart';

enum ScreenMode { liveFeed, gallery }

class CameraView extends StatefulWidget {
  CameraView(
      {Key? key,
        required this.title,
        required this.customPaint,
        this.text,
        required this.onImage,
        this.onScreenModeChanged,
        this.initialDirection = CameraLensDirection.back})
      : super(key: key);

  final String title;
  final CustomPaint? customPaint;
  final String? text;
  final Function(InputImage inputImage) onImage;
  final Function(ScreenMode mode)? onScreenModeChanged;
  final CameraLensDirection initialDirection;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  Face? faceDetected;
  String? imagePath;
  ScreenMode _mode = ScreenMode.liveFeed;
  CameraController? _controller;
  File? _image;
  String? _path;
  ImagePicker? _imagePicker;
  int _cameraIndex = -1;
  double zoomLevel = 0.0, minZoomLevel = 0.0, maxZoomLevel = 0.0;
  final bool _allowPicker = true;
  bool _changingCameraLens = false;
  FaceMLService _mlService = locator<FaceMLService>();

  @override
  void initState() {
    super.initState();

    _imagePicker = ImagePicker();

    if (cameras.any(
          (element) =>
      element.lensDirection == widget.initialDirection &&
          element.sensorOrientation == 90,
    )) {
      _cameraIndex = cameras.indexOf(
        cameras.firstWhere((element) =>
        element.lensDirection == widget.initialDirection &&
            element.sensorOrientation == 90),
      );
    } else {
      for (var i = 0; i < cameras.length; i++) {
        if (cameras[i].lensDirection == widget.initialDirection) {
          _cameraIndex = i;
          break;
        }
      }
    }

    if (_cameraIndex != -1) {
      _startLiveFeed();
    } else {
      _mode = ScreenMode.gallery;
    }
  }

  @override
  void dispose() {
    _stopLiveFeed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (_allowPicker)
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: _switchScreenMode,
                child: Icon(
                  _mode == ScreenMode.liveFeed
                      ? Icons.photo_library_outlined
                      : (Platform.isIOS
                      ? Icons.camera_alt_outlined
                      : Icons.camera),
                ),
              ),
            ),
        ],
      ),
      body: _body(),
      floatingActionButton: _floatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget? _floatingActionButton() {
    if (_mode == ScreenMode.gallery) return null;
    if (cameras.length == 1) return null;
    return SizedBox(
            height: 70.0,
            width: 70.0,
            child: FloatingActionButton(
                onPressed: _switchLiveCamera,
                child: Icon(
                  Platform.isIOS
                      ? Icons.flip_camera_ios_outlined
                      : Icons.flip_camera_android_outlined,
                  size: 40,
                ),
              ),
      );
  }

  Widget _body() {
    Widget body;
    if (_mode == ScreenMode.liveFeed) {
      body = _liveFeedBody();
    } else {
      body = _galleryBody();
    }
    return body;
  }

  Widget _liveFeedBody() {
    if (_controller?.value.isInitialized == false) {
      return Container();
    }

    final size = MediaQuery.of(context).size;
    // calculate scale depending on screen and camera ratios
    // this is actually size.aspectRatio / (1 / camera.aspectRatio)
    // because camera preview size is received as landscape
    // but we're calculating for portrait orientation
    var scale = size.aspectRatio * _controller!.value.aspectRatio;

    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;
     // if(FaceMLService.face != null){
     //   _controller?.startImageStream((image) => _mlService.setCurrentPrediction(image));
     // }
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // FloatingActionButton(onPressed: onPressed),
          Transform.scale(
            scale: scale,
            child: Center(
              child: _changingCameraLens
                  ? Center(
                child: const Text('Changing camera lens'),
              )
                  : CameraPreview(_controller!),
            ),
          ),
          if (widget.customPaint != null) widget.customPaint!,
          Positioned(
            bottom: 100,
            left: 50,
            right: 50,
            child: Column(
              children: [Slider(
                value: zoomLevel,
                min: minZoomLevel,
                max: maxZoomLevel,
                onChanged: (newSliderValue) {
                  setState(() {
                    zoomLevel = newSliderValue;
                    _controller!.setZoomLevel(zoomLevel);
                  });
                },
                divisions: (maxZoomLevel - 1).toInt() < 1
                    ? null
                    : (maxZoomLevel - 1).toInt(),
              ),SizedBox(),
                AuthActionButton(onPressed: (){}, isLogin: false, reload: (){})]
            ),
          ),
        ],
      ),
    );
  }
  _reload() {
    // setState(() {
    //   _bottomSheetVisible = false;
    //   pictureTaken = false;
    // });
    // this._start();
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
      // _saving = true;
      await Future.delayed(Duration(milliseconds: 500));
      // await _cameraService.cameraController?.stopImageStream();
      await Future.delayed(Duration(milliseconds: 200));
      XFile? file = await takePicture();
      imagePath = file?.path;

      // setState(() {
      //   _bottomSheetVisible = true;
      //   pictureTaken = true;
      // });

      return true;
    }
    return true;
  }
  Future<XFile?> takePicture() async {
    final CameraController? cameraController = _controller;

    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      print('Error occured while taking picture: $e');
      return null;
    }
  }

  Widget _galleryBody() {
    return ListView(shrinkWrap: true, children: [
      _image != null
          ? SizedBox(
        height: 400,
        width: 400,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.file(_image!),
            if (widget.customPaint != null) widget.customPaint!,
          ],
        ),
      )
          : Icon(
        Icons.image,
        size: 200,
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton(
          child: Text('From Gallery'),
          onPressed: () => _getImage(ImageSource.gallery),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton(
          child: Text('Take a picture'),
          onPressed: () => _getImage(ImageSource.camera),
        ),
      ),
      if (_image != null)
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
              '${_path == null ? '' : 'Image path: $_path'}\n\n${widget.text ?? ''}'),
        ),
    ]);
  }

  Future _getImage(ImageSource source) async {
    setState(() {
      _image = null;
      _path = null;
    });
    final pickedFile = await _imagePicker?.pickImage(source: source);
    if (pickedFile != null) {
      _processPickedFile(pickedFile);
    }
    setState(() {});
  }

  void _switchScreenMode() {
    _image = null;
    if (_mode == ScreenMode.liveFeed) {
      _mode = ScreenMode.gallery;
      _stopLiveFeed();
    } else {
      _mode = ScreenMode.liveFeed;
      _startLiveFeed();
    }
    if (widget.onScreenModeChanged != null) {
      widget.onScreenModeChanged!(_mode);
    }
    setState(() {});
  }

  Future _startLiveFeed() async {
    final camera = cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _controller?.getMinZoomLevel().then((value) {
        zoomLevel = value;
        minZoomLevel = value;
      });
      _controller?.getMaxZoomLevel().then((value) {
        maxZoomLevel = value;
      });
      _controller?.startImageStream(_processCameraImage);
      setState(() {});
    });
  }

  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  Future _switchLiveCamera() async {
    setState(() => _changingCameraLens = true);
    _cameraIndex = (_cameraIndex + 1) % cameras.length;

    await _stopLiveFeed();
    await _startLiveFeed();
    setState(() => _changingCameraLens = false);
  }

  Future _processPickedFile(XFile? pickedFile) async {
    final path = pickedFile?.path;
    if (path == null) {
      return;
    }
    setState(() {
      _image = File(path);
    });
    _path = path;
    final inputImage = InputImage.fromFilePath(path);
    widget.onImage(inputImage);
  }

  Future _processCameraImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
    Size(image.width.toDouble(), image.height.toDouble());

    final camera = cameras[_cameraIndex];
    final imageRotation =
    InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    if (imageRotation == null) return;

    final inputImageFormat =
    InputImageFormatValue.fromRawValue(image.format.raw);
    if (inputImageFormat == null) return;

    final planeData = image.planes.map(
          (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage =
    InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    widget.onImage(inputImage);
  }
}
