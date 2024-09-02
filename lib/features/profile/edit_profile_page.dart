import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:geolocation/core/constant/style.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/profile/controller/profile_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatelessWidget {
  final ProfileController controller = Get.find<ProfileController>();
  final ImagePicker _picker = ImagePicker();

  final _formKey = GlobalKey<FormBuilderState>();

  Future<void> _changeProfilePicture(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Take a Photo'),
              onTap: () async {
                Navigator.pop(context);
                final pickedFile = await _picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  controller.userProfile.update((val) {
                    val?.profileImageUrl = pickedFile.path;
                  });
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Upload from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  controller.userProfile.update((val) {
                    val?.profileImageUrl = pickedFile.path;
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: TextStyle(color: Palette.PRIMARY)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Palette.PRIMARY),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: GetBuilder<ProfileController>(
          builder: (controller) {
            return FormBuilder(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _changeProfilePicture(context),
                    child: Stack(
                      children: [
                        Obx(() {
                          return CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(controller.userProfile.value.profileImageUrl),
                            backgroundColor: Palette.LIGHT_BACKGROUND,
                          );
                        }),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Palette.PRIMARY,
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.edit, color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
            
                  // Full Name
                  _buildTextField('Full Name', 'full_name', controller.userProfile.value.fullName),
                  SizedBox(height: 16),
            
                  // Email
                  _buildTextField('Email', 'email', controller.userProfile.value.email),
                  SizedBox(height: 16),
            
                  // Council Position
                  _buildTextField('Council Position', 'council_position', controller.userProfile.value.councilPosition),
                  SizedBox(height: 16),
            
                  // Year
                  _buildTextField('Year', 'year', controller.userProfile.value.year),
                  SizedBox(height: 32),
             
                 
                ],
              ),
            );
          }
        ),
      ),
      bottomSheet:  GetBuilder<ProfileController>(
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
                                controller.updateProfile();
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

  Widget _buildTextField(String label, String name, String initialValue) {
    return FormBuilderTextField(
      name: name,
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Palette.LIGHT_BACKGROUND,
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      style: TextStyle(
        fontSize: 16,
        color: Palette.DARK_PRIMARY,
      ),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
      ]),
    );
  }
}
