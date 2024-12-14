
import 'package:geolocation/features/event/controller/event_controller.dart';

import 'package:get/get.dart';

class OfficerController extends GetxController  {
  static  OfficerController controller = Get.find();




  

  // all page
  Future<void> loadAllPageData()  async {
 
     await Future.wait([
        // PostController.controller.loadData(),
        EventController.controller.loadEvents(),
        // CollectionController.controller.loadData(),
        // TaskController.controller.loadTask(),
      ]);
  } 

}