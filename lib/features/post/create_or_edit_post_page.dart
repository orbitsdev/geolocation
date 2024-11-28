import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:geolocation/core/globalwidget/file_preview.dart';
import 'package:geolocation/core/globalwidget/progress_bar_submit.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/post/controller/post_controller.dart';
import 'package:geolocation/features/post/model/post.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gap/gap.dart';

class CreateOrEditPostPage  extends StatelessWidget {
  final bool isEditMode;
  const CreateOrEditPostPage({Key? key, this.isEditMode = false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final PostController controller = PostController.controller;

   final arguments = Get.arguments;
    final isEditMode = arguments?['isEditMode'] ?? false;
    final post = arguments?['post'];
WidgetsBinding.instance.addPostFrameCallback((_) {
if (isEditMode == true && post != null) {
        
        controller.selectedItem.value = post;
        controller.fillForm();
        controller.update();

       
       
      } 
});
     

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:  Text(isEditMode ? 'Edit Post' : 'Create Post'),
        actions: [
          GetBuilder<PostController>(
            builder: (controller) {
              return TextButton(
                onPressed: () {
                   isEditMode ? controller.updatePost() : controller.createPost();
                },
                child: Text(
                  isEditMode ? 'Update' : 'Post',
                  style: TextStyle(color: Palette.PRIMARY),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding:  EdgeInsets.all(16.0),
    child:  FormBuilder(
              key: controller.formKey,
              child: GetBuilder<PostController>(
                builder: (postcontroller) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  
                       Obx(() {
                                          if (controller.isLoading.value) {
                                            return Container(
                                                  margin: EdgeInsets.only(bottom: 12),
                                                  child: controller
                                                          .mediaFiles.isNotEmpty
                                                      ? ProgressBarSubmit(
                                                          progress:
                                                              controller
                                                                  .uploadProgress.value)
                                                      : LinearProgressIndicator());
                                          } else {
                                            return  SizedBox(
                                                  height:
                                                      8); // Placeholder when not loading
                                          }
                                        }),
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
                     Tooltip(
                        message: 'Enable this to publish the post immediately.',
                        child: FormBuilderSwitch(
                          name: 'is_publish',
                          title: const Text('Publish Post'),
                          initialValue: true, // Default to true
                          decoration: const InputDecoration(border: InputBorder.none),
                        ),
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
                        itemCount: postcontroller.mediaFiles.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            // Add button
                            return GestureDetector(
                              onTap: () => postcontroller.pickFile(),
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
                            File file = postcontroller.mediaFiles[index - 1];
                            return GestureDetector(
                              onTap: () {
                                                                  postcontroller
                                                                      .viewFile(file);
                                                                },
                              child: Stack(
                                                                    clipBehavior: Clip.none,
                                                                    children: [
                                                                      FilePreviewWidget(filePath: file.path),
                                                                      // "X" button to remove the file
                                                                      Positioned(
                                                                        top: -10,
                                                                        right: -10,
                                                                        child: GestureDetector(
                                                                          behavior: HitTestBehavior
                                                                              .opaque, // Makes the entire area tappable
                                                                          onTap: () =>
                                                                              postcontroller.removeFileLocal(  index - 1), 
                                                                          child: Container(
                                                                            decoration: BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              gradient:
                                                                                  LinearGradient(
                                                                                colors: [
                                                                                  Colors.black
                                                                                      .withOpacity(
                                                                                          0.7),
                                                                                  Colors.black
                                                                                      .withOpacity(
                                                                                          0.4),
                                                                                ],
                                                                                begin:
                                                                                    Alignment.topLeft,
                                                                                end: Alignment
                                                                                    .bottomRight,
                                                                              ),
                                                                            ),
                                                                            padding: EdgeInsets.all(
                                                                                4), // Larger touch area
                                                                            child: Icon(
                                                                              Icons.close,
                                                                              color: Colors.white,
                                                                              size: 16,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                            );
                          }
                        },
                      ),
                    ],
                  );
                }
              ),
           
        ),
      ),
    );
  }
}
