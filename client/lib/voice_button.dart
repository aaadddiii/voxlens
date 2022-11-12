// import 'package:client/tts.dart';
// import 'package:flutter/material.dart';
// import 'main_menu.dart';
// import 'voice_rec.dart';
// import 'home_screen.dart';
// import 'document_reader.dart';
// import 'currency_detector.dart';
// import 'profile.dart';
//
// class Voice_Button extends StatefulWidget {
//   const Voice_Button({Key? key}) : super(key: key);
//
//   @override
//   State<Voice_Button> createState() => _Voice_ButtonState();
// }
//
// class _Voice_ButtonState extends State<Voice_Button> {
//   var commands={"start":1,"read":2};
//
//   void action(String str){
//     // print(commands[str]);
//     switch(commands[str]){
//       case 1:
//         {
//           Navigator.push(context,
//               MaterialPageRoute(builder: (context) {
//                 return Main_menu();
//               }));
//           TTS().speak("Opened Main menu.");
//         }
//       break;
//       case 2:
//         {
//           Navigator.push(context,
//               MaterialPageRoute(builder: (context) {
//                 return Doc_Reader();
//               }));
//           TTS().speak("Opened Main menu.");
//
//         }
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return FloatingActionButton(
//       onPressed: () async {
//         await STT().startListening() ;
//         var command_str=STT().command_word;
//         print(command_str);
//         action(command_str);
//       },
//       child: Expanded(child: Container(
//         child: Icon(Icons.mic_rounded),
//
//       )),
//     );
//
//   }
// }
