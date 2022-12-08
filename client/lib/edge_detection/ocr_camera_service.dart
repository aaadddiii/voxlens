import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:alan_voice/alan_voice.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math' as math;
import '../main.dart';
import 'package:client/tts.dart';
import 'convert_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

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
  bool is_captured = false;
  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  ScreenMode _mode = ScreenMode.liveFeed;
  CameraController? _controller;
  String? imagePath;
  File? _image;
  var tts = TTS();
  String? _path;
  List<int>? lst;
  ImagePicker? _imagePicker;
  int _cameraIndex = -1;
  double zoomLevel = 0.0, minZoomLevel = 0.0, maxZoomLevel = 0.0;
  final bool _allowPicker = true;
  String? path;
  CameraImage? img;
  Image? image;
  File? receiptFile;
  bool _changingCameraLens = false;
  bool captured = false;
  bool capturing = false;
  late InputImage inputImage ;
  @override
  _CameraViewState(){
    AlanVoice.onCommand.add((command) => _handleCommand(command.data));
  }

  void _handleCommand(Map<String, dynamic> command) {
    switch(command["command"]) {
      case "capture":
        capture();
       break;
    }
  }

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
        ));
  }
  // Future _setImagePath() async{
  //   assert(_controller != null, 'Camera controller not initialized');
  //   await _controller?.stopImageStream();
  //   XFile? file = await _controller?.takePicture();
  //   imagePath = file?.path;
  // }
  Widget _captured_body(){
    widget.onImage(inputImage);
    widget.is_captured = true;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return ListView(shrinkWrap: true, children: [
      Transform.rotate(
        angle: math.pi/2,
        child: SizedBox(
          height: height,
          width: width,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.file(File('$path/image.png')),
              Transform.rotate(angle: -math.pi/2,
                  child: widget.customPaint!),
            ],
          ),
        )
      )
    ]);
  }
  Future<String> getPath() async{
    String path = (await getApplicationDocumentsDirectory()).path;
    return path;
  }
  Future<File> get _localFile async {
    final path = await getPath();
    print('path ${path}');
    return File('$path/image.png');
  }

  Future<int> delete() async {
    try {
      final file = await _localFile;

      await file.delete();
    } catch (e) {
      return 0;
    }
    return 0;
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
  Widget _body() {
    Widget body;
    if(captured){
      return _captured_body();
    }
    if (_mode == ScreenMode.liveFeed) {
      body = _liveFeedBody();
    } else {
      body = _galleryBody();
    }
    return body;
  }

  // Future<String> getFilePath() async {
  //   Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
  //   String appDocumentsPath = appDocumentsDirectory.path; // 2
  //   String filePath = '$appDocumentsPath/demoTextFile.txt'; // 3
  //
  //   return filePath;
  // }


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

    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
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
            child: Slider(
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
            ),
          ),
          Positioned(
            bottom: 200,
            left: 10,
            right: 10,
            child: SizedBox(
              height:150,
              width:150,
              child:FloatingActionButton(
                backgroundColor: Colors.teal[300],
                child: Text("Capture"), //child widget inside this button
                onPressed: capture,

              ),

            ),
          ),
        ],
      ),
    );
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
  Future capture() async{
  print("Button is pressed.");
  TTS().stop();
  // _body();
  // await _controller?.stopImageStream();
  // XFile? rawImage = await takePicture();
  captured = true;
  // image = Image.memory(convert);
  // await delete();
  imageCache.clear();
  lst = await convertImagetoPng(img!);
  // if(lst != null){
  // }
  // try{

  // }
  // catch(e){
  //   print("===+++-----+++++++========>>>>>>><<<<<<<<<<<");
  //   print(e);}
  // if(receiptFile == null){
  //   print("//////////////////////////////////////|||||||||||||--------==========");
  // }
  path = await getPath();
  await File('$path/image.png').writeAsBytes(lst!);
  // receiptFile = await File('image.png').writeAsBytes(lst!);
  // await File("image.png").writeAsBytesSync(lst!);
  setState(() {});
  await _stopLiveFeed();
// imagePath = rawImage?.path;
// _captured_body();
// _body();
// task to execute when this button is pressed
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
    inputImage = InputImage.fromFilePath(path);
    widget.onImage(inputImage);
  }

  Future _processCameraImage(CameraImage image) async {
    // img = convertToImage(image) as Image;
    img = image;
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

    inputImage =
    InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    widget.onImage(inputImage);
  }
}