import 'package:flutter/material.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/reports/report_controller.dart';
import 'package:get/get.dart';

class ReportPage extends StatelessWidget {
  final ReportController reportController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: const Text('Generate Reports'),
      ),
      body: GetBuilder<ReportController>(
        builder: (controller) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            children: [
              Text(
                'Export Reports',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Events Report
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: const Icon(Icons.event, color: Colors.blue),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Export Events Report',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Generate report of all events for a council.',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    controller.isLoadingEvents
                        ? const CircularProgressIndicator()
                        : IconButton(
                            icon: const Icon(Icons.download, color: Colors.blue),
                            onPressed: controller.isLoadingEvents
                                ? null
                                : () async {
                                    await controller.exportEventsByCouncil();
                                  },
                          ),
                  ],
                ),
              ),

              // Collections Report
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.green.shade100,
                      child: const Icon(Icons.collections, color: Colors.green),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Export Collections Report',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Generate report of all collections for a council.',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    controller.isLoadingCollections
                        ? const CircularProgressIndicator()
                        : IconButton(
                            icon: const Icon(Icons.download, color: Colors.green),
                            onPressed: controller.isLoadingCollections
                                ? null
                                : () async {
                                    await controller.exportCollectionsByCouncil();
                                  },
                          ),
                  ],
                ),
              ),

              // Tasks Report
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.orange.shade100,
                      child: const Icon(Icons.task, color: Colors.orange),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Export Tasks Report',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Generate report of all tasks for a council.',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    controller.isLoadingTasks
                        ? const CircularProgressIndicator()
                        : IconButton(
                            icon: const Icon(Icons.download, color: Colors.orange),
                            onPressed: controller.isLoadingTasks
                                ? null
                                : () async {
                                    await controller.exportTasksByCouncil();
                                  },
                          ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Generate detailed reports for your council activities.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Palette.lightText,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
