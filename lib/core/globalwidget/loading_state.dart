// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class LoadingState extends StatelessWidget {

  Widget child;
 int? itemCount;
  double? mainAxisSpacing;
  double? crossAxisSpacing;
  int? crossAxisCount;
   LoadingState({
    Key? key,
    required this.child,
    this.itemCount,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.crossAxisCount,
  }) : super(key: key);


  @override
  Widget build(BuildContext context){
     return SliverAlignedGrid.count(
      crossAxisSpacing: crossAxisSpacing??8,
      mainAxisSpacing: mainAxisSpacing??8,
      itemCount: itemCount ?? 5, // Show up to 10 loading cards
      crossAxisCount: crossAxisCount ?? 1,
      itemBuilder: (context, index) {
        return child;
      },
    );
  }
}
