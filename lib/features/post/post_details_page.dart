import 'package:flutter/material.dart';
import 'package:geolocation/features/auth/model/council_position.dart';
import 'package:geolocation/features/councils/model/council.dart';
import 'package:geolocation/features/file/model/media_file.dart';
import 'package:geolocation/features/post/model/post.dart';
import 'package:geolocation/features/post/model/related_model.dart';

class PostDetailsPage extends StatelessWidget {
  final Post post;

  const PostDetailsPage({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title ?? "Post Details"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post Title and Description
            Text(
              post.title ?? "No Title",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              post.description ?? "No Description",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 16),

            // Post Content
            Text(
              post.content ?? "No Content Available",
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            SizedBox(height: 16),

            // Created and Updated At
            _buildInfoRow("Created At:", post.createdAt ?? "N/A"),
            _buildInfoRow("Updated At:", post.updatedAt ?? "N/A"),
            SizedBox(height: 16),

            // Publish Status
            _buildInfoRow(
              "Published:",
              post.isPublish == true ? "Yes" : "No",
            ),

            SizedBox(height: 20),
            Divider(),

            // Media Section
            if (post.media != null && post.media!.isNotEmpty) ...[
              Text(
                "Media Files:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _buildMediaGrid(post.media!),
              SizedBox(height: 20),
              Divider(),
            ],

            // Council Section
            if (post.council != null) ...[
              Text(
                "Council:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _buildCouncilSection(post.council!),
              SizedBox(height: 20),
              Divider(),
            ],

            // Council Position Section
            if (post.councilPosition != null) ...[
              Text(
                "Council Position:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _buildCouncilPositionSection(post.councilPosition!),
              SizedBox(height: 20),
              Divider(),
            ],

            // Related Model Section
            if (post.relatedModel != null) ...[
              Text(
                "Related Model:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _buildRelatedModelSection(post.relatedModel!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaGrid(List<MediaFile> mediaList) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: mediaList.length,
      itemBuilder: (context, index) {
        final media = mediaList[index];
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[200],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.insert_drive_file,
                  size: 40,
                  color: Colors.blueAccent,
                ),
                SizedBox(height: 8),
                Text(
                  media.file_name ?? "File",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCouncilSection(Council council) {
    return ListTile(
      title: Text(council.name ?? "Council Name"),
      subtitle: Text(council.isActive == true ? "Active" : "Inactive"),
      trailing: Text(
        "ID: ${council.id ?? 'N/A'}",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCouncilPositionSection(CouncilPosition position) {
    return ListTile(
      leading: position.image != null
          ? CircleAvatar(
              backgroundImage: NetworkImage(position.image!),
            )
          : CircleAvatar(
              child: Icon(Icons.person),
            ),
      title: Text(position.fullName ?? "No Name"),
      subtitle: Text(position.position ?? "No Position"),
      trailing: Text(
        position.isLogin == true ? "Logged In" : "Offline",
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: position.isLogin == true ? Colors.green : Colors.red),
      ),
    );
  }

  Widget _buildRelatedModelSection(RelatedModel model) {
    return ListTile(
      title: Text("Type: ${model.type ?? "Unknown"}"),
      subtitle: Text("ID: ${model.id ?? "N/A"}"),
    );
  }
}
