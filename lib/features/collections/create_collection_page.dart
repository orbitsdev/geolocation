import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/collections/controller/collection_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gap/gap.dart';


class CreateCollectionPage extends StatelessWidget  {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create Collection'),
        actions: [
          GetBuilder<CollectionController>(
            builder: (controller) {
              return TextButton(
                onPressed: () { 
                    controller.createCollection();
                },
                child: Text(
                  'Save',
                  style: TextStyle(color: Palette.PRIMARY),
                ),
              );
            }
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: GetBuilder<CollectionController>(
          builder: (controller) {
            return FormBuilder(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Collection Title Field
                  Text(
                    'Collection Title',
                    style: Get.textTheme.bodyMedium
                        ?.copyWith(color: Palette.LIGHT_TEXT),
                  ),
                  Gap(8),
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
                      hintText: 'Enter collection title',
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  Gap(16),
            
                  // Chart Type Dropdown
                  Text(
                    'Select Chart Type',
                    style: Get.textTheme.bodyMedium
                        ?.copyWith(color: Palette.LIGHT_TEXT),
                  ),
                  Gap(8),
                  FormBuilderDropdown<String>(
                    name: 'chart_type',
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
                    items: controller.chartTypes
                        .map((chartType) => DropdownMenuItem(
                              value: chartType,
                              child: Text(chartType),
                            ))
                        .toList(),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  Gap(16),
            
                  // Collection Items Section
                  Text(
                    'Collection Items',
                    style: Get.textTheme.bodyMedium
                        ?.copyWith(color: Palette.LIGHT_TEXT),
                  ),
                  Gap(8),
                  _buildCollectionItemField('Item 1', 'Enter item label', 'Enter value'),
                  Gap(8),
                  _buildCollectionItemField('Item 2', 'Enter item label', 'Enter value'),
                  Gap(8),
                  _buildCollectionItemField('Item 3', 'Enter item label', 'Enter value'),
                  // You can add more fields or use a ListView.builder to dynamically add items
                  Gap(16),
            
                  // Optional Description Field
                  Text(
                    'Optional Description',
                    style: Get.textTheme.bodyMedium
                        ?.copyWith(color: Palette.LIGHT_TEXT),
                  ),
                  Gap(8),
                  FormBuilderTextField(
                    name: 'description',
                    maxLines: 3,
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
                      hintText: 'Add any additional information...',
                    ),
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }

  Widget _buildCollectionItemField(String itemTitle, String labelHint, String valueHint) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: FormBuilderTextField(
            name: '$itemTitle',
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
              hintText: labelHint,
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
          ),
        ),
        Gap(8),
        Expanded(
          child: FormBuilderTextField(
            name: '$itemTitle',
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
              hintText: valueHint,
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
            ]),
          ),
        ),
      ],
    );
  }
}
