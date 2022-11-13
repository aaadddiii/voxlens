import 'package:client/face_recognition/camera_service.dart';
import 'package:get_it/get_it.dart';
import 'package:client/face_recognition/face_detector_service.dart';
import 'package:client/face_recognition/ml_services.dart';
import 'edge_detection/ocr_camera_service.dart';
import 'object_detection/obj_camera_service.dart';

final locator = GetIt.instance;

void setupServices() {
  locator.registerLazySingleton<CameraService>(() => CameraService());
  locator.registerLazySingleton<FaceDetectorService>(() => FaceDetectorService());
  locator.registerLazySingleton<MLService>(() => MLService());
  // locator.registerLazySingleton<OCRCameraService>(() => OCRCameraService());
  locator.registerLazySingleton<OBJCameraService>(() => OBJCameraService());
}
