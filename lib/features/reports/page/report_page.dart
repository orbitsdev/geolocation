import 'package:flutter/material.dart';
import 'package:geolocation/features/reports/report_controller.dart';
import 'package:get/get.dart';

class ReportPage extends StatelessWidget {
  final ReportController reportController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Reports'),
      ),
      body: GetBuilder<ReportController>(
        builder: (controller) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Button to generate Events report
              ListTile(
                leading: controller.isLoadingEvents
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.event),
                title: const Text('Export Events Report'),
                subtitle: const Text('Generate report of all events for a council'),
                trailing: IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: controller.isLoadingEvents
                      ? null
                      : () async {
                          await controller.exportEventsByCouncil();
                        },
                ),
              ),
              // Button to generate Collections report
              ListTile(
                leading: controller.isLoadingCollections
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.collections),
                title: const Text('Export Collections Report'),
                subtitle: const Text('Generate report of all collections for a council'),
                trailing: IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: controller.isLoadingCollections
                      ? null
                      : () async {
                          await controller.exportCollectionsByCouncil();
                        },
                ),
              ),
              // Button to generate Tasks report
              ListTile(
                leading: controller.isLoadingTasks
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.task),
                title: const Text('Export Tasks Report'),
                subtitle: const Text('Generate report of all tasks for a council'),
                trailing: IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: controller.isLoadingTasks
                      ? null
                      : () async {
                          await controller.exportTasksByCouncil();
                        },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
