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
    if (position.userId == AuthController.controller.user.value.id) {
      return _buildOwnerCard();
    } else {
      return _buildSlidableCard();
    }
  }

  Widget _buildOwnerCard() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white, // Light background
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8.0,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildCardContent(),
          ),
        ),
        if (position.grantAccess == true)
          Positioned(
            top: 8,
            right: 8,
            child: Text(
              '(Authorize)',
              style: Get.textTheme.bodySmall?.copyWith(
                color: Palette.deYork700,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSlidableCard() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color:Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8.0,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildCardContent(),
          ),
        ),
        if (position.grantAccess == true)
          Positioned(
            top: 8,
            right: 8,
            child: Text(
              '(Authorize)',
              style: Get.textTheme.bodySmall?.copyWith(
                color: Palette.deYork700,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCardContent() {
    return Column(
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
                backgroundColor: Palette.deYork200,
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
                        child: RichText(
                          text: TextSpan(
                            text: '',
                            children: [
                              TextSpan(
                                text: '${position.fullName ?? ''} ',
                                style: Get.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Palette.deYork900,
                                ),
                              ),
                              if (position.userId == AuthController.controller.user.value.id)
                                TextSpan(
                                  text: ' (You)',
                                  style: Get.textTheme.bodySmall?.copyWith(
                                    color: Palette.card2,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    position.position ?? 'Position not available',
                    style: Get.textTheme.bodySmall?.copyWith(
                      color: Palette.deYork700,
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
            _buildTaskInfo('Need Revision', position.totalNeedsRevision),
            _buildTaskInfo('Rejected', position.totalRejected),
          ],
        ),
      ],
    );
  }

  Widget _buildTaskInfo(String label, int? count) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          count?.toString() ?? '0',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Palette.deYork900,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Palette.deYork700,
          ),
        ),
      ],
    );
  }
}
