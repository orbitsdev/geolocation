import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:geolocation/core/constant/style.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/council_positions/controller/council_position_controller.dart';
import 'package:geolocation/features/auth/model/council_position.dart';
import 'package:geolocation/features/council_positions/pages/available_user_selection.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';

class CreateOrEditCouncilMemberPage extends StatelessWidget {
  final CouncilPosition? position; // If null, it's a create form
  final bool isEditMode;

  CreateOrEditCouncilMemberPage({Key? key, this.position})
      : isEditMode = position != null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final CouncilPositionController controller =
        Get.put(CouncilPositionController());

    // Fetch positions when the page is opened
    Future.delayed(Duration.zero, () {
      controller.fetchPositions();
    });

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(isEditMode ? 'Edit Member' : 'Add New Member'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 60.0),
          child: FormBuilder(
            key: controller.formKey,
            child: Container(
              padding: const EdgeInsets.only(
                  left: 22, right: 32, top: 34, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Button for selecting user
                  Obx(() {
                    return GestureDetector(
                      onTap: () async {
                        final selectedUser =
                            await Get.to(() => AvailableUserSelectionPage());
                        if (selectedUser != null) {
                          controller.selectedUser.value = selectedUser;
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Palette.LIGHT_BACKGROUND,
                          border:
                              Border.all(width: 0.5, color: Palette.PRIMARY),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            // Display user image or default avatar
                            controller.selectedUser.value != null
                                ? ClipOval(
                                    child: Image.network(
                                      controller.selectedUser.value!.image ??
                                          '',
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.grey,
                                          child: Icon(Icons.person,
                                              color: Colors.white),
                                        );
                                      },
                                    ),
                                  )
                                : const CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.grey,
                                    child:
                                        Icon(Icons.person, color: Colors.white),
                                  ),
                            const SizedBox(width: 16),

                            // Display user name and email
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  controller.selectedUser.value != null
                                      ? Text(
                                          '${controller.selectedUser.value!.firstName} ${controller.selectedUser.value!.lastName}',
                                          style: Get.textTheme.bodyMedium,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      : Text(
                                          'Select User',
                                          style: Get.textTheme.bodyMedium
                                              ?.copyWith(color: Colors.grey),
                                        ),
                                  const SizedBox(height: 4),
                                  controller.selectedUser.value != null
                                      ? Text(
                                          controller
                                                  .selectedUser.value!.email ??
                                              '',
                                          style: Get.textTheme.bodySmall
                                              ?.copyWith(color: Colors.grey),
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Forward arrow icon
                            const Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                      ),
                    );
                  }),
                  const Gap(16),

                  // Dropdown for position
                  Obx(() {
                    if (controller.isLoadingAvailablePositions.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (controller.availablePositions.isEmpty) {
                      return const Center(
                          child: Text('No available positions found.'));
                    }
                    return FormBuilderDropdown<String>(
                      dropdownColor: Colors.white,
                      style: Get.textTheme.bodyMedium!.copyWith(),
                      name: 'position',
                      initialValue: position?.position ?? '',
                      decoration: InputDecoration(
                        labelText: 'Select Position',
                        filled: true,
                        fillColor: Palette.LIGHT_BACKGROUND,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0.5, color: Palette.PRIMARY),
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
                      ),
                      validator: FormBuilderValidators.required(),
                      items: controller.availablePositions.map((position) {
                        return DropdownMenuItem(
                          value: position.name,
                          child: Text(position.name!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        print('Selected position: $value');
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
       bottomSheet: Obx(() {
  return Container(
    height: MediaQuery.of(context).size.height * 0.14,
    padding: EdgeInsets.all(16),
    color: Colors.white,
    child: Center(
      child: SizedBox(
        height: 55,
        width: Get.size.width,
        child: ElevatedButton(
          style: ELEVATED_BUTTON_STYLE_DARK,
          onPressed: controller.createOrUpdateLoading.value
              ? null // Disable button while loading
              : () {
                  if (isEditMode) {
                    controller.updateCouncilPosition(position!.id!);
                  } else {
                    controller.createCouncilPosition();
                  }
                },
          child: controller.createOrUpdateLoading.value
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Text(
                  isEditMode ? 'Update' : 'Save',
                  style: TextStyle(color: Colors.white),
                ),
        ),
      ),
    ),
  );
}),

        );
  }
}
