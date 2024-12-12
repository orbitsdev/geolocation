import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geolocation/core/globalwidget/to_sliver.dart';
import 'package:geolocation/features/task/controller/task_controller.dart';
import 'package:geolocation/features/task/model/task.dart';
import 'package:get/get.dart';
import 'package:sliver_tools/sliver_tools.dart';

class OfficerTaskPage extends StatefulWidget {
const OfficerTaskPage({ Key? key }) : super(key: key);

  @override
  State<OfficerTaskPage> createState() => _OfficerTaskPageState();
}

class _OfficerTaskPageState extends State<OfficerTaskPage> {

    var taskController = Get.find<TaskController>();
   final ScrollController newScrollController = ScrollController();

@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) async {
   taskController.loadTask();

        newScrollController.addListener(() async {
        if (newScrollController.position.pixels >=
            newScrollController.position.maxScrollExtent - 200) {
           taskController.loadTaskOnScroll();
        }
      });
    });
}

  @override
  Widget build(BuildContext context){
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      onRefresh: () => taskController.loadTask(),
      child: CustomScrollView(
        controller: newScrollController,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [


          GetBuilder<TaskController>(builder: (taskcontroller) {
            return MultiSliver(children: [
              if (taskcontroller.isLoading.value == true)
                ToSliver(child: LinearProgressIndicator()),
              SliverAlignedGrid.count(
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  itemCount: taskController.tasks.length,
                  crossAxisCount: 1,
                  itemBuilder: (context, index) {
                    Task task = taskController.tasks[index];
                    return Container();
                  }),

                   if (taskcontroller.isScrollLoading.value)
                    ToSliver(
                      child: Center(child: CircularProgressIndicator()),
                    ),
            ]);
          }),


        ],
      ),
    );
  }
}