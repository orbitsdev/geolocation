import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/shimmer_widget.dart';
import 'package:get/get.dart';

class LoadingTasks extends StatelessWidget {
  const LoadingTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      constraints: const BoxConstraints(minHeight: 100),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerWidget(
                          width: Get.size.width * 0.60,
                          height: 18,
                        ),
                        ShimmerWidget(
                          width: Get.size.width * 0.20,
                          height:18,
                        ),
                      ]),
                  Gap(8),
                  Row(
                    children: [
                      ShimmerWidget(
                        width: 120,
                        height: 90,
                      ),
                      const Gap(8),
                      Expanded(
                          child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShimmerWidget(
                                width: Get.size.width * 0.60,
                                height: 16,
                              ),
                              const Gap(8),
                              ShimmerWidget(
                                width: Get.size.width * 0.60,
                                height: 16,
                              ),
                              const Gap(8),
                               ShimmerWidget(
                                width: Get.size.width * 0.60,
                                height: 16,
                              ),
                              const Gap(8),
                                 ShimmerWidget(
                                width: Get.size.width * 0.60,
                                height: 16,
                              ),
                            ]),
                      ))
                    ],
                  ),
                  Gap(8),
                  ShimmerWidget(
                    height: 1,
                    width: Get.size.width,
                  ),
                  Gap(8),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerWidget(
                          width: Get.size.width * 0.20,
                          height: 16,
                        ),
                        ShimmerWidget(
                          width: Get.size.width * 0.20,
                          height: 16,
                        ),
                      ]),
                  Gap(8),
                  ShimmerWidget(
                    height: 1,
                    width: Get.size.width,
                  ),
                  Gap(8),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerWidget(
                          width: Get.size.width * 0.60,
                          height: 16,
                        ),
                        ShimmerWidget(
                          width: Get.size.width * 0.20,
                          height: 16,
                        ),
                      ]),
                ]),
          ],
        ),
      ),
    );
  }
}
