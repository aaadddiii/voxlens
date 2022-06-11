import 'package:flutter/material.dart';

class Doc_Reader extends StatelessWidget {
  const Doc_Reader({Key? key}) : super(key: key);

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
          'Document Reader',
        ),
      ),
    );
  }
}
