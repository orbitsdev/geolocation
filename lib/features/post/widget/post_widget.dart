import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/features/collections/model/collection.dart';
import 'package:geolocation/features/post/widget/collection_chart_widget.dart';
import 'package:get/get.dart';

import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/globalwidget/images/online_image_full_screen_display.dart';
import 'package:geolocation/core/globalwidget/preview_image.dart';
import 'package:geolocation/core/globalwidget/preview_video.dart';
import 'package:geolocation/features/file/model/media_file.dart';
import 'package:geolocation/features/post/model/post.dart';
import 'package:geolocation/features/video/online_video_player.dart';

class PostWidget extends StatelessWidget {
  final Post post;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PostWidget({
    Key? key,
    required this.post,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and timestamp
          _buildHeader(),

          const SizedBox(height: 8),

          // Post Content
          if (post.content != null && post.content!.isNotEmpty)
            Text(
              post.content!,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),

          const SizedBox(height: 8),

          // Media Grid (Images/Videos)
          if (post.media != null && post.media!.isNotEmpty)
            _buildMediaGrid(post.media!),

          const SizedBox(height: 12),

          if (post.relatedModel != null &&
              post.relatedModel!.type == 'Collection' &&
              post.relatedModel!.data is Collection) ...[
            const Text(
              'Collection Chart:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            CollectionChartWidget(
              collection: post.relatedModel!.data as Collection,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 60,
          width: 60,
          child: OnlineImage(
            imageUrl: '${post.councilPosition?.image}',
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        const Gap(8),

        // Title and Timestamp
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title ?? 'Untitled Post',
                style: Get.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                post.createdAt ?? 'Just now',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),

        // Menu Icon
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == 'edit') {
              onEdit();
            } else if (value == 'delete') {
              onDelete();
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit'),
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMediaGrid(List<MediaFile> mediaFiles) {
    final int mediaCount = mediaFiles.length;
    final List<MediaFile> displayedFiles = mediaFiles.take(6).toList();

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Display 3 items per row
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: displayedFiles.length,
      itemBuilder: (context, index) {
        if (index == 5 && mediaCount > 6) {
          return _buildMoreOverlay(mediaCount - 6);
        }
        return _buildMedia(displayedFiles[index]);
      },
    );
  }

  Widget _buildMoreOverlay(int remainingCount) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Icon(Icons.image, color: Colors.white, size: 40),
          ),
        ),
        Center(
          child: Text(
            "+$remainingCount",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSingleMedia(MediaFile file) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: _buildMedia(file),
    );
  }

  Widget _buildMedia(MediaFile file) {
    return GestureDetector(
      onTap: () {
        if (MediaFile.imageFormats.contains(file.extension)) {
          Get.to(() => OnlineImageFullScreenDisplay(imageUrl: file.url ?? ''));
        } else if (MediaFile.videoFormats.contains(file.extension)) {
          Get.to(() => OnlineVideoPlayer(url: file.url ?? ''));
        }
      },
      child: MediaFile.imageFormats.contains(file.extension)
          ? PreviewImage(url: file.url ?? '', height: 160)
          : MediaFile.videoFormats.contains(file.extension)
              ? PreviewVideo(file: file, height: 160)
              : Center(
                  child: Icon(Icons.file_present, size: 40, color: Colors.grey),
                ),
    );
  }
}
