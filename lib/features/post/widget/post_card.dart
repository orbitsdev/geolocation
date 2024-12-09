import 'package:flutter/material.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/post/model/post.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Palette.BACKGROUND, // Apply custom theme background
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post Title
            Text(
              post.title ?? "Untitled Post",
              style: Theme.of(context).textTheme.titleLarge, // Use AppTheme's titleLarge
            ),
            const SizedBox(height: 8),

            // Post Description
            if (post.description != null && post.description!.isNotEmpty)
              Text(
                post.description!,
                style: Theme.of(context).textTheme.bodyMedium, // Use AppTheme's bodyMedium
              ),

            const SizedBox(height: 8),

            // Created Date or Publishing Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (post.createdAt != null)
                  Text(
                    "Created: ${post.createdAt}",
                    style: Theme.of(context).textTheme.bodySmall, // Use AppTheme's bodySmall
                  ),
                if (post.isPublish != null)
                  Text(
                    post.isPublish! ? "Published" : "Unpublished",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: post.isPublish! ? Colors.green : Colors.red,
                        ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
