import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/collections/controller/collection_controller.dart';
import 'package:geolocation/features/collections/model/collection.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gap/gap.dart';
import 'package:flutter/services.dart';

class CreateOrEditCollectionPage extends StatelessWidget {
  final bool isEditMode;

  CreateOrEditCollectionPage({this.isEditMode = false});

  @override
  Widget build(BuildContext context) {

final CollectionController controller = Get.find<CollectionController>();
     // Call fillForm outside the builder if in edit mode
    // Call fillForm or clearForm based on the mode
    if (isEditMode) {
      final Collection? selectedCollection = Get.arguments;
      if (selectedCollection != null) {
        controller.setSelectedItemAndFilForm(selectedCollection);
    }
    } else {
      controller.clearForm(); // Clear form for new collections
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: Text(isEditMode ? 'Edit Collection' : 'Create Collection'),
        actions: [
          GetBuilder<CollectionController>(
            builder: (controller) {
              return TextButton(
                onPressed: () {
                  isEditMode ? controller.updateCollection() : controller.createCollection();
                },
                child: Text(
                  'Save',
                  style: TextStyle(color: Palette.PRIMARY),
                ),
              );
            },
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
                    style: Get.textTheme.bodyMedium?.copyWith(color: Palette.LIGHT_TEXT),
                  ),
                  Gap(8),
                  FormBuilderTextField(
                    name: 'title',
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Palette.LIGHT_BACKGROUND,
                      hintText: 'Enter collection title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.maxLength(100),
                    ]),
                  ),
                  Gap(16),

                  // Chart Type Dropdown
                  Text(
                    'Select Chart Type',
                    style: Get.textTheme.bodyMedium?.copyWith(color: Palette.LIGHT_TEXT),
                  ),
                  Gap(8),
                  FormBuilderDropdown<String>(
  name: 'chart_type',
  initialValue: controller.chartOptions.isNotEmpty ? controller.chartOptions[0] : null, // Default to the first option if available
  decoration: InputDecoration(
    filled: true,
    fillColor: Palette.LIGHT_BACKGROUND,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  ),
  items: controller.chartOptions
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Collection Items',
                        style: Get.textTheme.bodyMedium?.copyWith(color: Palette.LIGHT_TEXT),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle, color: Palette.PRIMARY),
                        onPressed: controller.addItem,
                      ),
                    ],
                  ),
                  Gap(8),
                 ...controller.collectionItems.isNotEmpty
    ? List.generate(
        controller.collectionItems.length,
        (index) => Column(
          children: [
            _buildCollectionItemField(controller, index),
            if (index < controller.collectionItems.length - 1) Gap(8),
          ],
        ),
      )
    : [Text('No collection items added yet.')],


                  Gap(16),

                  // Optional Description Field
                  Text(
                    'Optional Description',
                    style: Get.textTheme.bodyMedium?.copyWith(color: Palette.LIGHT_TEXT),
                  ),
                  Gap(8),
                  FormBuilderTextField(
                    name: 'description',
                    maxLines: 3,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Palette.LIGHT_BACKGROUND,
                      hintText: 'Add any additional information...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
  Gap(16),
            Column(
  mainAxisAlignment: MainAxisAlignment.start,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'Publish Collection',
      style: Get.textTheme.bodyMedium?.copyWith(color: Palette.LIGHT_TEXT),
    ),
   
    Tooltip(
      message: 'Enable this to publish the collection immediately.',
      child: FormBuilderSwitch(
        name: 'is_publish',
        title: const Text('Publish Collection'),
        initialValue: true, // Default to true
        decoration: const InputDecoration(border: InputBorder.none),
      ),
    ),
  ],
),

                  
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCollectionItemField(CollectionController controller, int index) {
  final item = controller.collectionItems[index];

  return Row(
    children: [
      Expanded(
        flex: 3,
        child: FormBuilderTextField(
          name: 'items[$index][label]',
          initialValue: item.label,
          decoration: InputDecoration(
            filled: true,
            fillColor: Palette.LIGHT_BACKGROUND,
            hintText: 'Enter item label',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (value) {
            if(controller.collectionItems.isNotEmpty){
              controller.collectionItems[index].label = value ?? '';

            }
          },
          validator: FormBuilderValidators.required(),
        ),
      ),
      Gap(8),
      Expanded(
        flex: 2,
        child: FormBuilderTextField(
          name: 'items[$index][amount]',
          initialValue: item.amount?.toStringAsFixed(0),
          decoration: InputDecoration(
            filled: true,
            fillColor: Palette.LIGHT_BACKGROUND,
            hintText: '0.00',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
          ],
          onChanged: (value) {
            if(controller.collectionItems.isNotEmpty){
            controller.collectionItems[index].amount = double.tryParse(value ?? '0') ?? 0.0;

            }
          },
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.numeric(),
          ]),
        ),
      ),
      IconButton(
        icon: Icon(Icons.remove_circle, color: Colors.red),
        onPressed: () => controller.removeItem(index),
      ),
    ],
  );
}

}
