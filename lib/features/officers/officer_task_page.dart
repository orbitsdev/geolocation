import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/custom_button.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/globalwidget/to_sliver.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/officers/alltasks/task_main.dart';
import 'package:geolocation/features/task/controller/task_controller.dart';
import 'package:geolocation/features/task/model/task.dart';
import 'package:geolocation/features/task/widget/shimmer_task_card2.dart';
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
   taskController.loadMyTask();

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
      onRefresh: () => taskController.loadMyTask(),
      child: CustomScrollView(
        controller: newScrollController,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
           SliverGap(8),
            GetBuilder<TaskController>(
      builder: (controller) {
        return ToSliver(
          child: Container(
            color: Colors.white,
            // decoration: BoxDecoration(color: avanteColor600),
            
            child: GetBuilder<TaskController>(
              builder: (controller) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Text(
                        //   'My Tasks',
                        //   style: Get.textTheme.bodyLarge!.copyWith(),
                        // ),
                        GestureDetector(
                          onTap: () => Get.to(() => TaskMain(), transition: Transition.cupertino),
                          child: Row(
                            children: [
                              Text(
                                'View All',
                                style: Get.textTheme.bodyMedium!.copyWith(
                                  color: Palette.GREEN2,
                                  
                                ),
                              ),
                              // const Gap(4),
                              //  Icon(Icons.arrow_forward_ios, size: 12, color: Palette.GREEN2),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                    // Gap(16),
                    // Container(
                    //   height: 1,
                    //   color: Palette.LIGHT_BACKGROUND,
                    // ),
                    Container(
                      // color: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomButton(
                          value:controller.todoTasks.length,
                          onPressed: (){
                              
                              Get.to(()=> TaskMain(initialPage: 1,), transition: Transition.cupertino);
                          },
                              label: 'Todo',
                              icon: ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (Rect bounds) => LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Palette.GREEN2, Palette.GREEN3],
                                ).createShader(bounds),
                                child: FaIcon(
                                  FontAwesomeIcons.listOl,
                                  color: Palette.GRAY1,
                                ),
                              )),
                          CustomButton(
                            value:controller.needRevisionTasks.length,
                            onPressed: ()=> Get.to(()=> TaskMain(initialPage: 2,), transition: Transition.cupertino),
                              label: 'Need Revision',
                              icon: ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (Rect bounds) => LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Palette.GREEN2, Palette.GREEN3],
                                ).createShader(bounds),
                                child: FaIcon(
                                  FontAwesomeIcons.penToSquare,
                                   color: Palette.GRAY1,
                                ),
                              )),
                         
                          CustomButton(
                              value:controller.resubmitTasks.length,
                                                onPressed: ()=> Get.to(()=> TaskMain(initialPage: 4,), transition: Transition.cupertino),
                              label: 'Resubmitted',
                              icon: ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (Rect bounds) => LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Palette.GREEN2, Palette.GREEN3],
                                ).createShader(bounds),
                                child: FaIcon(
                                  FontAwesomeIcons.fileLines,
                                   color: Palette.GRAY1,
                                ),
                              )),
                         
               
                         
                         
                        ],
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Palette.LIGHT_BACKGROUND,
                    ),
                  ],
                  
                );
              }
            ),
          ),
        );
      }
    ),
    
  SliverGap(8),
          GetBuilder<TaskController>(builder: (taskcontroller) {
            return MultiSliver(children: [
              if (taskcontroller.isLoading.value == true)
                SliverAlignedGrid.count(
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  itemCount: 10,
                  crossAxisCount: 1,
                  itemBuilder: (context, index) {
                    return ShimmerTaskCard2();
                  }),
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
                    SliverAlignedGrid.count(
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  itemCount: 10,
                  crossAxisCount: 1,
                  itemBuilder: (context, index) {
                    return ShimmerTaskCard2();
                  }),
            ]);
          }),


        ],
      ),
    );
  }
}