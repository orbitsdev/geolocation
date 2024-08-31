// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/widgets.dart';

class ToSliver extends StatelessWidget {

  Widget child;
   ToSliver({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return SliverToBoxAdapter(child: child,);
  }
}
