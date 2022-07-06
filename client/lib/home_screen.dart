import 'package:flutter/material.dart';
import 'main_menu.dart';
import 'voice_rec.dart';
import 'tts.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => TTS().speak("Welcome to Voxlens!!Press Start on the bottom right to begin"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        title: Text('Voxlens'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Voxlens',
          style: TextStyle(
            fontSize: 35.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 5.0,
            color: Colors.red[300],
            fontFamily: 'Georgia',
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text('Start'),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) {
                return Main_menu();
              }));
           // STT().startListening() ;

        },

        backgroundColor: Colors.red[300],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
