import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:get/get.dart';

class EditProfilePage extends StatelessWidget {
  final AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Palette.PRIMARY,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: GetBuilder<AuthController>(
          builder: (controller) {
            return FormBuilder(
              key: controller.formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => controller.showImagePickerOptions(),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipOval(
                          child: Container(
                            width: 90,
                            height: 90,
                            child: controller.selectedImage != null
                                ? Image.file(
                                    File(controller.selectedImage!.path),
                                    fit: BoxFit.cover,
                                  )
                                : OnlineImage(
                                    borderRadius: BorderRadius.circular(90),
                                    imageUrl: controller.user.value.image ?? '',
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Palette.PRIMARY,
                              shape: BoxShape.circle,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                    'First Name',
                    'first_name',
                    controller.user.value.firstName ?? '',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Last Name',
                    'last_name',
                    controller.user.value.lastName ?? '',
                  ),
                  const SizedBox(height: 16),
                  GetBuilder<AuthController>(
                    builder: (controller) {
                      if (controller.uploadProgress.value > 0 &&
                          controller.uploadProgress.value < 1) {
                        return LinearProgressIndicator(
                          value: controller.uploadProgress.value,
                          color: Palette.PRIMARY,
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Palette.PRIMARY,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => controller.updateProfile(),
            child: const Text(
              'Save Changes',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String name, String initialValue) {
    return FormBuilderTextField(
      name: name,
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Palette.LIGHT_BACKGROUND,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
    );
  }
}
