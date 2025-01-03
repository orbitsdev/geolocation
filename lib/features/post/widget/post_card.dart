import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
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

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PostCard({
    Key? key,
    required this.post,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const Gap(12),
            if (post.content != null && post.content!.isNotEmpty)
              Text(
                post.content!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            const Gap(12),
            if (post.media != null && post.media!.isNotEmpty)
              _buildMediaLayout(post.media!),
            const Gap(12),
            if (post.relatedModel != null &&
                post.relatedModel!.type == 'Collection' &&
                post.relatedModel!.data is Collection)
              _buildCollection(post.relatedModel!.data as Collection),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
           height: 50,
          width: 50,
          child: OnlineImage(
            imageUrl: post.councilPosition?.image ?? '',
            borderRadius: BorderRadius.circular(40),
           
          ),
        ),
        const Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title ?? 'Untitled Post',
                style: Get.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Gap(4),
              Text(
                post.createdAt ?? 'Just now',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == 'edit') onEdit();
            if (value == 'delete') onDelete();
          },
          itemBuilder: (context) => [
            if (post.owner(AuthController.controller.user.value.defaultPosition?.id))
              const PopupMenuItem(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Edit'),
                ),
              ),
            if (post.owner(AuthController.controller.user.value.defaultPosition?.id))
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

  Widget _buildMediaLayout(List<MediaFile> mediaFiles) {
    int mediaCount = mediaFiles.length;

    if (mediaCount == 1) {
      return _buildSingleMedia(mediaFiles[0]);
    } else if (mediaCount == 2) {
      return Row(
        children: mediaFiles.map((file) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: _buildMedia(file),
            ),
          );
        }).toList(),
      );
    } else {
      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: mediaCount,
        itemBuilder: (context, index) {
          return _buildMedia(mediaFiles[index]);
        },
      );
    }
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
          ? PreviewImage(url: file.url ?? '')
          : MediaFile.videoFormats.contains(file.extension)
              ? PreviewVideo(file: file)
              : const Center(
                  child: Icon(Icons.file_present, size: 40, color: Colors.grey),
                ),
    );
  }

  Widget _buildCollection(Collection collection) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CollectionChartWidget(collection: collection),
        const Gap(24),
      ],
    );
  }
}
