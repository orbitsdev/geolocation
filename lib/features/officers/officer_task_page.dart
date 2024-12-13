import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/globalwidget/to_sliver.dart';
import 'package:geolocation/features/officers/alltasks/task_main.dart';
import 'package:geolocation/features/task/controller/task_controller.dart';
import 'package:geolocation/features/task/model/task.dart';
import 'package:geolocation/features/task/widget/task_card2.dart';
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
   taskController.loadByOfficerTask();

      //   newScrollController.addListener(() async {
      //   if (newScrollController.position.pixels >=
      //       newScrollController.position.maxScrollExtent - 200) {
      //      taskController.loadByOfficerTaskOnScroll();
      //   }
      // });

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
SliverGap(8),
           ToSliver(
             child: Padding(
               padding: const EdgeInsets.symmetric(horizontal: 16),
               child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                 
                                  Text('Latest Task',
                                      style: Get.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
                                ]),
                            GestureDetector(
                              onTap: (){
                                Get.to(()=> TaskMain(), transition: Transition.cupertino);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'View all Tasks',
                                    style: Get.textTheme.bodyMedium!.copyWith(),
                                  ),
                                //   Gap(4),
                                //  Icon(Icons.arrow_forward_ios,size: 12,)
                                ],
                              ),
                            )
                          ],
                        ),
             ),
           ),
  SliverGap(8),
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
                    return RippleContainer(
                      onTap: ()=>  taskController.selectTaskAndNavigateToFullDetails(task),
                      child: TaskCard2(task: task));
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