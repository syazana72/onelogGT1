import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyPhotoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
        backgroundColor: Color(0xff091647),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Image.asset(
          'assets/images/flowphoto.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}




