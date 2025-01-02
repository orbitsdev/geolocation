import 'package:flutter/material.dart';
import 'package:geolocation/core/globalwidget/sliver_gap.dart';
import 'package:geolocation/core/globalwidget/to_sliver.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/files/controller/media_controller.dart';
import 'package:geolocation/features/files/widget/media_resource_card.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geolocation/features/files/widget/shimmer_media_resource_card_new.dart';
import 'package:get/get.dart';

class OfficerFilesPage extends StatefulWidget {
  const OfficerFilesPage({Key? key}) : super(key: key);

  @override
  State<OfficerFilesPage> createState() => _OfficerFilesPageState();
}

class _OfficerFilesPageState extends State<OfficerFilesPage> {
  final MediaController mediaController = Get.put(MediaController());
    final ScrollController newScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    
     WidgetsBinding.instance.addPostFrameCallback((_) {

    if (mediaController.mediaResources.isEmpty) {
          mediaController.loadMediaResources();
    }

    newScrollController.addListener(() async {
      if (newScrollController.position.pixels >=
          newScrollController.position.maxScrollExtent - 200) {
          mediaController.loadMediaOnScroll();
      }
    });
      });
  }

  @override
  Widget build(BuildContext context) {

      return Scaffold(
    backgroundColor: Palette.FBG,
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () => mediaController.loadMediaResources(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GetBuilder<MediaController>(
            builder: (controller) {
              return CustomScrollView(
                controller: newScrollController,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                 SliverGap(24),
controller.isLoading.value
    ? SliverAlignedGrid.count(
         crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
        itemCount: 10,
        itemBuilder: (context, index) {
          return ShimmerMediaResourceCardNew(
          );
        },
      )
    
                      : controller.mediaResources.isNotEmpty
                          ?  SliverAlignedGrid.count(
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
                  )
                          : ToSliver(
                              child: Center(
                                child: Text(
                                  'No media found',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black54),
                                ),
                              ),
                            ),
                  if (controller.isScrollLoading.value)
                     SliverAlignedGrid.count(
         crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
        itemCount: 10,
        itemBuilder: (context, index) {
          return ShimmerMediaResourceCardNew(
          );
        },
      ),
                      SliverGap(Get.size.height * 0.10)
                ],
              );
            },
          ),
        ),
      ),
    );
    // return Scaffold(
     
    //   body: GetBuilder<MediaController>(
    //     init: mediaController,
    //     builder: (controller) {
    //       if (controller.isLoading.value) {
    //         return CustomScrollView(
    //         slivers: [
    //           SliverPadding(
    //             padding: const EdgeInsets.all(16),
    //             sliver: SliverAlignedGrid.count(
    //               crossAxisCount: 3,
    //               mainAxisSpacing: 8,
    //               crossAxisSpacing: 8,
    //               itemCount: 10,
    //               itemBuilder: (context, index) {
                   
    //                 return ShimmerMediaResourceCardNew();
    //               },
    //             ),
    //           ),
    //         ],
    //       );
    //       }

    //       if (controller.mediaResources.isEmpty) {
    //         return const Center(
    //           child: Text(
    //             'No files found.',
    //             style: TextStyle(color: Colors.grey, fontSize: 16),
    //           ),
    //         );
    //       }

    //       return RefreshIndicator(
    //         onRefresh: ()=> controller.loadMediaResources(),
    //         child: CustomScrollView(
    //           slivers: [
    //             SliverPadding(
    //               padding: const EdgeInsets.all(16),
    //               sliver: SliverAlignedGrid.count(
    //                 crossAxisCount: 3,
    //                 mainAxisSpacing: 8,
    //                 crossAxisSpacing: 8,
    //                 itemCount: controller.mediaResources.length,
    //                 itemBuilder: (context, index) {
    //                   final mediaResource = controller.mediaResources[index];
    //                   return GestureDetector(
    //                     onTap: () {
    //                       // Call fullScreenDisplay with the selected media resource
    //                       controller.fullScreenDisplay(
    //                         controller.mediaResources,
    //                         mediaResource,
    //                       );
    //                     },
    //                     child: MediaResourceCardNew(mediaResource: mediaResource),
    //                   );
    //                 },
    //               ),
    //             ),
    //           ],
    //         ),
    //       );
    //     },
    //   ),
    // );
  }
}
