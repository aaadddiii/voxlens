import 'package:flutter/material.dart';
import 'document_reader.dart';
import 'currency_detector.dart';
import 'tts.dart';
import 'package:alan_voice/alan_voice.dart';
import 'navigation.dart';

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
                    style: TextStyle(
                        color: Colors.white
                    ),),
                  padding: EdgeInsets.all(20.0),
                  margin: EdgeInsets.all(10.0),
                  // color: Colors.red[300],
                  decoration: BoxDecoration(
                      color: Colors.grey[900],
                      border: Border.all(width: 3,color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow : [BoxShadow(color: Colors.black,spreadRadius: 2,blurRadius: 8,offset:Offset(4,4)),
                      BoxShadow(color: Colors.grey,spreadRadius: 1,blurRadius: 8,offset:Offset(-4,-4))],

                  ),
                )),
              ),
              GestureDetector(
                onTap: () {
                  // TTS().speak("navigation");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return Navigation();
                      }));
                },
                child: Expanded(child: Container(
                  child: Text('Navigation',
                    style: TextStyle(
                        color: Colors.white
                    ),),
                  padding: EdgeInsets.all(20.0),
                  margin: EdgeInsets.all(10.0),
                  // color: Colors.red[300],
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return Currency_detector();
                      }));
                },
                child: Expanded(child: Container(
                  child: Text('Currency Detector',
                    style: TextStyle(
                        color: Colors.white
                    ),),
                  padding: EdgeInsets.all(20.0),
                  margin: EdgeInsets.all(10.0),
                  // color: Colors.red[300],
                  decoration: BoxDecoration(
                      color: Colors.grey[900],
                    border: Border.all(width: 3,color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow : [BoxShadow(color: Colors.black,spreadRadius: 2,blurRadius: 8,offset:Offset(4,4)),
                      BoxShadow(color: Colors.grey,spreadRadius: 1,blurRadius: 8,offset:Offset(-4,-4))],
                  ),
                )),
              ),
              Expanded(child: Container(
                child: Text('Face Detection',
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
                padding: EdgeInsets.all(20.0),
                margin: EdgeInsets.all(10.0),
                // color: Colors.red[300],
                decoration: BoxDecoration(
                    color: Colors.grey[900],
                  border: Border.all(width: 3,color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow : [BoxShadow(color: Colors.black,spreadRadius: 2,blurRadius: 8,offset:Offset(4,4)),
                    BoxShadow(color: Colors.grey,spreadRadius: 1,blurRadius: 8,offset:Offset(-4,-4))],
                ),
              )),
            ],
          ),
          flex: 2,),
          GestureDetector(
            child: Flexible(child: Expanded(child: Container(
              child: Text('Favourites',
                style: TextStyle(
                    color: Colors.white
                ),),
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.all(10.0),
              // color: Colors.red[300],
              decoration: BoxDecoration(
                  color: Colors.grey[900],
                border: Border.all(width: 3,color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(15)),
                boxShadow : [BoxShadow(color: Colors.black,spreadRadius: 2,blurRadius: 8,offset:Offset(4,4)),
                  BoxShadow(color: Colors.grey,spreadRadius: 1,blurRadius: 8,offset:Offset(-4,-4))],
              ),
            )),
            flex: 1,),
          )
        ],
      ),

    );
  }
}