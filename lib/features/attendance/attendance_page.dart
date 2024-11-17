// import 'package:flutter/material.dart';
// import 'package:geolocation/core/theme/palette.dart';
// import 'package:geolocation/features/attendance/controller/attendance_controller.dart';
// import 'package:geolocation/features/event/model/event.dart';
// import 'package:get/get.dart';
// import 'package:geolocator/geolocator.dart';

// class AttendancePage extends StatelessWidget {
//   final AttendanceController controller = Get.find<AttendanceController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Attendance', style: TextStyle(color: Colors.black87)),
//         backgroundColor: Colors.white,
//         elevation: 1,
//         iconTheme: IconThemeData(color: Colors.black87),
//       ),
//       body: Obx(() {
//         return ListView.builder(
//           padding: EdgeInsets.all(16),
//           itemCount: controller.events.length,
//           itemBuilder: (context, index) {
//             final event = controller.events[index];
//             return _buildEventCard(event);
//           },
//         );
//       }),
//     );
//   }

//   Widget _buildEventCard(Event event) {
//     return Card(
//       margin: EdgeInsets.only(bottom: 16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               event.title,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Palette.DARK_PRIMARY,
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               event.description,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.black87,
//               ),
//             ),
//             SizedBox(height: 8),
//             Row(
//               children: [
//                 Icon(Icons.calendar_today, size: 14, color: Palette.PRIMARY),
//                 SizedBox(width: 4),
//                 Text(
//                   event.date,
//                   style: TextStyle(fontSize: 12, color: Colors.black54),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),
//             Obx(() {
//               return ElevatedButton(
//                 onPressed: controller.isWithinGeofence(event) ? () {
//                   controller.markAttendance(event);
//                 } : null,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.white,
//                   disabledForegroundColor: Colors.grey,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: Text(controller.hasMarkedAttendance(event)
//                     ? 'Attendance Marked'
//                     : 'Mark Attendance'),
//               );
//             }),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class AttendancePage extends StatelessWidget {
const AttendancePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Container();
  }
}