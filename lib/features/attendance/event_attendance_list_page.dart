import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/sliver_gap.dart' as s;
import 'package:geolocation/core/globalwidget/to_sliver.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/attendance/controller/attendance_controller.dart';
import 'package:geolocation/features/attendance/model/attendance.dart';
import 'package:geolocation/features/attendance/widgets/attendance_widget.dart';
import 'package:get/get.dart';

class AttendanceListPage extends StatefulWidget {
  @override
  State<AttendanceListPage> createState() => _AttendanceListPageState();
}

class _AttendanceListPageState extends State<AttendanceListPage> {
  final AttendanceController controller = Get.find<AttendanceController>();
  final ScrollController newScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadData();

      newScrollController.addListener(() async {
        if (newScrollController.position.pixels >=
            newScrollController.position.maxScrollExtent - 200) {
          controller.loadOnScroll();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.LIGHT_BACKGROUND,
      appBar: AppBar(
        title: Text(
          'Attendance List',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () => controller.loadData(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GetBuilder<AttendanceController>(
            builder: (controller) {
              return CustomScrollView(
                controller: newScrollController,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  s.SliverGap(8),
                  controller.isPageLoading.value
                      ? ToSliver(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        )
                      : controller.attendance.isNotEmpty
                          ? SliverAlignedGrid.count(
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 16,
                              itemCount: controller.attendance.length,
                              crossAxisCount: 1,
                              itemBuilder: (context, index) {
                                Attendance attendance =
                                    controller.attendance[index];

                                return AttendanceWidget(
                                  attendance: attendance,
                                );
                              },
                            )
                          : ToSliver(
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height * 0.8,
                                child: Center(
                                  child: Text(
                                    'No record found',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black54),
                                  ),
                                ),
                              ),
                            ),
                  if (controller.isScrollLoading.value)
                    ToSliver(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
