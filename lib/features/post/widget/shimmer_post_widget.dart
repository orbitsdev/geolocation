import 'package:flutter/material.dart';
import 'package:geolocation/core/globalwidget/shimmer/shimmer.dart';
import 'package:geolocation/core/theme/palette.dart';

class ShimmerPostWidget extends StatelessWidget {
   ShimmerPostWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding:  EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
       
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header shimmer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  ShimmerWidget(
                    width: 120,
                    height: 20,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  SizedBox(height: 8),
                  ShimmerWidget(
                    width: 80,
                    height: 16,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                ],
              ),
               ShimmerWidget(
                width: 24,
                height: 24,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ],
          ),

           SizedBox(height: 12),

          // Content shimmer
           ShimmerWidget(
            width: double.infinity,
            height: 16,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
           SizedBox(height: 8),
           ShimmerWidget(
            width: double.infinity,
            height: 16,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),

           SizedBox(height: 12),

          // Media shimmer (Image/Video)
           ShimmerWidget(
            width: double.infinity,
            height: 180,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),

           SizedBox(height: 12),

          // Footer shimmer
          Row(
            children:  [
              ShimmerWidget(
                width: 60,
                height: 20,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              SizedBox(width: 16),
              ShimmerWidget(
                width: 60,
                height: 20,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
