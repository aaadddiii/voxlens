import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

import '../tts.dart';
import 'coordinates_translator.dart';

class ObjectDetectorPainter extends CustomPainter {
  ObjectDetectorPainter(this._objects, this.rotation, this.absoluteSize);

  final List<DetectedObject> _objects;
  final Size absoluteSize;
  final InputImageRotation rotation;
  var object_features = {
    "Bottle": {
      // "cornerPoints": [284.0, 357.0, 431.0, 852.0],
      // "distance": 0.5
      "ratio": 36382.5
    },
    "Tableware": {
      // "cornerPoints": [284.0, 357.0, 431.0, 852.0],
      // "distance": 0.5
      "ratio": 36382.5
    }
  };

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.lightGreenAccent;

    final Paint background = Paint()..color = Color(0x99000000);

    for (final DetectedObject detectedObject in _objects) {
      var boundingbox = [detectedObject.boundingBox.left,detectedObject.boundingBox.top, detectedObject.boundingBox.right, detectedObject.boundingBox.bottom];
      var bounding_box_area = (boundingbox[2] - boundingbox[0])*(boundingbox[3] - boundingbox[1]);
      final ParagraphBuilder builder = ParagraphBuilder(
        ParagraphStyle(
            textAlign: TextAlign.left,
            fontSize: 16,
            textDirection: TextDirection.ltr),
      );
      builder.pushStyle(
          ui.TextStyle(color: Colors.lightGreenAccent, background: background));

      for (final Label label in detectedObject.labels) {
        // builder.addText('${label.text} ${label.confidence}\n');
        if(object_features.containsKey(label.text)) {
          // var sample_bounding_box = object_features[label.text]!["cornerPoints"] as List;
          // var sample_dist = object_features[label.text]!["cornerPoints"] as double;
          // var area = (sample_bounding_box[2] - sample_bounding_box[0])*(sample_bounding_box[3] - sample_bounding_box[1]);
          try{
            double ratio = object_features[label.text]!["ratio"] as double;
            double distance = ratio/bounding_box_area;
            builder.addText('distance ${distance}\n');
          }
          catch(e){
            print("catchingggggggggg..........................");
            print(e);
          }
        }
          // TTS().speak(label.text);
      }

      builder.pop();

      final left = translateX(
          detectedObject.boundingBox.left, rotation, size, absoluteSize);
      final top = translateY(
          detectedObject.boundingBox.top, rotation, size, absoluteSize);
      final right = translateX(
          detectedObject.boundingBox.right, rotation, size, absoluteSize);
      final bottom = translateY(
          detectedObject.boundingBox.bottom, rotation, size, absoluteSize);

      canvas.drawRect(
        Rect.fromLTRB(left, top, right, bottom),
        paint,
      );

      canvas.drawParagraph(
        builder.build()
          ..layout(ParagraphConstraints(
            width: right - left,
          )),
        Offset(left, top),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}