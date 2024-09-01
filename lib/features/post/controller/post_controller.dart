import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PostController  extends GetxController{

    final formKey = GlobalKey<FormBuilderState>();
  final ImagePicker picker = ImagePicker();
  XFile? image;


static PostController controller = Get.find();

void createPost() async {
   
                  if (formKey.currentState?.saveAndValidate() ?? false) {
                    final postData = formKey.currentState?.value;
                    print('Post Data: $postData');

                    Get.back(); 
                    update();
                  }
}

void pickImage() async {
   controller.image = await controller.picker.pickImage(source: ImageSource.gallery);
                      if (controller.image != null) {
                        print('Selected image: ${controller.image?.path}');
                                        update();
                                        Modal.showToast(msg: 'Image Selected');

                      }
}

}