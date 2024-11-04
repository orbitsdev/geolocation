import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/globalwidget/images/online_image_full_screen_display.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/auth/model/council_position.dart';
import 'package:get/get.dart';

class CouncilPositionCard extends StatelessWidget {
  final CouncilPosition position;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  CouncilPositionCard({
    required this.position,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(position.id.toString()),

      // The end action pane, for the delete action
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => onDelete(),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),

      // The main content of the card
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row with image and name
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RippleContainer(
                        onTap: () => Get.to(() => OnlineImageFullScreenDisplay(imageUrl: position.image!)),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey[200],
                          child: OnlineImage(
                            imageUrl: position.image ?? '',
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    position.fullName ?? 'N/A',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if(position.userId == AuthController.controller.user.value.id)Text(
                                  'You',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              position.position ?? 'Position not available',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
          
                  // Task-related information
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTaskInfo('To Do', position.totalToDoTasks),
                      _buildTaskInfo('In Progress', position.totalInProgressTasks),
                      _buildTaskInfo('Completed', position.totalCompletedTasks),
                      _buildTaskInfo('Blocked', position.totalBlockedTasks),
                    ],
                  ),
                ],
              ),
            ),
          ),

         if(position.grantAccess == true)Positioned(
            top: 8,
            right: 8,
            child:Text('(Authorize)',style: Get.textTheme.bodySmall?.copyWith(
              color: Colors.grey
            ),))
        ],
      ),
    );
  }

  // Helper widget to build task information display
  Widget _buildTaskInfo(String label, int? count) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          count?.toString() ?? '0',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
