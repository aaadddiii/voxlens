import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'locator.dart';
import 'package:client/face_recognition/camera_service.dart';
import 'package:flutter/services.dart';


List<CameraDescription> cameras = [];
Future main() async {
  setupServices();
  await dotenv.load(fileName: ".env");
  cameras = await availableCameras();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MaterialApp(
      theme: ThemeData(
          appBarTheme: AppBarTheme(
        color : Colors.teal[700],
          ),
      ),
    home: Home()
  ));
}
