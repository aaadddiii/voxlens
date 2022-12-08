import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

import '../tts.dart';
import 'coordinates_translator.dart';

class ObjectDetectorPainter extends CustomPainter {
  ObjectDetectorPainter(this._objects, this.rotation, this.absoluteSize);
  var tts = TTS();
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
    },
    "Calculator": {
      // "cornerPoints" : [235.0, 327.0, 416.0, 645.0],
      // "distance": 0.5
      "ratio" : 28779.0
    },
    "Person": {
      // "cornerPoints" : [196.0, 298.0, 496.0, 1206.0],
      // "distance" : 2.0
      "ratio" : 544800.0
    },
    "Bench" : {
      // "cornerPoints" : [73.0, 30.0, 577.0, 419.0],
      // "distance" : 3.5
      "ratio" : 686196.0
    },
    "Chair" : {
      // "cornerPoints" : [165.0, 133.0, 446.0, 556.0],
      // "distance" : 2
      "ratio" : 237726.0
    },
    "Backpack" : {
      // "cornerPoints" : [280.0, 797.0, 482.0, 1070.0],
      // "distance" : 2
      "ratio" : 110292.0

    },
    "Pen" : {
      // "cornerPoints" : [257.0, 547.0, 315.0, 878.0],
      // "distance" : 0.5
      "ratio" : 65308.0
    },
    "Notebook" : {
      // "cornerPoints" : [167.0, 269.0, 720.0, 1193.0],
      // "distance" : 0.5
      "ratio" : 255486.0
    },
    "Table" :{
      //"cornerPoints":[21.0, 318.0, 663.0, 849.0],
      //"distance":1.5
      "ratio" :511353.0
    },

    "Mobile phone" :{
      //"cornerPoints":[290.0, 630.0, 413.0, 844.0],
      //"distance":0.75
      "ratio" :19741.5
    },

    "Laptop" :{
      //"cornerPoints":[140.0, 151.0, 610.0, 450.0],
      //"distance":0.75
      "ratio" :105397.5
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
        builder.addText('${label.text}\n');
        if(object_features.containsKey(label.text)) {
          // var sample_bounding_box = object_features[label.text]!["cornerPoints"] as List;
          // var sample_dist = object_features[label.text]!["cornerPoints"] as double;
          // var area = (sample_bounding_box[2] - sample_bounding_box[0])*(sample_bounding_box[3] - sample_bounding_box[1]);
          try{
            double ratio = object_features[label.text]!["ratio"] as double;
            double distance = ratio/bounding_box_area;
            String? dist;
            if(distance < 1.0){
              dist = distance.toStringAsFixed(1);
            }
            else{
              dist = distance.toStringAsFixed(0);
            }
            if(tts.state == 0){
              Future.delayed(const Duration(milliseconds: 500),);
              tts.speak("${label.text} is {$dist} metre away");
            }
            builder.addText('distance ${dist}\n');
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