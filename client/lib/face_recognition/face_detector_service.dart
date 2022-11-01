import 'package:client/locator.dart';
import 'package:flutter/foundation.dart';
import 'camera_service.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter/material.dart';

class FaceDetectorService {
  CameraService _cameraService = locator<CameraService>();

  late FaceDetector _faceDetector;
  FaceDetector get faceDetector => _faceDetector;

  List<Face> _faces = [];
  List<Face> get faces => _faces;
  bool get faceDetected => _faces.isNotEmpty;

  void initialize() {
    _faceDetector = GoogleMlKit.vision.faceDetector();

    // _faceDetector = FaceDetector(
    //     options: FaceDetectorOptions(
    //         performanceMode: FaceDetectorMode.fast,
    //         enableContours: true,
    //         enableClassification: true));
  }

  Future<void> detectFacesFromImage(CameraImage image) async {
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


    _faces = await _faceDetector.processImage(inputImage);
  }

  dispose() {
    _faceDetector.close();
  }
}
