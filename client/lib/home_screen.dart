import 'package:flutter/material.dart';
import 'main_menu.dart';
import 'voice_rec.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[600],
        title: Text('Voxlens'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Voxlens',
          style: TextStyle(
            fontSize: 35.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 10.0,
            color: Colors.grey[600],
            fontFamily: 'Anton',
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text('Start'),
        onPressed: () {
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) {
          //       return Main_menu();
          //     }));
          STT().startListening();
        },
        backgroundColor: Colors.grey[600],
      ),
    );
  }
}
