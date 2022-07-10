import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'tts.dart';

class Doc_Reader extends StatefulWidget {
  const Doc_Reader({Key? key}) : super(key: key);

  @override
  State<Doc_Reader> createState() => _Doc_ReaderState();
}

class _Doc_ReaderState extends State<Doc_Reader> {
  XFile? imageFile;
  String scannedText="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        title: Text('Voxlens'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
          Flexible(child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: Container(
                    child: Text('Upload doc'),
                    padding: EdgeInsets.all(30.0),
                    margin: EdgeInsets.all(20.0),
                    color: Colors.red[300],
                  )),
              GestureDetector(
                onTap: () {
                  getImage(1);
                },
                child: Expanded(child: Container(
                  child: Text('Upload image'),
                  padding: EdgeInsets.all(30.0),
                  margin: EdgeInsets.all(20.0),
                  color: Colors.red[300],
                )),
              ),
            ],
          ),
            flex: 2,),
          Flexible(child: Expanded(child: Container(
            child: Text('Scan document'),
            padding: EdgeInsets.all(30.0),
            margin: EdgeInsets.all(20.0),
            color: Colors.red[300],
          )),
            flex: 1,)
        ],),
      floatingActionButton: FloatingActionButton(
        child: Text('Camera'),
        onPressed: () {
          getImage(0);
        },
        backgroundColor: Colors.red[300],
      ),
    );
  }

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
        recognizeText(pickedImage);
      }
    } catch(e){
      print("Error occured");
    }
  }
  void recognizeText(XFile image) async{
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognizedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = "";
    for(TextBlock block in recognizedText.blocks){
      for(TextLine line in block.lines){
        TTS().speak(line.text);
        scannedText = scannedText + line.text + "\n";
      }
    }
    print(scannedText);
    // TTS().speak(scannedText);
  }
}