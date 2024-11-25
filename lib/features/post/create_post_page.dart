import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/post/controller/post_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gap/gap.dart';

class CreatePostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PostController controller = PostController.controller;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          GetBuilder<PostController>(
            builder: (controller) {
              return TextButton(
                onPressed: () => controller.createPost(),
                child: Text(
                  'Post',
                  style: TextStyle(color: Palette.PRIMARY),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: GetBuilder<PostController>(
          builder: (controller) {
            return FormBuilder(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Field
                  Text(
                    'Title',
                    style: Get.textTheme.bodyMedium?.copyWith(color: Palette.LIGHT_TEXT),
                  ),
                  const Gap(8),
                  FormBuilderTextField(
                    name: 'title',
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Palette.LIGHT_BACKGROUND,
                      hintText: 'Enter title...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.maxLength(255),
                    ]),
                  ),
                  const Gap(16),

                  // Content Field
                  Text(
                    'Content',
                    style: Get.textTheme.bodyMedium?.copyWith(color: Palette.LIGHT_TEXT),
                  ),
                  const Gap(8),
                  FormBuilderTextField(
                    name: 'content',
                    maxLines: 5,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Palette.LIGHT_BACKGROUND,
                      hintText: 'Share your thoughts...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const Gap(16),

                  // Description Field
                  Text(
                    'Description (Optional)',
                    style: Get.textTheme.bodyMedium?.copyWith(color: Palette.LIGHT_TEXT),
                  ),
                  const Gap(8),
                  FormBuilderTextField(
                    name: 'description',
                    maxLines: 3,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Palette.LIGHT_BACKGROUND,
                      hintText: 'Add an optional description...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const Gap(16),

                  // Publish Toggle
                  Text(
                    'Publish',
                    style: Get.textTheme.bodyMedium?.copyWith(color: Palette.LIGHT_TEXT),
                  ),
                  const Gap(8),
                  FormBuilderSwitch(
                    name: 'is_publish',
                    initialValue: true,
                    title: const Text('Publish this post'),
                  ),
                  const Gap(16),

                  // Media Files Section
                  Text(
                    'Media Files',
                    style: Get.textTheme.bodyMedium?.copyWith(color: Palette.LIGHT_TEXT),
                  ),
                  const Gap(8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: controller.mediaFiles.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // Add button
                        return GestureDetector(
                          onTap: () => controller.pickFile(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Palette.LIGHT_BACKGROUND,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Palette.PRIMARY,
                                width: 0.5,
                              ),
                            ),
                            child:  Center(
                              child: Icon(Icons.add, size: 40, color: Palette.PRIMARY),
                            ),
                          ),
                        );
                      } else {
                        // Display media files
                        File file = controller.mediaFiles[index - 1];
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            GestureDetector(
                              onTap: () => controller.viewFile(file),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: file.path.endsWith('.mp4')
                                    ? const Icon(Icons.play_circle, size: 40)
                                    : Image.file(file, fit: BoxFit.cover),
                              ),
                            ),
                            Positioned(
                              top: -10,
                              right: -10,
                              child: GestureDetector(
                                onTap: () => controller.removeFileLocal(index - 1),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: const Icon(Icons.close, color: Colors.white, size: 16),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
