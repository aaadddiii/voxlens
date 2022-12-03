import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'document_reader.dart';
import 'currency_detector.dart';
import 'tts.dart';
import 'package:alan_voice/alan_voice.dart';
import 'navigation.dart';
import 'object_detection.dart';
import 'face_recognition/face_ui.dart';
import 'distance_calculation/object_detect.dart';

class Main_menu extends StatefulWidget {
  const Main_menu({Key? key}) : super(key: key);

  @override
  State<Main_menu> createState() => _Main_menuState();
}

class _Main_menuState extends State<Main_menu> {
  void initState() {
    super.initState();
    AlanVoice.deactivate();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => TTS().speak("Use doc-reader to read texts and images"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text('VoxLens'),
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return Doc_Reader();
                      }));
                },
                child: Expanded(child: Container(
                  child: Text('Doc Reader',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),),
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width/1.3,
                  height: MediaQuery.of(context).size.height/4,
                  // color: Colors.red[300],
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    border: Border.all(width: 3,color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow : [BoxShadow(color: Colors.black,spreadRadius: 2,blurRadius: 8,offset:Offset(8,8)),
                      BoxShadow(color: Colors.grey,spreadRadius: 1,blurRadius: 8,offset:Offset(-8,-8))],

                  ),
                )),
              ),
              // GestureDetector(
              //   onTap: () {
              //     // TTS().speak("navigation");
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) {
              //           return Navigation();
              //         }));
              //   },
              //   child: Expanded(child: Container(
              //     child: Text('Navigation',
              //       style: TextStyle(
              //           color: Colors.white
              //       ),),
              //     padding: EdgeInsets.all(10.0),
              //     margin: EdgeInsets.all(10.0),
              //     // color: Colors.red[300],
              //     decoration: BoxDecoration(
              //         color: Colors.grey[900],
              //         border: Border.all(width: 3,color: Colors.black),
              //       borderRadius: BorderRadius.all(Radius.circular(15)),
              //       boxShadow : [BoxShadow(color: Colors.black,spreadRadius: 2,blurRadius: 8,offset:Offset(8,8)),
              //         BoxShadow(color: Colors.grey,spreadRadius: 1,blurRadius: 8,offset:Offset(-8,-8))],
              //     ),
              //   )),
              // ),
            ],
          ),
            flex: 2,),
          Flexible(child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // GestureDetector(
              //   onTap: (){
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) {
              //           return Currency_detector();
              //         }));
              //   },
              //  child: Expanded(child: Container(
              //     child: Text('Currency Detector',
              //       style: TextStyle(
              //           color: Colors.white
              //       ),),
              //     padding: EdgeInsets.all(15.0),
              //     margin: EdgeInsets.all(10.0),
              //     // color: Colors.red[300],
              //     decoration: BoxDecoration(
              //         color: Colors.grey[900],
              //       border: Border.all(width: 3,color: Colors.black),
              //       borderRadius: BorderRadius.all(Radius.circular(15)),
              //       boxShadow : [BoxShadow(color: Colors.black,spreadRadius: 2,blurRadius: 8,offset:Offset(8,8)),
              //         BoxShadow(color: Colors.grey,spreadRadius: 1,blurRadius: 8,offset:Offset(-8,-8))],
              //     ),
              //   )),
              // ),
              GestureDetector(
                onTap:() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return ObjectDetection();
                      }));
                },
                child: Expanded(child: Container(
                  child: Text('Object Detection',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width/1.3,
                  height: MediaQuery.of(context).size.height/4,
                  // color: Colors.red[300],
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    border: Border.all(width: 3,color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow : [BoxShadow(color: Colors.black,spreadRadius: 2,blurRadius: 8,offset:Offset(8,8)),
                      BoxShadow(color: Colors.grey,spreadRadius: 1,blurRadius: 8,offset:Offset(-8,-8))],
                  ),
                )),
              ),
            ],
          ),
            flex: 2,),
          Flexible(child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [GestureDetector(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                      return FaceUI();
                    }));
              },
              child: Expanded(child: Container(
                child: Text('Face Recognition',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),),
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width/1.3,
                height: MediaQuery.of(context).size.height/4,
                // color: Colors.red[300],
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  border: Border.all(width: 3,color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow : [BoxShadow(color: Colors.black,spreadRadius: 2,blurRadius: 8,offset:Offset(8,8)),
                    BoxShadow(color: Colors.grey,spreadRadius: 1,blurRadius: 8,offset:Offset(-8,-8))],
                ),
              )),
               // flex: 1
            ),],),
            flex: 2,),
          Flexible(child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [GestureDetector(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return DistanceCalculatorView();
                      }));
                },
                child: Expanded(child: Container(
                  child: Text('Distance calculation',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),),
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width/1.3,
                  height: MediaQuery.of(context).size.height/4,
                  // color: Colors.red[300],
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    border: Border.all(width: 3,color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow : [BoxShadow(color: Colors.black,spreadRadius: 2,blurRadius: 8,offset:Offset(8,8)),
                      BoxShadow(color: Colors.grey,spreadRadius: 1,blurRadius: 8,offset:Offset(-8,-8))],
                  ),
                )),
                //  flex: 1
              )]),
        flex: 2,),
        ],
      ),
    );
  }
}