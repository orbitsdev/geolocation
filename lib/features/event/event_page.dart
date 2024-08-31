import 'package:flutter/material.dart';
import 'package:geolocation/core/globalwidget/coming_soon.dart';

class EventPage extends StatelessWidget {
const EventPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
      ),
      body: ComingSoon(), 
    );
  }
}