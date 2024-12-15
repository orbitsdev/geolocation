import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/globalwidget/preview_image_new.dart';
import 'package:geolocation/core/globalwidget/preview_other_file_new.dart';
import 'package:geolocation/core/globalwidget/preview_video_new.dart';
import 'package:geolocation/features/files/model/media_resource.dart';


class MediaResourceCardNew extends StatelessWidget {
  final MediaResource mediaResource;

  const MediaResourceCardNew({Key? key, required this.mediaResource})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Preview the file based on its type
        if (mediaResource.type?.startsWith('image') == true)
          PreviewImageNew(url: mediaResource.url ?? '')
        else if (mediaResource.type?.startsWith('video') == true)
          PreviewVideoNew(
            url: mediaResource.url ?? '',
            height: 85,
          )
        else
          PreviewOtherFileNew(
            fileName: mediaResource.fileName ?? 'Unknown',
            extension: mediaResource.extension ?? 'File',
          ),
    
        const Gap(8),
    
        // File Name
        Text(
          mediaResource.fileName ?? 'Unknown File',
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          maxLines: 1,
        ),
    
        // Uploader Information
        const Gap(4),
        Row(
          children: [
            Container(
              height: 20,
              width: 20,child: OnlineImage(imageUrl: mediaResource.councilPosition?.image ??'', borderRadius: BorderRadius.circular(20),),
              
            ),
            
            const Gap(4),
            Flexible(
              child: Text(
                mediaResource.councilPosition?.fullName ?? 'Unknown',
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.black54,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
