import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/empty_state.dart';
import 'package:geolocation/core/globalwidget/loading_state.dart';
import 'package:geolocation/core/globalwidget/loading_tasks.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/globalwidget/to_sliver.dart';
import 'package:geolocation/features/task/controller/task_controller.dart';
import 'package:geolocation/features/task/model/task.dart';
import 'package:geolocation/features/task/widget/task_card2.dart';
import 'package:get/get.dart';

class ResubmitTasks extends StatefulWidget {
const ResubmitTasks({ Key? key }) : super(key: key);

  @override
  State<ResubmitTasks> createState() => _ResubmitTasksState();
}

class _ResubmitTasksState extends State<ResubmitTasks> {

   final ScrollController scrollController = ScrollController();

  final  controller = Get.find<TaskController>();

  @override
  void initState() {
    super.initState();
   
      WidgetsBinding.instance.addPostFrameCallback((_) {
       
            
             controller.loadResubmitTask();
        //   if(controller.todoTasks.isEmpty){
        // }
    

      scrollController.addListener(() {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {

          
          double threshold = 200.0;

         if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - threshold) {
       
              controller.loadResubmitTaskOnScroll();
            
          }
        }
      });

      });
    
  }
  @override
  Widget build(BuildContext context){
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      onRefresh: () => controller.reload(Task.STATUS_RESUBMIT),
      child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),

        controller: scrollController,
        slivers: [
          SliverGap(8),
          GetBuilder<TaskController>(builder: (taskcontroller) {
            if (controller.resubmitIsLoading.value) {
              return LoadingState(child:LoadingTasks() ) ;
            } else {
              if (controller.resubmitTasks.isNotEmpty) {
                return SliverMasonryGrid.count(
                  childCount: controller.resubmitTasks.length,
                  crossAxisCount: 1,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 10,
                  itemBuilder: (context, index) {
                    Task task = controller.resubmitTasks[index];
                    return  RippleContainer(
                      onTap: ()=> controller.selectTaskAndNavigateToFullDetails(task),
                      child: TaskCard2(task: task));});
              } else {
                return ToSliver(child: EmptyState());
              }
            }
          }),
           GetBuilder<TaskController>(
             builder: (controller) {
              return controller.resubmitIsScrollLoading.value ? LoadingState(child:LoadingTasks() )  :ToSliver(child: Container());
             }
           ),
          const SliverGap(18),
        
        ],
      ),
    );
  }
}