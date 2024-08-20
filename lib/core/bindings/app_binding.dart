

import 'package:geolocation/features/signin/controllers/login_controller.dart';
import 'package:geolocation/features/signup/controllers/signup_controller.dart';
import 'package:get/get.dart';

class AppBinding  extends Bindings{
  @override
  void dependencies() {

    Get.put(LoginController(), permanent: true);
    Get.put(SignupController(), permanent: true);
  }

}