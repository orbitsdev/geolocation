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

class FilteredTaskPage extends StatefulWidget {
  final String status; // Status to filter tasks
  final int councilPositionId; // Council position ID for filtering tasks

  const FilteredTaskPage({
    Key? key,
    required this.status,
    required this.councilPositionId,
  }) : super(key: key);

  @override
  State<FilteredTaskPage> createState() => _FilteredTaskPageState();
}

class _FilteredTaskPageState extends State<FilteredTaskPage> {
  final ScrollController scrollController = ScrollController();
  final controller = Get.put(TaskController());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initial fetch of filtered tasks
      if (controller.filteredTasks.isEmpty) {
        controller.fetchFilteredTasks(
          councilPositionId: widget.councilPositionId,
          status: widget.status,
        );
      }

      // Add listener for infinite scroll
      scrollController.addListener(() {
        double threshold = 200.0; // Threshold to trigger loading
        if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - threshold) {
          controller.fetchFilteredTasksOnScroll(
            councilPositionId: widget.councilPositionId,
            status: widget.status,
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tasks - ${widget.status}',
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () async {
          // Refresh tasks on pull-to-refresh
          await controller.fetchFilteredTasks(
            councilPositionId: widget.councilPositionId,
            status: widget.status,
          );
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          slivers: [
            const SliverGap(8),
            GetBuilder<TaskController>(builder: (taskController) {
              if (controller.isFilteredLoading.value) {
                return LoadingState(child: LoadingTasks());
              } else {
                if (controller.filteredTasks.isNotEmpty) {
                  return SliverMasonryGrid.count(
                    childCount: controller.filteredTasks.length,
                    crossAxisCount: 1,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 10,
                    itemBuilder: (context, index) {
                      Task task = controller.filteredTasks[index];
                      return RippleContainer(
                        onTap: () => controller.selectTaskAndNavigateToFullDetails(task),
                        child: TaskCard2(task: task),
                      );
                    },
                  );
                } else {
                  return ToSliver(child: EmptyState());
                }
              }
            }),
            GetBuilder<TaskController>(builder: (taskController) {
              return controller.isFilteredScrollLoading.value
                  ? LoadingState(child: LoadingTasks())
                  : ToSliver(child: Container());
            }),
            const SliverGap(18),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
