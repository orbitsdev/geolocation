// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:geolocation/core/globalwidget/images/online_image.dart';
// import 'package:geolocation/core/theme/palette.dart';
// import 'package:geolocation/features/auth/controller/auth_controller.dart';
// import 'package:geolocation/features/task/model/task.dart';
// class TaskCard2 extends StatelessWidget {
//   final Task task;

//   const TaskCard2({
//     required this.task,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [

//             if (task.assignedCouncilPosition != null && (task.assignedCouncilPosition?.id != AuthController.controller.user.value.defaultPosition?.id))
//               Row(
//                 children: [
//                   Container(
//                     height: 34,
//                     width: 34,
                    
//                     child: OnlineImage(imageUrl: task.assignedCouncilPosition?.image ??'', borderRadius: BorderRadius.circular(34),),
//                   ),

//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       task.assignedCouncilPosition?.fullName ??
//                           'Unassigned Position',
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//          if (task.assignedCouncilPosition != null && (task.assignedCouncilPosition?.id != AuthController.controller.user.value.defaultPosition?.id)) Divider(color: Palette.FBG,),
//          if (task.assignedCouncilPosition != null && (task.assignedCouncilPosition?.id != AuthController.controller.user.value.defaultPosition?.id)) Gap(8),
//             // Header Row
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   task.title ?? 'Untitled Task',
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: _getPriorityColor(task.status),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     task.status ?? 'Unknown',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 8),

//             // Task Details
//             Text(
//               task.taskDetails ?? 'No details available.',
//               style: TextStyle(
//                 color: Colors.grey[700],
//                 fontSize: 14,
//               ),
//             ),

//             const SizedBox(height: 8),

//             // Footer Row
//            Row(
//   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   children: [
//     Row(
//       children: [
//         Icon(Icons.calendar_today, size: 18, color: Colors.grey[600]), // Changed the icon to calendar
//         const SizedBox(width: 4),
//         Text(
//           'Due Date: ${task.dueDate ?? 'No Due Date'}', // Displaying dueDate instead of position
//           style: const TextStyle(fontSize: 12),
//         ),
//       ],
//     ),
   
//   ],
// ),
// Gap(8),
// if (task.approvedByCouncilPosition != null)
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.green.shade400, Colors.green.shade600],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Icon(Icons.check_circle, color: Colors.white, size: 20),
//                     const SizedBox(width: 8),
//                     Flexible(
//                       child: Text(
//                         'Approved by: ${task.approvedByCouncilPosition?.fullName ?? 'N/A'} ',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//           ],
//         ),
//       ),
//     );
//   }

//   Color _getPriorityColor(String? status) {
//     switch (status?.toLowerCase()) {
//       case 'to do':
//         return Colors.grey;
//       case 'in progress':
//         return Colors.blueAccent;
//       case 'completed':
//         return Colors.green;
//       case 'needs revision':
//         return Colors.orange;
//       case 'rejected':
//         return Colors.red;
//       default:
//         return Colors.blueGrey;
//     }
//   }
// }




import 'package:flutter/material.dart';
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
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
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
               Divider(color: Palette.FBG, height: 24),

            // Task Title and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    task.title ?? 'Untitled Task',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                _buildStatusBadge(task.status),
              ],
            ),

            const Gap(12),

            // Task Details
            if (task.taskDetails != null && task.taskDetails!.isNotEmpty)
              Text(
                task.taskDetails!,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  height: 1.5,
                ),
              )
            else
              Text(
                'No details available.',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),

            const Gap(16),

            // Task Due Date
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
          child: OnlineImage(
            imageUrl: task.assignedCouncilPosition?.image ?? '',
            borderRadius: BorderRadius.circular(34),
          
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
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String? status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _getPriorityColor(status),
        borderRadius: BorderRadius.circular(12),
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
        Icon(Icons.calendar_today, size: 18, color: Colors.grey[600]),
        const Gap(4),
        Expanded(
          child: Text(
            'Due Date: ${task.dueDate ?? 'No Due Date'}',
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildApprovalSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade400, Colors.green.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.white, size: 20),
          const Gap(12),
          Flexible(
            child: Text(
              'Approved by: ${task.approvedByCouncilPosition?.fullName ?? 'N/A'}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
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
        return Colors.grey;
      case 'in progress':
        return Colors.blueAccent;
      case 'completed':
        return Colors.green;
      case 'needs revision':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }
}
