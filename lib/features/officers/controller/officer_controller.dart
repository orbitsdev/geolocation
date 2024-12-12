import 'package:geolocation/features/collections/controller/collection_controller.dart';
import 'package:geolocation/features/event/controller/event_controller.dart';
import 'package:geolocation/features/post/controller/post_controller.dart';
import 'package:geolocation/features/task/controller/task_controller.dart';
import 'package:get/get.dart';

class OfficerController extends GetxController  {
  static  OfficerController controller = Get.find();


  // all page
  Future<void> loadAllPageData()  async {
    print('caleed');
     await Future.wait([
        PostController.controller.loadData(),
        EventController.controller.loadEvents(),
        // CollectionController.controller.loadData(),
        // TaskController.controller.loadTask(),
      ]);
  } 

}