// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

class OnlineImageFullScreenDisplay extends StatelessWidget {
  final String imageUrl;
   OnlineImageFullScreenDisplay({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Add an AppBar for navigation and aesthetics
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.black, // Set background color to black for full-screen effect
      body: Center(
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain, // Adjust the fit as needed
        ),
      ),
    );
  }
}
