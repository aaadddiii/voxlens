import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        title: Text('Voxlens'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name',
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Username',
              style: TextStyle(
                color: Colors.cyan,
                letterSpacing: 2.0,
                fontSize: 20,
                fontWeight: FontWeight.bold
              )
            ),
            SizedBox(height: 40.0),
            Row(
              children: [
                Icon(
                  Icons.email,
                  color: Colors.grey[400],
                ),
                SizedBox(width: 10.0),
                Text(
                  'email@gmail.com',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize:  18.0,
                    letterSpacing: 1.0
                  )
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}