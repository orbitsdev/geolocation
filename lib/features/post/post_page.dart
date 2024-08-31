import 'package:flutter/material.dart';
import 'package:geolocation/core/globalwidget/coming_soon.dart';

class PostPage extends StatelessWidget {
const PostPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: ComingSoon(),
    );
  }
}