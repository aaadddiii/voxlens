import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'tts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:read_pdf_text/read_pdf_text.dart';
import 'package:alan_voice/alan_voice.dart';
import 'edge_detection/ocr_detection.dart';

class Doc_Reader extends StatefulWidget {
  const Doc_Reader({Key? key}) : super(key: key);

  @override
  State<Doc_Reader> createState() => _Doc_ReaderState();
}

class _Doc_ReaderState extends State<Doc_Reader> {

  void initState() {
    super.initState();
    AlanVoice.deactivate();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => TTS().speak("Opened Doc reader"));
  }

  XFile? imageFile;
  String scannedText="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal[700],
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
                  getPdf();
                },
                child: Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children : [
                        Image.asset('assets/upload_doc.png', width: 70, height: 70,),
                          Text('Upload Document',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),),],
                      ),
                      padding: EdgeInsets.all(15.0),
                      margin: EdgeInsets.all(10.0),
                      width: MediaQuery.of(context).size.width/2.3,
                      height: MediaQuery.of(context).size.height/4,
                      // color: Colors.teal[300],
                      decoration: BoxDecoration(
                        color: Colors.teal[300],
                        //border: Border.all(width: 3,color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        boxShadow : [BoxShadow(color: Colors.black,spreadRadius: 2,blurRadius: 8,offset:Offset(4,4)),
                          ],
                      ),
                    )),
              ),



          GestureDetector(
              onTap: () {
                getImage(1);
              },
              child: Expanded(child: Container(

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/upload_im.png', width: 70, height: 70,),
                    Text('Upload Image',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),),
                  ],
                ),
                padding: EdgeInsets.all(15.0),
                margin: EdgeInsets.all(8.0),
                width: MediaQuery.of(context).size.width/2.3,
                height: MediaQuery.of(context).size.height/4,
                // color: Colors.teal[300],
                decoration: BoxDecoration(
                  color: Colors.teal[300],
                  //border: Border.all(width: 3,color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow : [BoxShadow(color: Colors.black,spreadRadius: 2,blurRadius: 8,offset:Offset(4,4)),
                    ],
                ),
              )),
            ),
            ],
          ),
            flex: 2,),
          // GestureDetector(
          //   onTap: (){
          //     getImage(0);
          //   },
          //   child: Expanded(child: Container(
          //     child: Text('Scan Document',
          //       style: TextStyle(
          //           color: Colors.white
          //       ),),
          //     padding: EdgeInsets.all(15.0),
          //     margin: EdgeInsets.all(10.0),
          //     // color: Colors.red[300],
          //     decoration: BoxDecoration(
          //       color: Colors.teal[300],
          //       //border: Border.all(width: 3,color: Colors.black),
          //       borderRadius: BorderRadius.all(Radius.circular(15)),
          //       boxShadow : [BoxShadow(color: Colors.black,spreadRadius: 2,blurRadius: 8,offset:Offset(4,4)),
          //         BoxShadow(color: Colors.grey,spreadRadius: 1,blurRadius: 8,offset:Offset(-4,-4))],
          //     ),
          //   )),
          // ),
          Flexible(child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,

    children: [GestureDetector(
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return TextRecognizerView();
                  }));
            },
            child: Expanded(child: Container(
              child : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/scan.png', width: 70, height: 70,),
                Text('Realtime OCR',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),),],
                ),
              padding: EdgeInsets.all(15.0),
              margin: EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width/2,
              height: MediaQuery.of(context).size.height/4,
              // color: Colors.red[300],
              decoration: BoxDecoration(
                color: Colors.teal[300],
                //border: Border.all(width: 3,color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(15)),
                boxShadow : [BoxShadow(color: Colors.black,spreadRadius: 2,blurRadius: 8,offset:Offset(4,4)),
                  ],
              ),
            )),
    ),
    ],),
          flex: 1,),

        ],),
    );
  }

}

XFile? imageFile;
String scannedText="";
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
  TTS().speak(scannedText);
}
// }

void getPdf() async{
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    PlatformFile file = result.files.first;
    getPDFtextPaginated(file.path as String);
  } else {
    // User canceled the picker
    print("failure");
  }
}
//
// Future<String> getPDFtext(String path) async {
//   String text = "";
//   text = await ReadPdfText.getPDFtext(path);
//   print(text + ">>>> text");
//   return text;
// }

void getPDFtextPaginated(String path) async {
  List<String> textList = List<String>.empty();
  textList = await ReadPdfText.getPDFtextPaginated(path);
  print(textList);
  for(String page in textList){
    TTS().speak(page);
  }
}