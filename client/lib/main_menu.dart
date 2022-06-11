import 'package:client/currency_detector.dart';
import 'package:flutter/material.dart';
import 'document_reader.dart';
import 'currency_detector.dart';
import 'tts.dart';

class Main_menu extends StatelessWidget {
  const Main_menu({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[600],
        title: Text('Voxlens'),
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
                  child: Text('doc reader'),
                  padding: EdgeInsets.all(30.0),
                  margin: EdgeInsets.all(20.0),
                  color: Colors.grey[600],
                )),
              ),
              GestureDetector(
                onTap: () {
                  TTS().speak("navigation");
                },
                child: Expanded(child: Container(
                  child: Text('navigation'),
                  padding: EdgeInsets.all(30.0),
                  margin: EdgeInsets.all(20.0),
                  color: Colors.grey[600],
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
                  child: Text('Currency Detect'),
                  padding: EdgeInsets.all(30.0),
                  margin: EdgeInsets.all(20.0),
                  color: Colors.grey[600],
                )),
              ),
              Expanded(child: Container(
                child: Text('Face detection'),
                padding: EdgeInsets.all(30.0),
                margin: EdgeInsets.all(20.0),
                color: Colors.grey[600],
              )),
            ],
          ),
          flex: 2,),
          Flexible(child: Expanded(child: Container(
            child: Text('Favorites'),
            padding: EdgeInsets.all(30.0),
            margin: EdgeInsets.all(20.0),
            color: Colors.grey[600],
          )),
          flex: 1,)
        ],
      )
    );
  }
}