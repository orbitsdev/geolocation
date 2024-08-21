// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:geolocation/core/shared/to_sliver.dart';

class SliverGap extends StatelessWidget {

  double value;
  SliverGap(this.value);

  @override
  Widget build(BuildContext context){
    return ToSliver(child: Gap(value));
  }
}
