// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:geolocation/core/globalwidget/images/online_image.dart';

class PreviewImage extends StatelessWidget {

  String url;
  double? height;
   PreviewImage({
    Key? key,
    required this.url,
    this.height,
  }) : super(key: key);
  

  @override
  Widget build(BuildContext context){
    return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8)
                            ),
                            height: height ?? 125,

                             child: Stack(
                               children: [
                                 OnlineImage(imageUrl: '${url}', borderRadius: BorderRadius.circular(8)),
                                 Container(
                decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.5), // Start color
                      Colors.transparent, // End color
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ))
                               ],
                             ));
  }
}
