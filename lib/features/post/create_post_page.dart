import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/post/controller/post_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostPage extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          GetBuilder<PostController>(
            builder: (controller) {
              return TextButton(
                onPressed: () {
                
                },
                child: Text(
                  'Post',
                  style: TextStyle(color: Palette.PRIMARY),
                ),
              );
            }
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child:   GetBuilder<PostController>(
            builder: (controller) {
            return FormBuilder(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Post Content Field
                  Text(
                    'What\'s on your mind?',
                    style: Get.textTheme.bodyMedium
                        ?.copyWith(color: Palette.LIGHT_TEXT),
                  ),
                  Gap(8),
                  FormBuilderTextField(
                    name: 'content',
                    maxLines: 5,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Palette.LIGHT_BACKGROUND,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 0.5, color: Palette.PRIMARY),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 1.0, color: Colors.transparent),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 1.0, color: Colors.transparent),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1.0, color: Colors.red),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Share your thoughts...',
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  Gap(16),
            
                  // Image Picker Button
                  Text(
                    'Add an Image',
                    style: Get.textTheme.bodyMedium
                        ?.copyWith(color: Palette.LIGHT_TEXT),
                  ),
                  Gap(8),
                  GestureDetector(
                    onTap: () async {
                        controller.pickImage();
                    },
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Palette.LIGHT_BACKGROUND,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Palette.PRIMARY,
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.add_a_photo, color: Palette.PRIMARY),
                          Gap(16),
                          Text(
                            controller.image == null
                                ? 'Tap to select an image'
                                : 'Image selected',
                            style: TextStyle(color: Palette.PRIMARY),
                          ),
                        ],
                      ),
                    ),
                  ),
            
                  // Preview selected image
                  if (controller.image != null) ...[
                    Gap(16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(controller.image!.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}
