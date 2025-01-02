// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CircularLoading extends StatelessWidget {
  Color? color;
   CircularLoading({
    Key? key,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return CircularProgressIndicator(color: color?? Colors.white,);
  }
}
