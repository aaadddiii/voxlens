import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:client/tts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:read_pdf_text/read_pdf_text.dart';
import 'package:alan_voice/alan_voice.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'face_rec.dart';



class FaceUI extends StatefulWidget {
  const FaceUI({Key? key}) : super(key: key);

  @override
  State<FaceUI> createState() => _FaceUIState();
}

class _FaceUIState extends State<FaceUI> {


  XFile? imageFile;
  String scannedText="";
  TextEditingController reg = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
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
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              GestureDetector(
                onTap: (){
                  getImage();
                },
                child: Expanded(
                    child: Container(
                      child: Text('Face Recognition',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                        ),),
                      padding: EdgeInsets.all(15.0),
                      margin: EdgeInsets.all(10.0),
                      width: MediaQuery.of(context).size.width/1.1,
                      height: MediaQuery.of(context).size.height/4,
                      // color: Colors.grey[900],
                      decoration: BoxDecoration(
                        color: Colors.lightBlueAccent,
                        //border: Border.all(width: 3,color: Colors.black),
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
            crossAxisAlignment: CrossAxisAlignment.center,

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
                    getImage();
                  }
                },
                child: Expanded(
                    child: Container(
                      child: Text('Register Face',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                        ),),
                      padding: EdgeInsets.all(15.0),
                      margin: EdgeInsets.all(10.0),
                      width: MediaQuery.of(context).size.width/1.1,
                      height: MediaQuery.of(context).size.height/4,
                      // color: Colors.grey[900],
                      decoration: BoxDecoration(
                        color: Colors.lightBlueAccent,
                        //border: Border.all(width: 3,color: Colors.black),
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
  void getImage() async{
    try{
      // final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) {
            return FaceRec();
          }));
    } catch(e){
      print("Error occured");
    }
  }
}
