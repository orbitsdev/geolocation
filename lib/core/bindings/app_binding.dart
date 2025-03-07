

import 'package:geolocation/core/globalcontroller/device_controller.dart';
import 'package:geolocation/features/attendance/controller/attendance_controller.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/collections/controller/collection_controller.dart';
import 'package:geolocation/features/event/controller/event_controller.dart';
import 'package:geolocation/features/file/controller/files_controller.dart';
import 'package:geolocation/features/files/controller/media_controller.dart';
import 'package:geolocation/features/map/controller/sample_map_controller.dart';
import 'package:geolocation/features/council_positions/controller/council_position_controller.dart';
import 'package:geolocation/features/notification/controller/notification_controller.dart';
import 'package:geolocation/features/officers/controller/officer_controller.dart';
import 'package:geolocation/features/post/controller/post_controller.dart';
import 'package:geolocation/features/profile/controller/profile_controller.dart';
import 'package:geolocation/features/reports/report_controller.dart';

import 'package:geolocation/features/task/controller/search_officer_controller.dart';
import 'package:geolocation/features/task/controller/task_controller.dart';
import 'package:get/get.dart';

class AppBinding  extends Bindings{
  @override
  void dependencies() {

    // Get.put(LoginController(), permanent: true);
    // Get.put(SignupController(), permanent: true);
    Get.put(AuthController(), permanent: true);
    Get.put(DeviceController(), permanent: true);
    Get.put(ProfileController(), permanent: true);
    Get.put(NotificationController(), permanent: true);
    Get.put(EventController(), permanent: true);
    Get.put(CouncilPositionController(), permanent: true);
    Get.put(TaskController(), permanent: true);
    Get.put(PostController(), permanent: true);
    Get.put(CollectionController(), permanent: true);
    Get.put(FilesController(), permanent: true);
    Get.put(AttendanceController(), permanent: true);
    Get.put(SampleMapController(), permanent: true);
    Get.put(SearchOfficerController(), permanent: true);
    Get.put(OfficerController(), permanent: true);
    Get.put(MediaController(), permanent: true);
    Get.put(ReportController(), permanent: true);

  }

}