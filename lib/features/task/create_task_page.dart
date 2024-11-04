import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/council_positions/data/sample_data.dart';
import 'package:geolocation/features/task/controller/task_controller.dart';
import 'package:geolocation/features/task/officer_selection_page.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class CreateTaskPage extends StatelessWidget {
  const CreateTaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create Task'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: 60.0,
        ),
        child: GetBuilder<TaskController>(builder: (controller) {
          return FormBuilder(
            key: controller.formKey,
            child: Container(
              padding: EdgeInsets.only(
                left: 22,
                right: 32,
                top: 34,
                bottom: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Task Title
                  Text(
                    'Task Title',
                    style: Get.textTheme.bodyMedium
                        ?.copyWith(),
                  ),
                  Gap(2),
                  FormBuilderTextField(
                    name: 'title',
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
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  Gap(16),

                  // Officer Dropdown
                  Text(
                    'Assign to Officer',
                    style: Get.textTheme.bodyMedium
                        ?.copyWith(),
                  ),
                  Gap(2),

                  RippleContainer(
                    onTap: ()=> Get.to(()=> OfficerSelectionPage()),
                    child: Container(
                           decoration: BoxDecoration(
                             color: controller.selectedOfficer.value.id != null  ? Colors.green.shade50 : Colors.grey.shade50, // Light background color
                             borderRadius: BorderRadius.circular(8),
                             border: Border.all(color: controller.selectedOfficer.value.id != null  ? Colors.green : Palette.LIGHT_TEXT), // Border for better visibility
                           ),
                           padding: EdgeInsets.all(8),
                           child: Row(
                             crossAxisAlignment: CrossAxisAlignment.center,
                             children: [
                               CircleAvatar(
                                 radius: 20,
                                 backgroundColor: Colors.grey,
                                 child: Icon(
                                   controller.selectedOfficer.value.id != null  ? Icons.check : Icons.account_circle_rounded,
                                   color: Colors.white,
                                 ),
                               ),
                               SizedBox(width: 16),
                               Flexible(
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Text(
                     'Select Officer',
                     style: TextStyle(
                     ),
                                     ),
                                     SizedBox(height: 4),
                                    if(controller.selectedOfficer.value.id != null) Column(
                     children: [
                       Text(
                         '${controller.selectedOfficer.value.fullName} ' ,
                         style: TextStyle(color: Colors.grey),
                       ),
                       Text(
                         '${controller.selectedOfficer.value.email}',
                         style: TextStyle(color: Colors.grey),
                       ),
                       Text(
                         '${controller.selectedOfficer.value.position}',
                         style: TextStyle(color: Colors.grey),
                       ),
                     ],
                                     ),
                                   ],
                                 ),
                               ),
                               SizedBox(width: 8),
                              //  Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16), // Arrow to indicate it's clickable
                             ],
                           ),
                         ),
                  ),
                  // FormBuilderDropdown<String>(
                  //   dropdownColor: Colors.white,
                  //   style: Get.textTheme.bodyMedium!.copyWith(),
                  //   name: 'officer',
                  //   decoration: InputDecoration(
                  //     filled: true,
                  //     fillColor: Palette.LIGHT_BACKGROUND,
                  //     contentPadding: const EdgeInsets.symmetric(
                  //         vertical: 10, horizontal: 10),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderSide: BorderSide(
                  //           width: 0.5, color: Palette.PRIMARY),
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //     border: OutlineInputBorder(
                  //       borderSide: const BorderSide(
                  //           width: 1.0, color: Colors.transparent),
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //     enabledBorder: OutlineInputBorder(
                  //       borderSide: const BorderSide(
                  //           width: 1.0, color: Colors.transparent),
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //     errorBorder: OutlineInputBorder(
                  //       borderSide:
                  //           const BorderSide(width: 1.0, color: Colors.red),
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //   ),
                  //   validator: FormBuilderValidators.compose([
                  //     FormBuilderValidators.required(),
                  //   ]),
                  //   items: samplePositions
                  //       .map((position) => DropdownMenuItem(
                  //             value: position.name,
                  //             child: Text(position.name),
                  //           ))
                  //       .toList(),
                  //   onChanged: (value) {
                  //     print('Selected officer: $value');
                  //   },
                  // ),
                  Gap(16),

                  // Task Description
                  Text(
                    'Task Description',
                    style: Get.textTheme.bodyMedium
                        ?.copyWith(),
                  ),
                  Gap(2),
                  FormBuilderTextField(
                    name: 'description',
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
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  Gap(16),

                  // Due Date
                  Text(
                    'Due Date',
                    style: Get.textTheme.bodyMedium
                        ?.copyWith(),
                  ),
                  Gap(2),
                  FormBuilderDateTimePicker(
                    name: 'due_date',
                    inputType: InputType.date,
                    format: DateFormat('yyyy-MM-dd'),
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
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
      bottomSheet: GetBuilder<TaskController>(
        builder: (controller) {
          return Container(
            height: Get.size.height * 0.11,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Color(0x000000).withOpacity(0.03),
                offset: Offset(0, -4),
                blurRadius: 3,
                spreadRadius: 0,
              )
            ]),
            child: Container(
              width: Get.size.width,
              constraints: const BoxConstraints(minWidth: 150),
              height: Get.size.height,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.PRIMARY,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  controller.createTask();
                },
                child: Text(
                  'Save Task',
                  style: Get.textTheme.bodyLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
