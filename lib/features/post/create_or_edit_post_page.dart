// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:sliver_tools/sliver_tools.dart';

import 'package:geolocation/core/globalwidget/file_preview.dart';
import 'package:geolocation/core/globalwidget/preview_file_card.dart';
import 'package:geolocation/core/globalwidget/progress_bar_submit.dart';
import 'package:geolocation/core/globalwidget/to_sliver.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/file/model/media_file.dart';
import 'package:geolocation/features/post/controller/post_controller.dart';
import 'package:geolocation/features/post/model/post.dart';

class CreateOrEditPostPage extends StatelessWidget {
 final bool? isEditMode;
  final Post? post;
  const CreateOrEditPostPage({
    Key? key,
    this.isEditMode,
    this.post,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var taskController = Get.find<PostController>();

    // Initialize form values only once if in edit mode
    if (isEditMode == true && post != null) {
      taskController.initializeFormForEdit(post!);
    }



    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(isEditMode == true ? 'Edit Post' : 'Create Post'),
        actions: [
          GetBuilder<PostController>(
            builder: (controller) {
              return TextButton(
                onPressed: () {
                  isEditMode == true
                      ? controller.updatePost(post?.id as int)
                      : controller.createPost();
                },
                child: Text(
                  isEditMode == true ? 'Update' : 'Post',
                  style: TextStyle(color: Palette.PRIMARY),
                ),
              );
            },
          ),
        ],
      ),
      body: CustomScrollView(slivers: [
        ToSliver(
          child: GetBuilder<PostController>(
  builder: (postcontroller) {
            return FormBuilder(
              key: postcontroller.formKey,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      if (postcontroller.isLoading.value) {
                        return Container(
                            margin: EdgeInsets.only(bottom: 12),
                            child: postcontroller.mediaFiles.isNotEmpty
                                ? ProgressBarSubmit(
                                    progress:
                                        postcontroller.uploadProgress.value)
                                : LinearProgressIndicator());
                      } else {
                        return SizedBox(
                            height: 8); // Placeholder when not loading
                      }
                    }),
                    // Title Field
                    Text(
                      'Title',
                      style: Get.textTheme.bodyMedium
                          ?.copyWith(color: Palette.LIGHT_TEXT),
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
                      style: Get.textTheme.bodyMedium
                          ?.copyWith(color: Palette.LIGHT_TEXT),
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
                      style: Get.textTheme.bodyMedium
                          ?.copyWith(color: Palette.LIGHT_TEXT),
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

                    Tooltip(
                      message:
                          'Enable this to publish the collection immediately.',
                      child: FormBuilderSwitch(
                        name: 'is_publish',
                        title: const Text('Publish Collection'),
                        initialValue: true, // Default to true
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                      ),
                    ),

                    //  SwitchListTile(
                    //   tileColor: Colors.white,
                    //   inactiveThumbColor: Palette.grayTextV2,
                    //   inactiveTrackColor: Palette.LIGHT_BACKGROUND,
                    //   activeColor: Colors.white,
                    //   activeTrackColor: Palette.PRIMARY,
                    //   title: Text(
                    //     'Publish Post',
                    //     style: Get.textTheme.bodyMedium,
                    //   ),
                    //   value: controller.isPublish.value,
                    //   onChanged: (value) {
                    //     controller.isPublish(value);
                    //     controller.update();
                    //   },
                    // ),

                    const Gap(16),

                    // Media Files Section
                    Text(
                      'Media Files',
                      style: Get.textTheme.bodyMedium
                          ?.copyWith(color: Palette.LIGHT_TEXT),
                    ),
                    const Gap(8),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                              child: Center(
                                child: Icon(Icons.add,
                                    size: 40, color: Palette.PRIMARY),
                              ),
                            ),
                          );
                        } else {
                          // Display media files
                          File file = postcontroller.mediaFiles[index - 1];
                          return GestureDetector(
                            onTap: () {
                              postcontroller.viewFile(file);
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
                                    onTap: () => postcontroller
                                        .removeFileLocal(index - 1),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.black.withOpacity(0.7),
                                            Colors.black.withOpacity(0.4),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
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
                ),
              ),
            );
          }),
        ),
        SliverGap(16),

        SliverPadding(
  padding: EdgeInsets.all(16.0),
  sliver: MultiSliver(
    children: [
      ToSliver(
        child: Text(
          'Files',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      SliverGap(16),
      GetBuilder<PostController>(builder: (postcontroller) {
        final mediaFiles = postcontroller.selectedItem.value.media ?? [];
        if (mediaFiles.isEmpty) {
          return ToSliver(
            child: Center(
              child: Text(
                "No files available.",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          );
        }

        return SliverAlignedGrid.count(
          itemCount: mediaFiles.length,
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          itemBuilder: (context, index) {
            final file = mediaFiles[index];
            return Stack(
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onTap: () {
                    postcontroller.fullScreenDisplayOnline(
                      mediaFiles,
                      file,
                    );
                  },
                  child: MediaFileCard(file: file),
                ),
                Positioned(
                  top: -12, // Adjust the position as needed
                  right: -12, // Adjust to make it more visible and larger
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {

                        postcontroller.confirmDeleteMedia(index);
                    },
                    child: Container(
                      height: 28, // Increased size for better visibility
                      width: 28, // Increased size for better visibility
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.black.withOpacity(0.5),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20, // Increased icon size for better visibility
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }),
    ],
  ),
)

      ]),
    );
  }
}
