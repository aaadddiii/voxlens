import 'package:client/document_reader.dart';
import 'package:flutter/material.dart';
import 'main_menu.dart';
import 'voice_rec.dart';
import 'tts.dart';
import 'package:alan_voice/alan_voice.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  _HomeState() {
    /// Init Alan Button with project key from Alan Studio
    AlanVoice.addButton(
        "17cdb98a8fe723f4cf77a7b14b42d0292e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT);

    /// Handle commands from Alan Studio
    AlanVoice.onCommand.add((command) => _handleCommand(command.data));
  }

  void _handleCommand(Map<String, dynamic> command) {
    switch(command["command"]) {
      case "menu":
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Main_menu();
        }));
        break;
      case "read":
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Doc_Reader();
        }));
        break;

      case "back":
        Navigator.pop(context);
        break;
      case "stop":
        TTS().stop();
        break;
      default:
        debugPrint("Unknown command");
    }
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => TTS().speak("Welcome"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text('Voxlens'),
        centerTitle: true,
      ),
      body: Center(
// <<<<<<< HEAD
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(
          'Voxlens',
            style: TextStyle(
            fontSize: 35.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 5.0,
            color: Colors.white,
            fontFamily: 'Anton',
            ),
// =======
//         child: Text(
//           'Voxlens',
//           style: TextStyle(
//             fontSize: 35.0,
//             fontWeight: FontWeight.bold,
//             letterSpacing: 5.0,
//             color: Colors.red[300],
//             fontFamily: 'Georgia',
// >>>>>>> main
          ),
        GestureDetector(

          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) {
                  return Main_menu();
                }));
            // STT().startListening() ;

          },
          child: Expanded(child: Container(
          child: Text('Start',
            style: TextStyle(
                color: Colors.white
            ),),
          padding: EdgeInsets.all(30.0),
          margin: EdgeInsets.all(20.0),
          // color: Colors.grey[600],
          decoration: BoxDecoration(
              color: Colors.grey[900],
              border: Border.all(width: 3,color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(15))
          ),
        )),
          // backgroundColor: Colors.grey[600],
        ),]
        ),
      ),

      // floatingActionButton: FloatingActionButton(
      //   child: Text('Start'),
      //   onPressed: () {
      //     Navigator.push(context,
      //         MaterialPageRoute(builder: (context) {
      //           return Main_menu();
      //         }));
      //      // STT().startListening() ;
      //
      //   },

      //   backgroundColor: Colors.red[300],
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

    );
  }
}
