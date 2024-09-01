import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/constant/style.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/members/controller/member_controller.dart';
import 'package:geolocation/features/members/data/sample_data.dart';
import 'package:get/get.dart';

class CreateMemberPage extends StatelessWidget {
  const CreateMemberPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add New Member'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: 60.0,
        ),
        child: GetBuilder<MemberController>(builder: (controller) {
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
                      Text(
                        'Fullname',
                        style: Get.textTheme.bodyMedium
                            ?.copyWith(color: Palette.LIGHT_TEXT),
                      ),
                      Gap(2),
                      FormBuilderTextField(
                        initialValue: 'Angelica Tirado',
                        style: Get.textTheme.bodyMedium!.copyWith(),
                        name: 'name',
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Palette.LIGHT_BACKGROUND,

                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal:
                                  10), // Adjust the vertical padding here
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
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          // FormBuilderValidators.email(),
                        ]),
                      ),
                      Gap(16),
                      FormBuilderDropdown<String>(
                        dropdownColor: Colors.white,
                          style: Get.textTheme.bodyMedium!.copyWith(),
                        name: 'position',
                       decoration: InputDecoration(
                          filled: true,
                          fillColor: Palette.LIGHT_BACKGROUND,

                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal:
                                  10), // Adjust the vertical padding here
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
                         validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          
                        ]),
                        items: samplePositions
                            .map((position) => DropdownMenuItem(
                                  value: position.name,
                                  child: Text(position.name),
                                ))
                            .toList(),
                        onChanged: (value) {
                          print('Selected position: $value');
                        },
                      ),
                    ]),
              ));
        }),
      ),
       bottomSheet: GetBuilder<MemberController>(
         builder: (controller) {
           return Container(
              height: Get.size.height * 0.11,
            padding: EdgeInsets.all(16),
             decoration:   BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
            color:  Color(0x000000).withOpacity(0.03),
            offset: Offset(0, -4),
            blurRadius: 3,
            spreadRadius: 0,
           )
             ]),
              
                 child:  Container(
                    width: Get.size.width,
                        constraints: const BoxConstraints(minWidth: 150),
                        height: Get.size.height,
                        child: ElevatedButton(
                            style:ELEVATED_BUTTON_STYLE,
                            onPressed: (){
                                controller.createMember();
                            },
                            child: Text(
                              'Save',
                              style: Get.textTheme.bodyLarge!.copyWith(
                                  color: Colors.white, fontWeight: FontWeight.normal),
                            )),
                      ),
               );
         }
       ),
    );
  }
}
