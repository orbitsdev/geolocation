import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/task/model/task.dart';

class TaskCard2 extends StatelessWidget {
  final Task task;

  const TaskCard2({
    required this.task,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border(
      left: BorderSide(
        color: Palette.deYork600, // Color of the left border
        width: 8, // Width of the left border
      ),
    ),
      ),
     

    
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header (Task Owner)
            if (task.assignedCouncilPosition != null &&
                task.assignedCouncilPosition?.id !=
                    AuthController.controller.user.value.defaultPosition?.id)
              _buildOwnerSection(),

            if (task.assignedCouncilPosition != null &&
                task.assignedCouncilPosition?.id !=
                    AuthController.controller.user.value.defaultPosition?.id)
              Divider(color: Palette.deYork200, height: 24),

            // Task Title and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    task.title ?? 'Untitled Task',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
                _buildStatusBadge(task.status),
              ],
            ),

            const Gap(12),

            // Task Details
            Text(
              task.taskDetails?.isNotEmpty == true
                  ? task.taskDetails!
                  : 'No details available.',
              style: TextStyle(
                color: task.taskDetails?.isNotEmpty == true
                    ? Palette.lightText
                    : Colors.grey[600],
                fontSize: 14,
                fontStyle:
                    task.taskDetails?.isNotEmpty == true ? FontStyle.normal : FontStyle.italic,
              ),
            ),

            const Gap(16),

            // Task Footer
            _buildFooter(),

            const Gap(12),

            // Approved By Section
            if (task.approvedByCouncilPosition != null)
              _buildApprovalSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildOwnerSection() {
    return Row(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: Palette.FBG,
          ),
          child: OnlineImage(
            imageUrl: task.assignedCouncilPosition?.image ?? '',
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        const Gap(8),
        Expanded(
          child: Text(
            task.assignedCouncilPosition?.fullName ?? 'Unassigned Position',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String? status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _getPriorityColor(status),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status ?? 'Unknown',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        FaIcon(FontAwesomeIcons.calendar, size: 16, color: Palette.lightText),
        const Gap(6),
        Text(
          'Due Date: ${task.dueDate ?? 'No Due Date'}',
          style: const TextStyle(fontSize: 12, color: Colors.black87),
        ),
      ],
    );
  }

 Widget _buildApprovalSection() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: Palette.deYork50,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Palette.deYork300, width: 0.5),
    ),
    child: Row(
      children: [
        Icon(Icons.check_circle, color: Palette.GREEN2, size: 18),
        const Gap(8),
        Flexible(
          child: Text(
            'Approved by: ${task.approvedByCouncilPosition?.fullName ?? 'N/A'}',
            style: TextStyle(
              color: Palette.deYork700,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              height: 1.3, // Improves readability
            ),
          ),
        ),
      ],
    ),
  );
}


  Color _getPriorityColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'to do':
        return Colors.grey.shade300;
      case 'in progress':
        return Colors.blue.shade300;
      case 'completed':
        return Palette.deYork600;
      case 'needs revision':
        return Palette.orange;
      case 'rejected':
        return Palette.RED;
      default:
        return Colors.blueGrey.shade200;
    }
  }
}
