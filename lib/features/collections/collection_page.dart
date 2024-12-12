import 'package:flutter/material.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/globalwidget/sliver_gap.dart';
import 'package:geolocation/core/globalwidget/to_sliver.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/collections/collection_details_page.dart';
import 'package:geolocation/features/collections/controller/collection_controller.dart';
import 'package:geolocation/features/collections/create_or_edit_collection_page.dart';
import 'package:geolocation/features/collections/model/collection.dart';
import 'package:geolocation/features/collections/widgets/collection_card.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({Key? key}) : super(key: key);

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  final CollectionController controller = Get.find<CollectionController>();
  final ScrollController newScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.collections.isEmpty) {
        controller.loadData(); // Load initial data
      }

      // Debounce scroll listener
      newScrollController.addListener(() async {
        if (newScrollController.position.pixels >=
                newScrollController.position.maxScrollExtent - 200 &&
            !controller.isScrollLoading.value &&
            controller.hasData.value) {
          controller.loadDataOnScroll();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Collections',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Palette.PRIMARY),
            onPressed: () {
              CollectionController.controller.clearForm();
              
              Get.to(() => CreateOrEditCollectionPage());
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () => controller.loadData(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GetBuilder<CollectionController>(
            builder: (controller) {
              return CustomScrollView(
                controller: newScrollController,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // Add spacing at the top
                  SliverToBoxAdapter(child: const SizedBox(height: 8)),

                  // Main content
                  controller.isPageLoading.value
                      ? const SliverToBoxAdapter(
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : controller.collections.isNotEmpty
                          ? SliverMasonryGrid.count(
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              crossAxisCount: 1,
                              childCount: controller.collections.length,
                              itemBuilder: (context, index) {
                                Collection collection =
                                    controller.collections[index];
                                return RippleContainer(
                                  onTap: ()=>  Get.to(()=> CollectionDetailsPage(collection: collection,)),
                                  child: CollectionCard(
                                    collection: collection,
                                    onEdit: () {
                                      controller
                                          .selectItemAndNavigateToUpdatePage(
                                              collection);
                                    },
                                    onDelete: () async {
                                     controller.deleteCollection(collection
                                            .id!); 
                                    },
                                  ),
                                );
                              },
                            )
                          : const SliverToBoxAdapter(
                              child: Center(
                                child: Text(
                                  'No collections found',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),

                  // Scroll-loading indicator
                  if (controller.isScrollLoading.value)
                    const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    ),

                    

                  SliverGap(Get.size.height * 0.10)
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
