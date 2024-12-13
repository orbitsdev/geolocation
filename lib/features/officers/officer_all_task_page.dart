import 'package:flutter/material.dart';
import 'package:geolocation/features/officers/alltasks/all_task.dart';
import 'package:geolocation/features/officers/alltasks/completed_tasks.dart';
import 'package:geolocation/features/officers/alltasks/rejected_tasks.dart';
import 'package:geolocation/features/officers/alltasks/resubmit_tasks.dart';
import 'package:geolocation/features/officers/alltasks/todo_tasks.dart';

class OfficerAllTaskPage extends StatefulWidget {
  const OfficerAllTaskPage({ Key? key }) : super(key: key);

  @override
  _OfficerAllTaskPageState createState() => _OfficerAllTaskPageState();
}

class _OfficerAllTaskPageState extends State<OfficerAllTaskPage> {

  late TabController tabController;

  List<Widget> page = [
    AllTask(),
    TodoTasks(),
    RejectedTasks(),
    ResubmitTasks(),
    CompletedTasks(),
    // ReturnedRefund(),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}