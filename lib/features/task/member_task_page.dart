import 'package:flutter/material.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/task/controller/task_controller.dart';
import 'package:geolocation/features/task/create_task_page.dart';
import 'package:geolocation/features/task/model/sample_data.dart';
import 'package:geolocation/features/task/widget/admin_task_card.dart';
import 'package:geolocation/features/task/widget/task_card.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class MemberTaskPage extends StatefulWidget {
  @override
  State<MemberTaskPage> createState() => _MemberTaskPageState();
}

class _MemberTaskPageState extends State<MemberTaskPage> {

  var taskController = Get.find<TaskController>();
  final ScrollController scrollController = ScrollController();


  @override
  void initState() {
   

    WidgetsBinding.instance.addPostFrameCallback((_) {
      taskController.loadTasks();
     

      scrollController.addListener(() {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          double threshold = 200.0;

          if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - threshold) {
             taskController.loadTaskOnScroll(context);
          }
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.LIGHT_BACKGROUND,
      appBar: AppBar(

        
      backgroundColor: Colors.white,
        title: Text('Tasks'),
         actions: [
          TextButton.icon(
            onPressed: () {
              Get.to(() => CreateTaskPage(), transition: Transition.cupertino);
            },
            icon: Icon(Icons.add, color: Palette.PRIMARY),
            label: Text(
              'Add Task',
              style: TextStyle(color: Palette.PRIMARY),
            ),
          ),]
      ),
    
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            RippleContainer(
              child: AdminTaskCard(
                title: 'Design Website Banner',
                description: 'Create a promotional banner for the homepage.',
                status: 'In Progress',
                dueDate: 'Sep 15, 2024',
                officerName: 'Jane Smith',
                officerImageUrl: 'https://i.pravatar.cc/150?img=5',
                officerPosition: 'Marketing Officer',
                attachedFiles: exampleFiles ,
              ),
            ),
            AdminTaskCard(
  title: 'Design Website Banner',
  description: 'Create a promotional banner for the homepage.',
  status: 'In Progress',
  dueDate: 'Sep 15, 2024',
  officerName: 'Jane Smith',
  officerImageUrl: 'https://i.pravatar.cc/150?img=5',
  officerPosition: 'Marketing Officer',
   attachedFiles: exampleFiles ,
),
            AdminTaskCard(
  title: 'Design Website Banner',
  description: 'Create a promotional banner for the homepage.',
  status: 'In Progress',
  dueDate: 'Sep 15, 2024',
  officerName: 'Jane Smith',
  officerImageUrl: 'https://i.pravatar.cc/150?img=5',
  officerPosition: 'Marketing Officer',
   attachedFiles: exampleFiles ,
  
),
            AdminTaskCard(
  title: 'Design Website Banner',
  description: 'Create a promotional banner for the homepage.',
  status: 'In Progress',
  dueDate: 'Sep 15, 2024',
  officerName: 'Jane Smith',
  officerImageUrl: 'https://i.pravatar.cc/150?img=5',
  officerPosition: 'Marketing Officer',
   attachedFiles: exampleFiles ,
),

          ],
        ),
      ),
    );
  }
}