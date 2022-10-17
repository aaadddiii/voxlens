import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'tts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:read_pdf_text/read_pdf_text.dart';
import 'package:alan_voice/alan_voice.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;



class ObjectDetection extends StatefulWidget {
  const ObjectDetection({Key? key}) : super(key: key);

  @override
  State<ObjectDetection> createState() => _ObjectDetectionState();
}

class _ObjectDetectionState extends State<ObjectDetection> {


  XFile? imageFile;
  String scannedText = "";
  TextEditingController reg = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text('Voxlens',
          style: TextStyle(
              color: Colors.white
          ),),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  getImage(0);
                },
                child: Expanded(
                    child: Container(
                      child: Text('Face Recognition',
                        style: TextStyle(
                            color: Colors.white
                        ),),
                      padding: EdgeInsets.all(15.0),
                      margin: EdgeInsets.all(10.0),
                      // color: Colors.grey[900],
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        border: Border.all(width: 3, color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        boxShadow: [BoxShadow(color: Colors.black,
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: Offset(4, 4)),
                          BoxShadow(color: Colors.grey,
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: Offset(-4, -4))
                        ],
                      ),
                    )),
              ),
            ],
          ),
            flex: 2,)
            ],
          ),
    );
  }

  // XFile? imageFile;
  // String scannedText="";
  void getImage(int stch) async {
    try {
      final pickedImage;
      if (stch == 1) {
        pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
      }
      else {
        pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
      }
      if (pickedImage != null) {
        imageFile = pickedImage;
        _upload(pickedImage);
      }
    } catch (e) {
      print("Error occured");
    }
  }

// void recognizeText(XFile image) async{
//   final inputImage = InputImage.fromFilePath(image.path);
//   final textDetector = GoogleMlKit.vision.textRecognizer();
//   RecognizedText recognizedText = await textDetector.processImage(inputImage);
//   await textDetector.close();
//   scannedText = "";
//   for(TextBlock block in recognizedText.blocks){
//     for(TextLine line in block.lines){
//       TTS().speak(line.text);
//       scannedText = scannedText + line.text + "\n";
//     }
//   }
//   print(scannedText);
//   TTS().speak(scannedText);
// }

  void _upload(XFile file) async {
    File image = File(file.path);
    String fileName = file.path
        .split('/')
        .last;
    print(fileName);
    var data = {
      "image" : image
    };
    String endPoint = dotenv.env['END_POINT2']!;
    String api_key = dotenv.env['API_KEY2']!;
    Dio dio = new Dio();
    dio.options.headers["Ocp-Apim-Subscription-Key"] = api_key;
    dio.options.headers["con"] = api_key;
    var response = await dio.post(endPoint,data: data);
    print(response.data);
    var text = response.data["description"]["captions"][0]["text"];
    TTS().speak(text);
    print(fileName);
    print("printing .. ++ __ -- upload");
  }
}