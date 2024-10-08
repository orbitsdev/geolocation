import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:get/get.dart';


class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);  // Global dependency
  }
}
