import 'package:get/get.dart';

class AuthController extends GetxController {
  
  static AuthController controller = Get.find();

   var isAuthenticated = false.obs; 
   var isNew = true.obs; 

  void login() {
    isAuthenticated.value = true;  // Simulate successful login
  }

  void logout() {
    isAuthenticated.value = false;  // Simulate logout
  }

}