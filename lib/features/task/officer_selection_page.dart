import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/globalwidget/sliver_gap.dart';
import 'package:geolocation/core/globalwidget/to_sliver.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/auth/model/council_position.dart';
import 'package:geolocation/features/officers/officer_card.dart';
import 'package:geolocation/features/task/controller/search_officer_controller.dart';
import 'package:geolocation/features/task/controller/task_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:heroicons/heroicons.dart';

class OfficerSelectionPage extends StatelessWidget {
  const OfficerSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

     final searchController = Get.put(SearchOfficerController());
    return Scaffold(
      backgroundColor: Palette.LIGHT_BACKGROUND,
      body: GestureDetector(
        onTap: (){
              FocusScope.of(context).unfocus();
          // if (FocusScope.of(context).hasPrimaryFocus) {
          //   }
        },
        child: CustomScrollView(
          
          slivers: [
            SliverAppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              title: Text(
                'Select Officer',
                style: Get.textTheme.titleLarge?.copyWith(),
              ),
              leading: IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.arrow_back,
                ),
              ),
              pinned: true,
              floating: true,
            ),
            SliverGap(8),
            ToSliver(
              child: Container(
                decoration: BoxDecoration(
                 
                ),
                padding: EdgeInsets.only(left: 8, right: 8, bottom: 8 ),
                child: TextField(
                   controller: searchController.textController,
                  autofocus: true,
                  // controller: searchController.textController,
                  style: Get.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                  decoration: InputDecoration(
                  
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Search...',
                    hintStyle: Get.textTheme.bodyMedium,
                    prefixIcon: Container(
                      
                      child: HeroIcon(HeroIcons.magnifyingGlass, size: 24,color: Palette.PRIMARY,)),
                    suffixIcon: searchController.searchText.value.trim().isNotEmpty
                        ? IconButton(
                            onPressed: searchController.clearSearch,
                            icon: Icon(Icons.close, size: 16,),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                ),
              ),
              
            ),
        
            // ToSliver(child:  LinearProgressIndicator(
            //           minHeight: 2,
            //           color: Palette.PRIMARY,
            //         ),
            //       ),
        
              GetBuilder<SearchOfficerController>(
              builder: (controller) {
                if (controller.isSearchLoading.value ||
                    controller.isInitialDataLoading.value) {
                  return ToSliver(
                    child: LinearProgressIndicator(
                      minHeight: 2,
                      color: Palette.PRIMARY,
                    ),
                  );
                } else {
                  return ToSliver(
                    child: Container(height: 2),
                  );
                }
              },
            ),
        
              SliverGap(8),
            GetBuilder<SearchOfficerController>(
              builder: (controller) {
             
                return SliverPadding(
                    padding: EdgeInsets.only(left: 8.0, right: 8, bottom: 8 ),
                  sliver: SliverMasonryGrid.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childCount: controller.officers.length,
                          itemBuilder: (context, index) {
                            CouncilPosition officer = controller.officers[index];
                            // return Container();
                            return RippleContainer(
                              onTap: (){
                             TaskController.controller.selectOfficer(officer);                                 
                              },child: OfficerCard(officer: officer)
                            );
                          
                          },
                        ),
                );
              }
            ),
        
          ],
        ),
      ),
    );
  }
}
