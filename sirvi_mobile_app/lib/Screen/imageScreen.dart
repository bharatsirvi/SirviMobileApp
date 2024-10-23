import 'package:flutter/material.dart';

class ImagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Image Page',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          // Replace with your image URL
        ],
      ),
    );
  }
}
