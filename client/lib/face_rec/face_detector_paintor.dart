import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import '../tts.dart';
import 'coordinates_translator.dart';

class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(this._objects, this.rotation, this.absoluteSize);

  final List<Face> _objects;
  final Size absoluteSize;
  final InputImageRotation rotation;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.lightGreenAccent;

    final Paint background = Paint()..color = Color(0x99000000);

    for (final Face face in _objects) {
      final ParagraphBuilder builder = ParagraphBuilder(
        ParagraphStyle(
            textAlign: TextAlign.left,
            fontSize: 16,
            textDirection: TextDirection.ltr),
      );
      builder.pushStyle(
          ui.TextStyle(color: Colors.lightGreenAccent, background: background));
      int count = 0;
      for (final Face face in _objects) {
        builder.addText('Face ' + count.toString() + '\n');
        // TTS().speak(label.text);
        count++;
      }
      builder.pop();

      final left = translateX(
          face.boundingBox.left, rotation, size, absoluteSize);
      final top = translateY(
          face.boundingBox.top, rotation, size, absoluteSize);
      final right = translateX(
          face.boundingBox.right, rotation, size, absoluteSize);
      final bottom = translateY(
          face.boundingBox.bottom, rotation, size, absoluteSize);

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