import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geolocation/core/globalwidget/loading_widget.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/globalwidget/sliver_gap.dart';
import 'package:geolocation/core/globalwidget/to_sliver.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/task/admin_members_task_page.dart';
import 'package:geolocation/features/task/controller/task_controller.dart';
import 'package:geolocation/features/task/created_or_edit_page.dart';
import 'package:geolocation/features/task/model/sample_data.dart';
import 'package:geolocation/features/task/model/task.dart';
import 'package:geolocation/features/task/task_details_page.dart';
import 'package:geolocation/features/task/task_page.dart';
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
      taskController.loadTask();

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
      appBar:
          AppBar(backgroundColor: Colors.white, title: Text('Tasks'), actions: [
        TextButton.icon(
          onPressed: () {
            Get.to(() => CreatedOrEditPage(), transition: Transition.cupertino);
          },
          icon: Icon(Icons.add, color: Palette.PRIMARY),
          label: Text(
            'Add Task',
            style: TextStyle(color: Palette.PRIMARY),
          ),
        ),
      ]),
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () => taskController.loadTask(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GetBuilder<TaskController>(builder: (controller) {
            return CustomScrollView(
              controller: scrollController,
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverGap(8),
                controller.isLoading.value
                    ? ToSliver(
                        child: Center(child: CircularProgressIndicator()))
                    : controller.tasks.isNotEmpty
                        ? SliverAlignedGrid.count(
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 16,
                            itemCount: controller.tasks.length,
                            // childCount: sampleProducts.length,
                            crossAxisCount: 1,
                            itemBuilder: (context, index) {
                              Task task = controller.tasks[index];
                              return Slidable(
  key: Key(task.id.toString()),
  endActionPane: ActionPane(
    motion: const DrawerMotion(),
    extentRatio: 0.5, // Adjust the ratio for more space
    children: [
      // Update Action
      SlidableAction(
      
        onPressed: (context) {
          if (task.id != null) {
            Get.to(
              () => CreatedOrEditPage(
                isEditMode: true,
                task: task,
              ),
              transition: Transition.cupertino,
            );
          }
        },
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        icon: Icons.edit,
        label: 'Update',
        autoClose: true,
      ),

      // Delete Action
      SlidableAction(
      
        onPressed: (context) {
          if (task.id != null) {
            Modal.confirmation(
              titleText: "Confirm Delete",
              contentText: "Are you sure you want to delete this task? This action cannot be undone.",
              onConfirm: () {
                controller.deleteTask(task.id!);
              },
              onCancel: () {
                Get.back();
              },
            );
          }
        },
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        icon: Icons.delete,
        label: 'Delete',
        autoClose: true,
      ),
    ],
  ),
  child: RippleContainer(
    onTap: () {
      Get.to(() => TaskDetailsPage(task: task,));
    },
    child: AdminTaskCard(task: task),
  ),
);

                            })
                        : ToSliver(child: Container()),
                if (controller.isScrollLoading.value)
                  ToSliver(
                      child: const Center(child: CircularProgressIndicator())),
              ],
            );
          }),

          //   ListView(
          //     children: [
          //       RippleContainer(
          //         child: AdminTaskCard(
          //           title: 'Design Website Banner',
          //           description: 'Create a promotional banner for the homepage.',
          //           status: 'In Progress',
          //           dueDate: 'Sep 15, 2024',
          //           officerName: 'Jane Smith',
          //           officerImageUrl: 'https://i.pravatar.cc/150?img=5',
          //           officerPosition: 'Marketing Officer',
          //           attachedFiles: exampleFiles ,
          //         ),
          //       ),
          //       AdminTaskCard(
          //   title: 'Design Website Banner',
          //   description: 'Create a promotional banner for the homepage.',
          //   status: 'In Progress',
          //   dueDate: 'Sep 15, 2024',
          //   officerName: 'Jane Smith',
          //   officerImageUrl: 'https://i.pravatar.cc/150?img=5',
          //   officerPosition: 'Marketing Officer',
          //    attachedFiles: exampleFiles ,
          // ),
          //       AdminTaskCard(
          //   title: 'Design Website Banner',
          //   description: 'Create a promotional banner for the homepage.',
          //   status: 'In Progress',
          //   dueDate: 'Sep 15, 2024',
          //   officerName: 'Jane Smith',
          //   officerImageUrl: 'https://i.pravatar.cc/150?img=5',
          //   officerPosition: 'Marketing Officer',
          //    attachedFiles: exampleFiles ,

          // ),
          //       AdminTaskCard(
          //   title: 'Design Website Banner',
          //   description: 'Create a promotional banner for the homepage.',
          //   status: 'In Progress',
          //   dueDate: 'Sep 15, 2024',
          //   officerName: 'Jane Smith',
          //   officerImageUrl: 'https://i.pravatar.cc/150?img=5',
          //   officerPosition: 'Marketing Officer',
          //    attachedFiles: exampleFiles ,
          // ),

          //     ],
          //   ),
        ),
      ),
    );
  }
}
