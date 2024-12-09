import 'package:flutter/material.dart';
import 'package:geolocation/core/globalwidget/sliver_gap.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/home/dashboard/widget/profile_section.dart';

class OfficerHomePage extends StatefulWidget {
const OfficerHomePage({ Key? key }) : super(key: key);

  @override
  State<OfficerHomePage> createState() => _OfficerHomePageState();
}

class _OfficerHomePageState extends State<OfficerHomePage> {

   final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          physics:  const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          slivers: [
            ProfileSection(),
            SliverGap(24),
          ],
        ),
      ),
    );
  }
}