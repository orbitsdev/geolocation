

import 'package:geolocation/core/globalcontroller/modal_controller.dart';
import 'package:geolocation/features/attendance/controller/attendance_controller.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/chat/chat_room_controller.dart';
import 'package:geolocation/features/collections/controller/collection_controller.dart';
import 'package:geolocation/features/councils/controller/council_controller.dart';
import 'package:geolocation/features/event/controller/event_controller.dart';
import 'package:geolocation/features/file/controller/files_controller.dart';
import 'package:geolocation/features/map/controller/sample_map_controller.dart';
import 'package:geolocation/features/council_positions/controller/council_position_controller.dart';
import 'package:geolocation/features/notification/controller/notification_controller.dart';
import 'package:geolocation/features/post/controller/post_controller.dart';
import 'package:geolocation/features/profile/controller/profile_controller.dart';
import 'package:geolocation/features/auth/controller/login_controller.dart';
import 'package:geolocation/features/auth/controller/signup_controller.dart';
import 'package:geolocation/features/reports/report_controller.dart';
import 'package:geolocation/features/task/controller/task_controller.dart';
import 'package:get/get.dart';


class GlobalBinding extends Bindings {
  @override
  void dependencies() {
  Get.put<AuthController>(AuthController(), permanent: true);
  Get.put<ModalController>(ModalController(), permanent: true);
  Get.put<CouncilController>(CouncilController(), permanent: true);
  Get.put<CouncilPositionController>(CouncilPositionController(), permanent: true);
  Get.put<TaskController>(TaskController(), permanent: true);
  Get.put<NotificationController>(NotificationController(), permanent: true);
  Get.put<ReportController>(ReportController(), permanent: true);
  Get.put<ChatRoomController>(ChatRoomController(), permanent: true);
    
    
    // Controllers that might only be used on specific pages
    // Get.lazyPut(() => CouncilController(), fenix: true);
    // Get.lazyPut(() => CouncilPositionController(), fenix: true);
    Get.lazyPut(() => ProfileController(), fenix: true);
    Get.lazyPut(() => EventController(), fenix: true);
    // Get.lazyPut(() => TaskController(), fenix: true);
    Get.lazyPut(() => PostController(), fenix: true);
    Get.lazyPut(() => CollectionController(), fenix: true);
    Get.lazyPut(() => FilesController(), fenix: true);
    Get.lazyPut(() => AttendanceController(), fenix: true);
    Get.lazyPut(() => SampleMapController(), fenix: true);
    // Get.lazyPut(() => SampleMapController(), fenix: true);
  }
}
