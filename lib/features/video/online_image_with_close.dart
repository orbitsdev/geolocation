// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/shimmer_widget.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:get/get.dart';


class OnineImageWithClose extends StatelessWidget {
  final String imageUrl;
  final BorderRadiusGeometry? borderRadius;
  final BorderRadiusGeometry? borderRadiusClipRect;
  final Widget? shimmer;
  final bool? isCover;
  final BoxFit? fit;
  final double? noImageIconSize;
  final bool? enableFilter;
  final VoidCallback? onClose; // Optional callback for the close button

  OnineImageWithClose({
    Key? key,
    required this.imageUrl,
    this.borderRadius,
    this.borderRadiusClipRect,
    this.shimmer,
    this.isCover,
    this.noImageIconSize,
    this.enableFilter = false,
    this.fit,
    this.onClose, // Accept onClose callback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Image or placeholder
        imageUrl.isEmpty
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: borderRadius ?? BorderRadius.circular(2),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Icon(
                        Icons.image,
                        size: noImageIconSize ?? 24,
                        color: Palette.TEXT_LIGHT,
                      ),
                    ),
                  ],
                ),
              )
            : CachedNetworkImage(
                imageUrl: imageUrl,
                placeholder: (context, url) => shimmer ?? ShimmerWidget(borderRadius: borderRadius ?? BorderRadius.circular(2)),
                errorWidget: (context, url, error) => Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius ?? BorderRadius.circular(2),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Icon(
                          Icons.image,
                          size: noImageIconSize ?? 24,
                          color: Palette.TEXT_LIGHT,
                        ),
                      ),
                      Gap(2),
                      Text(
                        'No Image',
                        style: Get.textTheme.bodySmall!.copyWith(color: Palette.DARK_PRIMARY),
                      ),
                    ],
                  ),
                ),
                fit: BoxFit.contain,
                width: Get.size.width,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius ?? BorderRadius.circular(2),
                    image: DecorationImage(
                      colorFilter: enableFilter == true
                          ? ColorFilter.mode(Colors.grey, BlendMode.saturation)
                          : null,
                      image: imageProvider,
                      fit: fit ?? BoxFit.cover,
                    ),
                  ),
                ),
              ),
        // Close button at the top right corner
        Positioned(
          top: 40,
          right: 20,
          child: IconButton(
            icon: Icon(Icons.close, color: Colors.white, size: 30),
            onPressed: onClose ?? () => Get.back(), // Use onClose callback if provided
          ),
        ),
      ],
    );
  }
}

