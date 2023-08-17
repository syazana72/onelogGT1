import 'package:flutter/material.dart';

class FullScreenImageAfter extends StatelessWidget {
  final String imageUrl1;

  FullScreenImageAfter({required this.imageUrl1});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: imageUrl1,
            child: InteractiveViewer(
              boundaryMargin: EdgeInsets.all(20),
              minScale: 0.1,
              maxScale: 5.0,
              child: Image.network(
                imageUrl1,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
