import 'package:flutter/material.dart';
import 'package:geolocation/core/constant/path.dart';
import 'package:geolocation/core/globalwidget/images/local_lottie_image.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:lottie/lottie.dart'; // For animations
import 'package:geolocation/features/task/model/task.dart';

class TaskDetailsPage extends StatelessWidget {
  final Task task;

  const TaskDetailsPage({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.PRIMARY,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Background Animation
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: LocalLottieImage(path: lottiesPath('thumbsup.json')),
            ),
          ),
          // Content
          Positioned.fill(
            top: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Task Title and Greetings
                  _buildHeader(task),
                  SizedBox(height: 20),
                  // Card: Task Details
                  _buildTaskDetailsCard(context),
                  SizedBox(height: 20),
                  // Card: Attachments Section
                  if (task.media != null && task.media!.isNotEmpty) _buildAttachmentsCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Task task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hi there! 👋",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            color: Colors.white70,
          ),
        ),
        SizedBox(height: 6),
        Text(
          task.title ?? 'Your Task Awaits!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Icon(Icons.calendar_today_outlined, color: Colors.white70),
            SizedBox(width: 6),
            Text(
              task.dueDate ?? 'No Deadline',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTaskDetailsCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Task Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildDetailItem(Icons.info_outline, 'Status', task.status ?? 'To Do'),
            SizedBox(height: 10),
            _buildDetailItem(Icons.edit_note_outlined, 'Remarks', task.remarks ?? 'No Remarks'),
            SizedBox(height: 10),
            _buildDetailItem(Icons.check_circle_outline, 'Completed At', task.completedAt ?? 'Not Completed'),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent[400],
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              icon: Icon(Icons.check_rounded, color: Colors.white),
              label: Text(
                'Mark as Completed',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attachments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ...task.media!.map((media) {
              return ListTile(
                leading: Icon(
                  media.extension == 'pdf' ? Icons.picture_as_pdf : Icons.insert_drive_file_outlined,
                  color: Colors.red,
                ),
                title: Text(
                  media.url?.split('/').last ?? 'Unknown File',
                  style: TextStyle(color: Colors.black87),
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Icon(Icons.download_outlined, color: Colors.blue),
                onTap: () {
                  // Handle downloading
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey[600], size: 24),
        SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: '$label: ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
