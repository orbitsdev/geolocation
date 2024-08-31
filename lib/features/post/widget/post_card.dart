import 'package:flutter/material.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';

class PostCard extends StatelessWidget {
const PostCard({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
     return Container(
                    height: 260, // Explicitly set the height
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red, // Set a color to see the container
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: OnlineImage(
                          imageUrl: 'https://picsum.photos/200/300'),
                    ),
                  );
                
  }
}