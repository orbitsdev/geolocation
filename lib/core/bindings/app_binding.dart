

import 'package:geolocation/features/event/controller/event_controller.dart';
import 'package:geolocation/features/members/controller/member_controller.dart';
import 'package:geolocation/features/notification/controller/notification_controller.dart';
import 'package:geolocation/features/signin/controllers/login_controller.dart';
import 'package:geolocation/features/signup/controllers/signup_controller.dart';
import 'package:get/get.dart';

class AppBinding  extends Bindings{
  @override
  void dependencies() {

    Get.put(LoginController(), permanent: true);
    Get.put(SignupController(), permanent: true);
    Get.put(NotificationController(), permanent: true);
    Get.put(EventController(), permanent: true);
    Get.put(MemberController(), permanent: true);
  }

}