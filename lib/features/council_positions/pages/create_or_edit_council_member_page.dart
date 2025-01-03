import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/council_positions/controller/council_position_controller.dart';
import 'package:geolocation/features/auth/model/council_position.dart';
import 'package:geolocation/features/council_positions/pages/available_user_selection.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CreateOrEditCouncilMemberPage extends StatelessWidget {
  final CouncilPosition? position; // Null for creating, non-null for editing
  final bool isEditMode;

  CreateOrEditCouncilMemberPage({Key? key, this.position})
      : isEditMode = position != null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final CouncilPositionController controller = Get.find<CouncilPositionController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.positionOptions.isEmpty) {
        controller.fetchAvailablePositions();
      }
    });

    return Scaffold(
      backgroundColor: Colors.white, // Pure white background
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white, // Pure white AppBar background
        title: Text(
          isEditMode ? 'Edit Member' : 'Add New Member',
          style: Get.textTheme.titleMedium?.copyWith(color: Palette.text),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: FormBuilder(
          key: controller.councilPositionFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                return GestureDetector(
                  onTap: () async {
                    final selectedUser =
                        await Get.to(() => AvailableUserSelectionPage());
                    if (selectedUser != null) {
                      controller.chosenUser.value = selectedUser;
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white, // Pure white background for selection
                      border: Border.all(width: 0.5, color: Palette.deYork600),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        controller.chosenUser.value != null
                            ?
                            Container(
                               width: 40,
                                  height: 40,
                                  child: OnlineImage(imageUrl:  controller.chosenUser.value!.image ?? '',borderRadius: BorderRadius.circular(25),),
                            )
                            //  ClipOval(
                            //     child: Image.network(
                            //       controller.chosenUser.value!.image ?? '',
                            //       width: 40,
                            //       height: 40,
                            //       fit: BoxFit.cover,
                            //       errorBuilder: (context, error, stackTrace) {
                            //         return CircleAvatar(
                            //           radius: 25,
                            //           backgroundColor: Palette.lightText,
                            //           child: Icon(Icons.person, color: Colors.white),
                            //         );
                            //       },
                            //     ),
                            //   )
                            : CircleAvatar(
                                radius: 25,
                                backgroundColor: Palette.lightText,
                                child: Icon(Icons.person, color: Colors.white),
                              ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              controller.chosenUser.value != null
                                  ? Text(
                                      '${controller.chosenUser.value!.firstName} ${controller.chosenUser.value!.lastName}',
                                      style: Get.textTheme.bodyMedium?.copyWith(
                                        color: Palette.text,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : Text(
                                      'Select User',
                                      style: Get.textTheme.bodyMedium?.copyWith(
                                        color: Palette.lightText,
                                      ),
                                    ),
                              const SizedBox(height: 4),
                              controller.chosenUser.value != null
                                  ? Text(
                                      controller.chosenUser.value!.email ?? '',
                                      style: Get.textTheme.bodySmall?.copyWith(
                                        color: Palette.lightText,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_ios, size: 16, color: Palette.gray600,),
                      ],
                    ),
                  ),
                );
              }),
              const Gap(16),
              Obx(() {
                if (controller.isFetchingAvailablePositions.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.positionOptions.isEmpty) {
                  return Center(
                    child: Text(
                      'No available positions found.',
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: Palette.lightText,
                      ),
                    ),
                  );
                }
                return FormBuilderDropdown<String>(
                  dropdownColor: Colors.white,
                  style: Get.textTheme.bodyMedium?.copyWith(color: Palette.text),
                  name: 'position',
                  initialValue: position?.position ?? '',
                  decoration: InputDecoration(
                    labelText: 'Select Position',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 0.5, color: Palette.text),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: FormBuilderValidators.required(),
                  items: controller.positionOptions.map((position) {
                    return DropdownMenuItem(
                      value: position.name,
                      child: Text(position.name!),
                    );
                  }).toList(),
                );
              }),
              const Gap(16),
              Obx(() {
                return FormBuilderSwitch(
                  name: 'grant_access',
                  title: Text(
                    'Grant Access',
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: Palette.text,
                    ),
                  ),
                  initialValue: controller.grantAccess.value,
                  onChanged: (val) {
                    controller.grantAccess.value = val ?? false;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 0.5, color: Palette.text),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      bottomSheet: Obx(() {
        return Container(
          height: MediaQuery.of(context).size.height * 0.14,
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Center(
            child: SizedBox(
              height: 55,
              width: Get.size.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.deYork600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: controller.isCreatingOrUpdating.value
                    ? null
                    : () {
                        if (isEditMode) {
                          controller.updateCouncilPosition(position!.id!);
                        } else {
                          controller.createCouncilPosition();
                        }
                      },
                child: controller.isCreatingOrUpdating.value
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text(
                        isEditMode ? 'Update' : 'Save',
                        style: const TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
