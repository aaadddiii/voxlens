// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:client/tts.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';
// import 'ocr_text_detail.dart';
//
// class OCR extends StatefulWidget {
//   @override
//   _OCRState createState() => _OCRState();
// }
//
// class _OCRState extends State<OCR> {
//   String _platformVersion = 'Unknown';
//
//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initPlatformState() async {
//     String platformVersion;
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     // We also handle the message potentially returning null.
//     try {
//       platformVersion = await FlutterMobileVision.platformVersion ??
//           'Unknown platform version';
//     } on PlatformException {
//       platformVersion = 'Failed to get platform version.';
//     }
//
//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;
//
//     setState(() {
//       _platformVersion = platformVersion;
//     });
//   }
//
//   int? _cameraBarcode = FlutterMobileVision.CAMERA_BACK;
//   int? _onlyFormatBarcode = Barcode.ALL_FORMATS;
//   bool _autoFocusBarcode = true;
//   bool _torchBarcode = false;
//   bool _multipleBarcode = false;
//   bool _waitTapBarcode = false;
//   bool _showTextBarcode = false;
//   Size? _previewBarcode;
//   List<Barcode> _barcodes = [];
//
//   int? _cameraOcr = FlutterMobileVision.CAMERA_BACK;
//   bool _autoFocusOcr = true;
//   bool _torchOcr = false;
//   bool _multipleOcr = true;
//   bool _waitTapOcr = true;
//   bool _showTextOcr = true;
//   Size? _previewOcr;
//   List<OcrText> _textsOcr = [];
//
//   int? _cameraFace = FlutterMobileVision.CAMERA_FRONT;
//   bool _autoFocusFace = true;
//   bool _torchFace = false;
//   bool _multipleFace = true;
//   bool _showTextFace = true;
//   Size? _previewFace;
//   List<Face> _faces = [];
//
//   ///
//   ///
//   ///
//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//     FlutterMobileVision.start().then((previewSizes) => setState(() {
//       if (previewSizes[_cameraBarcode] == null) {
//         return;
//       }
//       _previewBarcode = previewSizes[_cameraBarcode]!.first;
//       _previewOcr = previewSizes[_cameraOcr]!.first;
//       _previewFace = previewSizes[_cameraFace]!.first;
//     }));
//   }
//
//   ///
//   ///
//   ///
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         primarySwatch: Colors.lime,
//         buttonColor: Colors.lime,
//       ),
//       home: DefaultTabController(
//         length: 3,
//         child: Scaffold(
//           appBar: AppBar(
//             bottom: TabBar(
//               indicatorColor: Colors.black54,
//               tabs: [Tab(text: 'OCR')],
//             ),
//             title: Text('Flutter Mobile Vision'),
//           ),
//           body: TabBarView(children: [
//             _getOcrScreen(context),
//           ]),
//         ),
//       ),
//     );
//   }
//
//   ///
//   /// Scan formats
//   ///
//   List<DropdownMenuItem<int>> _getFormats() {
//     List<DropdownMenuItem<int>> formatItems = [];
//
//     Barcode.mapFormat.forEach((key, value) {
//       formatItems.add(
//         DropdownMenuItem(
//           child: Text(value),
//           value: key,
//         ),
//       );
//     });
//
//     return formatItems;
//   }
//
//   ///
//   /// Camera list
//   ///
//   List<DropdownMenuItem<int>> _getCameras() {
//     List<DropdownMenuItem<int>> cameraItems = [];
//
//     cameraItems.add(DropdownMenuItem(
//       child: Text('BACK'),
//       value: FlutterMobileVision.CAMERA_BACK,
//     ));
//
//     cameraItems.add(DropdownMenuItem(
//       child: Text('FRONT'),
//       value: FlutterMobileVision.CAMERA_FRONT,
//     ));
//
//     return cameraItems;
//   }
//
//   ///
//   /// Preview sizes list
//   ///
//   List<DropdownMenuItem<Size>> _getPreviewSizes(int facing) {
//     List<DropdownMenuItem<Size>> previewItems = [];
//
//     List<Size>? sizes = FlutterMobileVision.getPreviewSizes(facing);
//
//     if (sizes != null) {
//       sizes.forEach((size) {
//         previewItems.add(
//           DropdownMenuItem(
//             child: Text(size.toString()),
//             value: size,
//           ),
//         );
//       });
//     } else {
//       previewItems.add(
//         DropdownMenuItem(
//           child: Text('Empty'),
//           value: null,
//         ),
//       );
//     }
//
//     return previewItems;
//   }
//
//   ///
//   /// OCR Screen
//   ///
//   Widget _getOcrScreen(BuildContext context) {
//     List<Widget> items = [];
//
//     items.add(Padding(
//       padding: const EdgeInsets.only(
//         top: 8.0,
//         left: 18.0,
//         right: 18.0,
//       ),
//       child: const Text('Camera:'),
//     ));
//
//     items.add(Padding(
//       padding: const EdgeInsets.only(
//         left: 18.0,
//         right: 18.0,
//       ),
//       child: DropdownButton<int>(
//         items: _getCameras(),
//         onChanged: (value) {
//           _previewOcr = null;
//           setState(() => _cameraOcr = value);
//         },
//         value: _cameraOcr,
//       ),
//     ));
//
//     items.add(Padding(
//       padding: const EdgeInsets.only(
//         top: 8.0,
//         left: 18.0,
//         right: 18.0,
//       ),
//       child: const Text('Preview size:'),
//     ));
//
//     items.add(Padding(
//       padding: const EdgeInsets.only(
//         left: 18.0,
//         right: 18.0,
//       ),
//       child: DropdownButton<Size>(
//         items: _getPreviewSizes(_cameraOcr ?? 0),
//         onChanged: (value) {
//           setState(() => _previewOcr = value);
//         },
//         value: _previewOcr,
//       ),
//     ));
//
//     items.add(SwitchListTile(
//       title: const Text('Auto focus:'),
//       value: _autoFocusOcr,
//       onChanged: (value) => setState(() => _autoFocusOcr = value),
//     ));
//
//     items.add(SwitchListTile(
//       title: const Text('Torch:'),
//       value: _torchOcr,
//       onChanged: (value) => setState(() => _torchOcr = value),
//     ));
//
//     items.add(SwitchListTile(
//       title: const Text('Return all texts:'),
//       value: _multipleOcr,
//       onChanged: (value) => setState(() => _multipleOcr = value),
//     ));
//
//     items.add(SwitchListTile(
//       title: const Text('Capture when tap screen:'),
//       value: _waitTapOcr,
//       onChanged: (value) => setState(() => _waitTapOcr = value),
//     ));
//
//     items.add(SwitchListTile(
//       title: const Text('Show text:'),
//       value: _showTextOcr,
//       onChanged: (value) => setState(() => _showTextOcr = value),
//     ));
//
//     items.add(
//       Padding(
//         padding: const EdgeInsets.only(
//           left: 18.0,
//           right: 18.0,
//           bottom: 12.0,
//         ),
//         child: ElevatedButton(
//           onPressed: _read,
//           child: Text('READ!'),
//         ),
//       ),
//     );
//
//     items.addAll(
//       ListTile.divideTiles(
//         context: context,
//         tiles: _textsOcr
//             .map(
//               (ocrText) => OcrTextWidget(ocrText),
//         )
//             .toList(),
//       ),
//     );
//
//     return ListView(
//       padding: const EdgeInsets.only(
//         top: 12.0,
//       ),
//       children: items,
//     );
//   }
//
//   ///
//   /// OCR Method
//   ///
//   Future<Null> _read() async {
//     List<OcrText> texts = [];
//     Size _scanpreviewOcr = _previewOcr ?? FlutterMobileVision.PREVIEW;
//     try {
//       texts = await FlutterMobileVision.read(
//         flash: _torchOcr,
//         autoFocus: _autoFocusOcr,
//         multiple: _multipleOcr,
//         waitTap: _waitTapOcr,
//         //OPTIONAL: close camera after tap, even if there are no detection.
//         //Camera would usually stay on, until there is a valid detection
//         forceCloseCameraOnTap: true,
//         //OPTIONAL: path to save image to. leave empty if you do not want to save the image
//         imagePath: '',
//         showText: _showTextOcr,
//         preview: _previewOcr ?? FlutterMobileVision.PREVIEW,
//         scanArea: Size(_scanpreviewOcr.width - 20, _scanpreviewOcr.height - 20),
//         camera: _cameraOcr ?? FlutterMobileVision.CAMERA_BACK,
//         fps: 2.0,
//       );
//       String finaltext = "";
//       for(var text in texts){
//         finaltext += text.value;
//       }
//       TTS().speak(finaltext);
//     } on Exception {
//       texts.add(OcrText('Failed to recognize text.'));
//       TTS().speak('Failed to recognize text');
//     }
//
//     if (!mounted) return;
//
//     setState(() => _textsOcr = texts);
//   }
// }
//
// ///
// /// OcrTextWidget
// ///
// class OcrTextWidget extends StatelessWidget {
//   final OcrText ocrText;
//
//   OcrTextWidget(this.ocrText);
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: const Icon(Icons.title),
//       title: Text(ocrText.value),
//       subtitle: Text(ocrText.language),
//       trailing: const Icon(Icons.arrow_forward),
//       onTap: () => Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (context) => OcrTextDetail(ocrText),
//         ),
//       ),
//     );
//   }
// }


import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter/material.dart';
import 'obj_camera_service.dart';
import 'package:client/locator.dart';
import 'package:client/tts.dart';
// import 'package:image/image.dart';

class OBJ extends StatefulWidget {
  const OBJ({Key? key}) : super(key: key);

  @override
  OBJState createState() => OBJState();
}

class OBJState extends State<OBJ> {
  String? imagePath;
  Face? faceDetected;
  Size? imageSize;

  bool _detectingFaces = false;
  bool pictureTaken = false;
  bool _initializing = false;

  bool _saving = false;
  bool _bottomSheetVisible = false;
  final mode = DetectionMode.stream;
  var objectDetector;
  // service injection
  OBJCameraService _cameraService = locator<OBJCameraService>();
  @override
  void initState() {
    super.initState();
    objectDetector = GoogleMlKit.vision.objectDetector(options: ObjectDetectorOptions(mode: DetectionMode.stream, classifyObjects: true, multipleObjects: true));
    _start();
  }

  @override
  void dispose() async{
    _cameraService.dispose();
    super.dispose();
  }

  _start() async {
    _cameraService.initialize();
    _frameFaces();
  }

  void onShot() async {
    // XFile? image = await _cameraService.takePicture();
    // final WriteBuffer allBytes = WriteBuffer();
    // for (final Plane plane in image.planes) {
    //   allBytes.putUint8List(plane.bytes);
    // }
    // final bytes = allBytes.done().buffer.asUint8List();
    // final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
    // var description = await _cameraService.getCameraDescription();
    // final InputImageRotation? imageRotation = InputImageRotationValue.fromRawValue(description.sensorOrientation);
    //
    // final InputImageFormat? inputImageFormat = InputImageFormatValue.fromRawValue(image.format.raw);
    //
    // final planeData = image.planes.map(
    //       (Plane plane) {
    //     return InputImagePlaneMetadata(
    //       bytesPerRow: plane.bytesPerRow,
    //       height: plane.height,
    //       width: plane.width,
    //     );
    //   },
    // ).toList();
    //
    // final inputImageData = InputImageData(
    //   size: imageSize,
    //   imageRotation: imageRotation!,
    //   inputImageFormat: inputImageFormat!,
    //   planeData: planeData,
    // );
    //
    // final inputImage = InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
    // XFile finalImage = image!;
    // final inputImage = InputImage.fromFilePath(finalImage.path);
    //
  }

  _frameFaces() async{
    bool processing = false;
    imageSize = _cameraService.getImageSize();

    _cameraService.cameraController?.startImageStream((image) async {
      if (_cameraService.cameraController != null) {
        final WriteBuffer allBytes = WriteBuffer();
        for (final Plane plane in image.planes) {
          allBytes.putUint8List(plane.bytes);
        }
        final bytes = allBytes.done().buffer.asUint8List();
        final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
        var description = await _cameraService.getCameraDescription();
        final InputImageRotation? imageRotation = InputImageRotationValue.fromRawValue(description.sensorOrientation);

        final InputImageFormat? inputImageFormat = InputImageFormatValue.fromRawValue(image.format.raw);

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
          imageRotation: imageRotation!,
          inputImageFormat: inputImageFormat!,
          planeData: planeData,
        );

        final inputImage = InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
        // // XFile? image = await _cameraService.takePicture();
        // // XFile finalImage = image!;
        // // final inputImage = InputImage.fromFilePath(finalImage.path);
        // final textDetector = GoogleMlKit.vision.textRecognizer();
        // RecognizedText recognizedText = await textDetector.processImage(inputImage);
        // String scannedText = "";
        // for(TextBlock block in recognizedText.blocks){
        //   print("coooooooordinaaaaaaaaaaateeeeeesssssssssssssssssss");
        //   print(block.cornerPoints);
        //   if(block.cornerPoints[0].x < 10 || block.cornerPoints[3].x < 15){
        //     await TTS().speak("Move camera Left");
        //   }
        //   if(block.cornerPoints[1].x < 15 || block.cornerPoints[2].x < 15){
        //     await TTS().speak("Move camera Right");
        //   }
        // }
        final List<DetectedObject> objects = await objectDetector.processImage(inputImage);

        for(DetectedObject detectedObject in objects){
          final rect = detectedObject.boundingBox;
          final trackingId = detectedObject.trackingId;

          for(Label label in detectedObject.labels){
            print('==============================================================');
            print('${label.text} ${label.confidence}');
            print('==============================================================');
          }
        }

      }
    });
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
          FloatingActionButton(onPressed: onShot)
        ],
      ),
    );
  }
}
