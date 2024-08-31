import 'package:flutter/material.dart';
import 'package:geolocation/core/globalwidget/sliver_gap.dart';
import 'package:geolocation/core/globalwidget/to_sliver.dart';
import 'package:geolocation/core/globalwidget/scroll_container.dart';

class CollectionsTab extends StatelessWidget {
const CollectionsTab({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
     return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16,),
      child: ScrollContainer(slivers: [
                    SliverGap(16),
                    ToSliver(
                        child: Center(child: Text('COLLECTIONS' * 4000))),
                  ]));
  }
}