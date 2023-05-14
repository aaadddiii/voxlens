import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'document_reader.dart';
import 'currency_detector.dart';
import 'object_detection/object_detect.dart';
import 'tts.dart';
import 'package:alan_voice/alan_voice.dart';
import 'navigation.dart';
import 'object_detection.dart';
import 'face_recognition/face_ui.dart';
import 'distance_calculation/object_detect.dart';
import 'face_recognition/face_rec.dart';
import 'face_recognition/recognition_service.dart';
import 'currency_detection/sample.dart';
import 'currency_detection/app.dart';
import 'face_rec/face_detect.dart';
import 'currency_detection/temp_widget/ocr_detection.dart';

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
        .addPostFrameCallback((_) => TTS().speak("Welcome to VoxLens"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal[500],
        title: Text('VoxLens'),
        centerTitle: true,
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Flexible(child: Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return Doc_Reader();
                      }));
                },
                child: Expanded(child: Container(
                  child: Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/doc.png'),
                      Text('Doc Reader',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),),]
                  ),),
                  padding: EdgeInsets.all(15.0),
                  margin: EdgeInsets.all(15.0),

                  width: MediaQuery.of(context).size.width/2.5,
                  height: MediaQuery.of(context).size.height/4,

                  // color: Colors.red[300],
                  decoration: BoxDecoration(
                    color: Colors.teal[300],
                    //border: Border.all(width: 3,color: Colors.blueAccent),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow : [BoxShadow(color: Colors.black,spreadRadius: 1,blurRadius: 4,offset:Offset(3,3)),
                      BoxShadow(color: Colors.grey,spreadRadius: 1,blurRadius: 4,offset:Offset(-3,-3))],

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
              //         color: Colors.teal[300],
              //         border: Border.all(width: 3,color: Colors.black),
              //       borderRadius: BorderRadius.all(Radius.circular(15)),
              //       boxShadow : [BoxShadow(color: Colors.black,spreadRadius: 2,blurRadius: 8,offset:Offset(6,6)),
              //         BoxShadow(color: Colors.grey,spreadRadius: 1,blurRadius: 8,offset:Offset(-6,-6))],
              //     ),
              //   )),
              // ),
              // ],
              // ),
              // flex: 2,),
              // Flexible(child: Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
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
              //         color: Colors.teal[300],
              //       border: Border.all(width: 3,color: Colors.black),
              //       borderRadius: BorderRadius.all(Radius.circular(15)),
              //       boxShadow : [BoxShadow(color: Colors.black,spreadRadius: 2,blurRadius: 8,offset:Offset(6,6)),
              //         BoxShadow(color: Colors.grey,spreadRadius: 1,blurRadius: 8,offset:Offset(-6,-6))],
              //     ),
              //   )),
              // ),
              GestureDetector(
                onTap:() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return ObjectDetectorView();
                      }));
                },
                child: Expanded(child: Container(
                  child: Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/obj.png'),
                        Text('Object Detection',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),),]
                  ),),
                  padding: EdgeInsets.all(15.0),
                  margin: EdgeInsets.all(15.0),

                  width: MediaQuery.of(context).size.width/2.5,
                  height: MediaQuery.of(context).size.height/4,

                  // color: Colors.red[300],
                  decoration: BoxDecoration(
                    color: Colors.teal[300],
                    //border: Border.all(width: 3,color: Colors.blueAccent),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow : [BoxShadow(color: Colors.black,spreadRadius: 1,blurRadius: 4,offset:Offset(3,3)),
                      BoxShadow(color: Colors.grey,spreadRadius: 1,blurRadius: 4,offset:Offset(-3,-3))],
                  ),
                )),
              ),
            ],
          ),


          //   ],
          // ),
          //   flex: 2,),
          // Row(
          //   children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(

                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return FaceDetectorView();
                      }));
                },
                child: Expanded(child: Container(
                  child: Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/face.png', width: 100, height: 100,),
                        Text('Face Recognition',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),),]
                  ),),
                  padding: EdgeInsets.all(15.0),
                  margin: EdgeInsets.all(15.0),

                  width: MediaQuery.of(context).size.width/2.5,
                  height: MediaQuery.of(context).size.height/4,

                  // color: Colors.red[300],
                  decoration: BoxDecoration(
                    color: Colors.teal[300],
                    //border: Border.all(width: 3,color: Colors.blueAccent),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow : [BoxShadow(color: Colors.black,spreadRadius: 1,blurRadius: 4,offset:Offset(3,3)),
                      BoxShadow(color: Colors.grey,spreadRadius: 1,blurRadius: 4,offset:Offset(-3,-3))],
                  ),
                )),
              ),
              // Row(
              //     children: [
              GestureDetector(



                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return DistanceCalculatorView();
                      }));
                },
                child: Expanded(child: Container(
                  child: Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/distance.png'),
                        Text('Distance Calculation',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),),]
                  ),),
                  padding: EdgeInsets.all(15.0),
                  margin: EdgeInsets.all(15.0),

                  width: MediaQuery.of(context).size.width/2.5,
                  height: MediaQuery.of(context).size.height/4,

                  // color: Colors.red[300],
                  decoration: BoxDecoration(
                    color: Colors.teal[300],
                    ////border: Border.all(width: 3,color: Colors.blueAccent),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow : [BoxShadow(color: Colors.black,spreadRadius: 1,blurRadius: 4,offset:Offset(3,3)),
                      BoxShadow(color: Colors.grey,spreadRadius: 1,blurRadius: 4,offset:Offset(-3,-3))],
                  ),
                )),

                //
              ),
            ],
          ),


          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(

                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return MainApp();
                      }));
                },
                child: Expanded(child: Container(
                  child: Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/money.png', width: 100, height: 100,),
                        Text('Currency Detector',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),),]
                  ),),
                  padding: EdgeInsets.all(15.0),
                  margin: EdgeInsets.all(15.0),

                  width: MediaQuery.of(context).size.width/2.5,
                  height: MediaQuery.of(context).size.height/4,

                  // color: Colors.red[300],
                  decoration: BoxDecoration(
                    color: Colors.teal[300],
                    //border: Border.all(width: 3,color: Colors.blueAccent),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow : [BoxShadow(color: Colors.black,spreadRadius: 1,blurRadius: 4,offset:Offset(3,3)),
                      BoxShadow(color: Colors.grey,spreadRadius: 1,blurRadius: 4,offset:Offset(-3,-3))],
                  ),
                )),
              ),
              // Row(

            ],
          )

        ],
      ),),

    );
  }
}