

import 'package:geolocation/features/attendance/controller/attendance_controller.dart';
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

class AppBinding  extends Bindings{
  @override
  void dependencies() {

    // Get.put(LoginController(), permanent: true);
    // Get.put(SignupController(), permanent: true);
    Get.put(ProfileController(), permanent: true);
    Get.put(NotificationController(), permanent: true);
    Get.put(EventController(), permanent: true);
    Get.put(MemberController(), permanent: true);
    Get.put(TaskController(), permanent: true);
    Get.put(PostController(), permanent: true);
    Get.put(CollectionController(), permanent: true);
    Get.put(FilesController(), permanent: true);
    Get.put(AttendanceController(), permanent: true);
    Get.put(SampleMapController(), permanent: true);
  }

}