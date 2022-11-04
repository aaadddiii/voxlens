import 'package:client/face_recognition/camera_service.dart';
import 'package:get_it/get_it.dart';
import 'package:client/face_recognition/face_detector_service.dart';
import 'package:client/face_recognition/ml_services.dart';

final locator = GetIt.instance;

void setupServices() {
  locator.registerLazySingleton<CameraService>(() => CameraService());
  locator.registerLazySingleton<FaceDetectorService>(() => FaceDetectorService());
  locator.registerLazySingleton<MLService>(() => MLService());
}
