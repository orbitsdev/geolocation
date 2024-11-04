import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:geolocation/core/constant/style.dart';
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

    // Fetch positions when the page is opened if not already done
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.positionOptions.isEmpty) {
        controller.fetchAvailablePositions();
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          isEditMode ? 'Edit Member' : 'Add New Member',
          style: Get.textTheme.titleMedium?.copyWith(color: Palette.PRIMARY),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: FormBuilder(
          key: controller.councilPositionFormKey,
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
                      controller.chosenUser.value = selectedUser;
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Palette.LIGHT_BACKGROUND,
                      border: Border.all(width: 0.5, color: Palette.PRIMARY),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        controller.chosenUser.value != null
                            ? ClipOval(
                                child: Image.network(
                                  controller.chosenUser.value!.image ?? '',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors.grey,
                                      child: Icon(Icons.person, color: Colors.white),
                                    );
                                  },
                                ),
                              )
                            : const CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.grey,
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
                                      style: Get.textTheme.bodyMedium,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : Text(
                                      'Select User',
                                      style: Get.textTheme.bodyMedium?.copyWith(
                                        color: Colors.grey,
                                      ),
                                    ),
                              const SizedBox(height: 4),
                              controller.chosenUser.value != null
                                  ? Text(
                                      controller.chosenUser.value!.email ?? '',
                                      style: Get.textTheme.bodySmall?.copyWith(
                                        color: Colors.grey,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  ),
                );
              }),
              const Gap(16),

              // Dropdown for position
              Obx(() {
                if (controller.isFetchingAvailablePositions.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.positionOptions.isEmpty) {
                  return const Center(child: Text('No available positions found.'));
                }
                return FormBuilderDropdown<String>(
                  dropdownColor: Colors.white,
                  style: Get.textTheme.bodyMedium?.copyWith(),
                  name: 'position',
                  initialValue: position?.position ?? '',
                  decoration: InputDecoration(
                    labelText: 'Select Position',
                    filled: true,
                    fillColor: Palette.LIGHT_BACKGROUND,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 0.1, color: Palette.PRIMARY),
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
                  onChanged: (value) {
                    print('Selected position: $value');
                  },
                );
              }),
              const Gap(16),

              // Switch for Grant Access
              Obx(() {
                return FormBuilderSwitch(
                  name: 'grant_access',
                  title:  Text('Grant Access'),
                  initialValue: controller.grantAccess.value, // Bind initial value to controller
                  onChanged: (val) {
                    controller.grantAccess.value = val ?? false; // Update controller when switched
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Palette.LIGHT_BACKGROUND,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 0.1, color: Palette.PRIMARY),
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
                  backgroundColor: Palette.PRIMARY,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: controller.isCreatingOrUpdating.value
                    ? null // Disable button while loading
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

