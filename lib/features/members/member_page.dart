import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geolocation/core/globalwidget/sliver_gap.dart';
import 'package:geolocation/core/globalwidget/to_sliver.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/home/dashboard/widget/member_user_card.dart';
import 'package:geolocation/features/members/create_or_edit_member_page.dart';
import 'package:geolocation/features/members/model/member.dart';
import 'package:geolocation/features/members/widget/member_card.dart';
import 'package:get/get.dart';

class MemberPage extends StatelessWidget {
const MemberPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Members'),

         actions: [
          TextButton(onPressed: (){
            Get.to(()=> CreateOrEditMemberPage(), transition: Transition.cupertino);
          }, child: Text('New Member', style: Get.textTheme.bodyMedium,))
          // IconButton(onPressed: (){
          //   Get.to(()=> CreateOrEditMemberPage(), transition: Transition.cupertino);
          // }, icon: Icon(Icons.plus_one))
        ],
      ),
      body: CustomScrollView(
        slivers: [

          ToSliver(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Palette.LIGHT_BACKGROUND, Palette.BACKGROUND],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
              borderRadius: BorderRadius.circular(8)),
          child: CustomScrollView(
            shrinkWrap: true,
            physics:const NeverScrollableScrollPhysics(),
            slivers: [
              SliverGap(8),
          
              SliverAlignedGrid.count(
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      itemCount: members.length,
                   
                      crossAxisCount: 1,
                      itemBuilder: (context, index) {
                        Member member = members[index];
                        return MemberCard(member:member);
                      })
                  
                    
            ],
          ),
        ),
      ),

        ],
      ),
    );
  }
}