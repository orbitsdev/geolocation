
import 'package:flutter/material.dart';
import 'package:geolocation/core/globalwidget/map_loading.dart';

class Test extends StatelessWidget {
const Test({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    
    return Scaffold(
    
      body: MapLoading(),
    );
  }
}