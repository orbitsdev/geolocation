// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ScrollContainer extends StatelessWidget {
List<Widget> slivers;
   ScrollContainer({
    Key? key,
    required this.slivers,
  }) : super(key: key);
  @override
  Widget build(BuildContext context){
    return  CustomScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    slivers:slivers);
  }
}
