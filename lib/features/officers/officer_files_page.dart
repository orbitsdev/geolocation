import 'package:flutter/material.dart';
import 'package:geolocation/features/files/controller/media_controller.dart';
import 'package:geolocation/features/files/widget/media_resource_card.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class OfficerFilesPage extends StatefulWidget {
  const OfficerFilesPage({Key? key}) : super(key: key);

  @override
  State<OfficerFilesPage> createState() => _OfficerFilesPageState();
}

class _OfficerFilesPageState extends State<OfficerFilesPage> {
  final MediaController mediaController = Get.put(MediaController());

  @override
  void initState() {
    super.initState();
    mediaController.loadMediaResources();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: GetBuilder<MediaController>(
        init: mediaController,
        builder: (controller) {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.mediaResources.isEmpty) {
            return const Center(
              child: Text(
                'No files found.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverAlignedGrid.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  itemCount: controller.mediaResources.length,
                  itemBuilder: (context, index) {
                    final mediaResource = controller.mediaResources[index];
                    return GestureDetector(
                      onTap: () {
                        // Call fullScreenDisplay with the selected media resource
                        controller.fullScreenDisplay(
                          controller.mediaResources,
                          mediaResource,
                        );
                      },
                      child: MediaResourceCardNew(mediaResource: mediaResource),
                    );
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
