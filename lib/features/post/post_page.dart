import 'package:flutter/material.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/post/create_post_page.dart';
import 'package:get/get.dart';

class PostPage extends StatelessWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.LIGHT_BACKGROUND,
      body: CustomScrollView(
        slivers: [
          // Sliver App Bar for Create Post Button
          SliverAppBar(
            backgroundColor: Colors.white,
            pinned: true,
            // expandedHeight: 150.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Posts',
                style: TextStyle(color: Colors.black),
              ),
              // background: Image.network(
              //   'https://via.placeholder.com/600x200',
              //   fit: BoxFit.cover,
              // ),
            ),
            actions: [
              TextButton.icon(
                onPressed: () {
                  // Navigate to Create Post Page
                  Get.to(() => CreatePostPage(), transition: Transition.cupertino);
                },
                icon: Icon(Icons.create, color: Palette.PRIMARY),
                label: Text(
                  'New Post',
                  style: TextStyle(color: Palette.PRIMARY),
                ),
              ),
            ],
          ),

          // Sliver List for Post Content
          SliverPadding(
            padding: EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  // Example post
                  _buildPost(
                    context: context,
                    authorName: 'Kareem Aljabari',
                    authorImageUrl: 'https://i.pravatar.cc/150?img=1',
                    postContent:
                        'The always cheerful spirit of sunflowers inspires me to always be optimistic in facing...',
                    postImageUrl: 'https://via.placeholder.com/600',
                    postDate: '1h ago',
                  ),
                  _buildPost(
                                        context: context,

                    authorName: 'Jane Smith',
                    authorImageUrl: 'https://i.pravatar.cc/150?img=5',
                    postContent:
                        'Loving the new features in our app!',
                    postImageUrl: 'https://via.placeholder.com/600x300',
                    postDate: '2h ago',
                  ),
                  _buildPost(
                                        context: context,

                    authorName: 'John Doe',
                    authorImageUrl: 'https://i.pravatar.cc/150?img=12',
                    postContent: 'Another great day to work on our projects!',
                    postImageUrl: 'https://via.placeholder.com/600x300',
                    postDate: '3h ago',
                  ),
                  // Add more posts as needed
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPost({
    required BuildContext context,
    required String authorName,
    required String authorImageUrl,
    required String postContent,
    required String postImageUrl,
    required String postDate,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header with Menu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(authorImageUrl),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authorName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        postDate,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                onPressed: () {
                  _showPostMenu(context);
                },
              ),
            ],
          ),
          SizedBox(height: 16),

          // Post Content
          Text(
            postContent,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16),

          // Post Image
          if (postImageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network('https://picsum.photos/200/300'),
            ),

          SizedBox(height: 16),

          // Like Button and Interactions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.thumb_up_alt_outlined, color: Colors.grey[600]),
                    onPressed: () {
                      // Handle like action
                    },
                  ),
                  Text(
                    'Like',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              // Additional buttons for comments or shares can be added here
            ],
          ),
        ],
      ),
    );
  }

  void _showPostMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.edit, ),
              title: Text('Edit Post'),
              onTap: () {
                // Handle edit action
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, ),
              title: Text('Delete Post'),
              onTap: () {
                // Handle delete action
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
