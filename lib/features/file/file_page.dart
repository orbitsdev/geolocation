import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geolocation/core/globalwidget/empty_state.dart';
import 'package:geolocation/core/theme/game_pallete.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/file/controller/files_controller.dart';
import 'package:geolocation/features/file/model/file_item.dart';
import 'package:get/get.dart';


class FilesPage extends StatelessWidget {
  final FilesController controller = Get.find<FilesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Files',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.files.isEmpty) {
          return EmptyState(
            label: 'No files found',
           
          );
        }

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.all(16),
              sliver: SliverMasonryGrid.count(
                crossAxisCount: 1,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                childCount: controller.files.length,
                itemBuilder: (context, index) {
                  final file = controller.files[index];
                  return GestureDetector(
                    onTap: () => _showFileOptions(context, file),
                    child: _buildFileCard(file),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildFileCard(FileItem file) {
    return Container(
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
      child: Row(
        children: [
          _buildFileIcon(file.extension),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              file.name,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileIcon(String extension) {
    IconData iconData;
    switch (extension.toLowerCase()) {
      case 'pdf':
        iconData = Icons.picture_as_pdf;
        break;
      case 'doc':
      case 'docx':
        iconData = Icons.description;
        break;
      default:
        iconData = Icons.insert_drive_file;
        break;
    }

    return Icon(
      iconData,
      color: Palette.PRIMARY,
      size: 36,
    );
  }

  void _showFileOptions(BuildContext context, FileItem file) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.visibility),
              title: Text('View'),
              onTap: () {
                Navigator.pop(context);
                // Implement view file logic
              },
            ),
            ListTile(
              leading: Icon(Icons.download),
              title: Text('Download'),
              onTap: () {
                Navigator.pop(context);
                // Implement download file logic
              },
            ),
          ],
        );
      },
    );
  }
}
