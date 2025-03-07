// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';


import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/custom_indicator.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/officers/alltasks/all_task.dart';
import 'package:geolocation/features/officers/alltasks/completed_tasks.dart';
import 'package:geolocation/features/officers/alltasks/need_revision_tasks.dart';
import 'package:geolocation/features/officers/alltasks/rejected_tasks.dart';
import 'package:geolocation/features/officers/alltasks/resubmit_tasks.dart';
import 'package:geolocation/features/officers/alltasks/todo_tasks.dart';
import 'package:geolocation/features/reports/report_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:sliver_tools/sliver_tools.dart';


class TaskMain extends StatefulWidget {

  bool? shouldRefresh;
  int? initialPage;
   TaskMain({
    Key? key,
    this.initialPage,
    this.shouldRefresh,
  }) : super(key: key);

  @override
  State<TaskMain> createState() => _TaskMainState();
}
 
class _TaskMainState extends State<TaskMain> with   SingleTickerProviderStateMixin {
  
  late TabController tabController;

  List<Widget> page = [
    AllTask(),
    TodoTasks(),
    NeedRevisionTasks(),
    RejectedTasks(),
    ResubmitTasks(),
    CompletedTasks(),
    // ReturnedRefund(),
  ];

  @override
  void initState() {
     super.initState();
  
    tabController = TabController(length: 6, vsync: this, initialIndex: widget.initialPage ?? 0);
       WidgetsBinding.instance.addPostFrameCallback((_)  async {
          if(widget.shouldRefresh == true){
            // await cartController.loadCarts(context);
            // myOrdeController.loadToShipOrders(context);
          }
       });
    
   
  }

  @override
  void dispose() {
    tabController.dispose();
    
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.LIGHT_BACKGROUND,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios_rounded)),
        backgroundColor: Colors.white,
        elevation: 0,
        // title:  Text('My Orders', style: Get.textTheme.titleLarge,),
        title: Text(
          'My Tasks',
          style: Get.textTheme.titleLarge,
        ),
        bottom: TabBar(
            dividerColor: Colors.transparent,
            indicator: CustomUnderlineTabIndicator(
              color: Palette.GREEN3,
            ),
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Palette.GREEN3,
            isScrollable: true,
            labelColor: Palette.GREEN3,
            tabAlignment: TabAlignment.start,
            controller: tabController,
            unselectedLabelStyle: Get.textTheme.bodyMedium!.copyWith(
              height: 0,
            ),
            labelStyle: Get.textTheme.bodyLarge!.copyWith(
              height: 0,
            ),
            tabs: [
              Tab(
                text: 'All',
              ),
              Tab(
                text: 'To Do',
              ),
               Tab(
                text: 'Need Revision',
              ),
              Tab(
                text: 'Rejected',
              ),
             
              Tab(
                text: 'Resubmitted',
              ),
              Tab(
                text: 'Completed & Approved',
              ),
              // Tab(
              //   text: 'Return Refund',
              // ),
            ]),
            actions: [
  TextButton(
    onPressed: () async {
      final councilPositionId = Get.find<AuthController>()
          .user
          .value
          .defaultPosition
          ?.id; // Retrieve council position ID

      if (councilPositionId == null) {
        Get.snackbar('Error', 'Council position ID not found.');
        return;
      }

      await ReportController.controller.exportTasksByCouncilPosition(councilPositionId: councilPositionId);
    },
    child: Text(
      'Download Tasks',
      style: TextStyle(
        color: Palette.DARK_PRIMARY,
        fontWeight: FontWeight.bold,
        //underline
        
        fontSize: 16,
      ),
    ),
  ),
],

      ),
      body: TabBarView(controller: tabController, children: page),
    );
  }
}
