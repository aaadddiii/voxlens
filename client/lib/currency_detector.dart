import 'package:flutter/material.dart';

class Currency_detector extends StatelessWidget {
  const Currency_detector({Key? key}) : super(key: key);

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
          'Currency Reader',
        ),
      ),
    );
  }
}
