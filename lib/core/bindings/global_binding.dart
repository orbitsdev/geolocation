

import 'package:geolocation/features/attendance/controller/attendance_controller.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/collections/controller/collection_controller.dart';
import 'package:geolocation/features/event/controller/event_controller.dart';
import 'package:geolocation/features/file/controller/files_controller.dart';
import 'package:geolocation/features/map/controller/sample_map_controller.dart';
import 'package:geolocation/features/members/controller/member_controller.dart';
import 'package:geolocation/features/notification/controller/notification_controller.dart';
import 'package:geolocation/features/post/controller/post_controller.dart';
import 'package:geolocation/features/profile/controller/profile_controller.dart';
import 'package:geolocation/features/auth/controller/login_controller.dart';
import 'package:geolocation/features/auth/controller/signup_controller.dart';
import 'package:geolocation/features/task/controller/task_controller.dart';
import 'package:get/get.dart';


class GlobalBinding extends Bindings {
  @override
  void dependencies() {
  Get.put<AuthController>(AuthController(), permanent: true);
    
    // Controllers that might only be used on specific pages
    Get.lazyPut(() => ProfileController(), fenix: true);
    Get.lazyPut(() => NotificationController(), fenix: true);
    Get.lazyPut(() => EventController(), fenix: true);
    Get.lazyPut(() => MemberController(), fenix: true);
    Get.lazyPut(() => TaskController(), fenix: true);
    Get.lazyPut(() => PostController(), fenix: true);
    Get.lazyPut(() => CollectionController(), fenix: true);
    Get.lazyPut(() => FilesController(), fenix: true);
    Get.lazyPut(() => AttendanceController(), fenix: true);
    Get.lazyPut(() => SampleMapController(), fenix: true);
  }
}
