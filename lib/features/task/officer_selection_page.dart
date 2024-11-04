import 'package:flutter/material.dart';
import 'package:geolocation/core/globalwidget/to_sliver.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:heroicons/heroicons.dart';

class OfficerSelectionPage extends StatelessWidget {
  const OfficerSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
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

          ToSliver(
            child: Container(
              decoration: BoxDecoration(
               
              ),
              padding: EdgeInsets.only(left: 16.0, right: 16, bottom: 8 ),
              child: TextField(
                autofocus: true,
                // controller: searchController.textController,
                style: Get.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.normal,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Palette.LIGHT_BACKGROUND,
                  hintText: 'Search...',
                  hintStyle: Get.textTheme.bodyMedium,
                  prefixIcon: Container(
                    
                    child: HeroIcon(HeroIcons.magnifyingGlass, size: 24,color: Palette.PRIMARY,)),
                  // suffixIcon: searchController.searchText.value.trim().isNotEmpty
                  //     ? IconButton(
                  //         onPressed: searchController.clearSearch,
                  //         icon: Icon(Icons.close, size: 16,),
                  //       )
                  //     : null,
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
        ],
      ),
    );
  }
}
