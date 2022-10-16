import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
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



class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {


  XFile? imageFile;
  String scannedText="";
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
        children:[
          Flexible(child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
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
                        border: Border.all(width: 3,color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        boxShadow : [BoxShadow(color: Colors.black,spreadRadius: 2,blurRadius: 8,offset:Offset(4,4)),
                          BoxShadow(color: Colors.grey,spreadRadius: 1,blurRadius: 8,offset:Offset(-4,-4))],
                      ),
                    )),
              ),
            ],
          ),
            flex: 2,),
          Flexible(child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  if(reg.text == ""){
                    showDialog(context: context, builder: (BuildContext context){
                      return AlertDialog(
                        title: Text("Enter a Name for the face"),
                      );
                    });
                  }
                  else{
                    registerFace(reg.text);
                  }
                },
                child: Expanded(
                    child: Container(
                      child: Text('Register Face',
                        style: TextStyle(
                            color: Colors.white
                        ),),
                      padding: EdgeInsets.all(15.0),
                      margin: EdgeInsets.all(10.0),
                      // color: Colors.grey[900],
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        border: Border.all(width: 3,color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        boxShadow : [BoxShadow(color: Colors.black,spreadRadius: 2,blurRadius: 8,offset:Offset(4,4)),
                          BoxShadow(color: Colors.grey,spreadRadius: 1,blurRadius: 8,offset:Offset(-4,-4))],
                      ),
                    )),
              ),
            ],
          ),
            flex: 2,),
          TextField(
            controller: reg,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter Name'
            ),
          )
        ],),
    );
  }

  // XFile? imageFile;
  // String scannedText="";
  void getImage(int stch) async{
    try{

      final pickedImage;
      if(stch == 1){
        pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      }
      else{
        pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
      }
      if(pickedImage != null){
        imageFile = pickedImage;
        _upload(pickedImage);
      }
    } catch(e){
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
    String fileName = file.path.split('/').last;
    print(fileName);

    String endPoint = dotenv.env['END_POINT']!;
    String api_key = dotenv.env['API_KEY']!;
    // Dio dio = new Dio();
    // dio.options.headers["Ocp-Apim-Subscription-Key"] = api_key;
    // dio.options.headers["con"] = api_key;
    // var response = await dio.post(endPoint,data: data);
    // print(response.data);
    // // var text = response.data["description"]["captions"][0]["text"];
    // // TTS().speak(text);
    // print(fileName);

    final uri = Uri.https(endPoint, "face/v1.0/detect");
    final response = await http.post(
      uri,
      body: image.readAsBytesSync(),
      headers: {
        'Ocp-Apim-Subscription-Key': api_key,
        'Content-Type': 'application/octet-stream'
      },
    );
    List<dynamic> res = json.decode(response.body);
    print(res);
    List<String> faceIds = [];
    for (var i = 0; i < res.length; i++) {
      // TO DO
      faceIds.add(res[i]["faceId"]);
    }
    print(faceIds);
    _identify(faceIds);
    print("printing .. ++ __ -- upload");
  }

  void _identify(List<String> faceIds) async{
    String endPoint = dotenv.env['END_POINT']!;
    String api_key = dotenv.env['API_KEY']!;
    var uri = Uri.https(endPoint, "face/v1.0/identify");
    var response = await http.post(
      uri,
      body: jsonEncode({
        "PersonGroupId": "vox_lens",
        "faceIds": faceIds,
        "maxNumOfCandidatesReturned": 1,
        "confidenceThreshold": 0.5
      }),
      headers: {
        'Ocp-Apim-Subscription-Key': api_key,
        'Content-Type': 'application/json'
      },
    );
    List<dynamic> res2 = json.decode(response.body);
    get_name(res2);
  }

  void get_name(List<dynamic> person_info) async{
    String endPoint = dotenv.env['END_POINT']!;
    String api_key = dotenv.env['API_KEY']!;
    for(var i=0;i<person_info.length;i++){
      var info = person_info[i]["candidates"];
      print("Information===========");
      print(info);
      if(info.length != 0){
        String personId = info[0]["personId"];
        var url = Uri.https(endPoint, "/face/v1.0/persongroups/vox_lens/persons/" + personId);
        var response = await http.get(
          url,
          headers: {
            'Ocp-Apim-Subscription-Key': api_key,
            'Content-Type': 'application/json'
          },
        );
        Map<String,dynamic> res2 = json.decode(response.body);
        print(res2);
        TTS().speak("Found " + res2["name"]);
      }
    }
  }

  void registerFace(String name) async{
    print("Registering ... " + name);
    String endPoint = dotenv.env['END_POINT']!;
    String api_key = dotenv.env['API_KEY']!;
    XFile? pickedImage;
    try{
      pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
      if(pickedImage != null){
        imageFile = pickedImage;
      }
    } catch(e){
      print("Error occured");
    }
    File image = File(pickedImage!.path);
    var uri = Uri.https(endPoint, "face/v1.0/detect");
    var response = await http.post(
      uri,
      body: image.readAsBytesSync(),
      headers: {
        'Ocp-Apim-Subscription-Key': api_key,
        'Content-Type': 'application/octet-stream'
      },
    );
    List<dynamic> res = json.decode(response.body);
    print(res[0]["faceId"]);
    if(res.length != 1){
      showDialog(context: context, builder: (BuildContext context){
        return AlertDialog(
          title: Text("More than one face in the scene"),
        );
      });
    }
    else {
      var uri_name_reg = Uri.https(endPoint, "face/v1.0/persongroups/vox_lens/persons");
      var response_name_reg = await http.post(
        uri_name_reg,
        body: jsonEncode({
            "name" : name
        }),
        headers: {
          'Ocp-Apim-Subscription-Key': api_key,
          'Content-Type': 'application/json'
        },
      );
      Map<String, dynamic> res2 = json.decode(response_name_reg.body);
      String personId = res2["personId"];
      add_face(personId, pickedImage);
    }
    print("printing .. ++ __ -- reg");
  }

  void add_face(String personId, XFile? pickedImage) async{
    String endPoint = dotenv.env['END_POINT']!;
    String api_key = dotenv.env['API_KEY']!;
    File image = File(pickedImage!.path);
    var uri = Uri.https(endPoint, "face/v1.0/persongroups/vox_lens/persons/" + personId +"/persistedFaces");
    var response = await http.post(
    uri,
    body: image.readAsBytesSync(),
    headers: {
    'Ocp-Apim-Subscription-Key': api_key,
    'Content-Type': 'application/octet-stream'
    },
    );
    Map<String,dynamic> res = json.decode(response.body);
    print("persistant face id");
    print(res);
    train();
  }
  void train() async{
    print("Training...");
    String endPoint = dotenv.env['END_POINT']!;
    String api_key = dotenv.env['API_KEY']!;
    var uri = Uri.https(endPoint, "face/v1.0/persongroups/vox_lens/train");
    var response = await http.post(
      uri,
      headers: {
        'Ocp-Apim-Subscription-Key': api_key,
        'Content-Type': 'application/json'
      },
    );
    print("Training over");
    TTS().speak("registered");
  }

}
