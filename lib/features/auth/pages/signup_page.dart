import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/constant/path.dart';
import 'package:geolocation/core/constant/style.dart';
import 'package:geolocation/core/globalwidget/image/offline_image.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/auth/controller/login_controller.dart';
import 'package:geolocation/features/auth/controller/signup_controller.dart';
import 'package:get/get.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';
class SignupPage extends GetView<AuthController> {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.PRIMARY,
      // appBar: AppBar(
      //   backgroundColor: Palette.PRIMARY,
      //   leading: IconButton(
      //     onPressed: () {
      //       Get.back();
      //     },
      //     icon: Icon(Icons.arrow_back, color: Colors.white),
      //   ),
      // ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
              FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.only(left: 10,right:  10,top: 10, bottom: 40),
            child: Column(
              children: [
                
                Container(
                  padding: EdgeInsets.only(
                    left: 22,
                    right: 22,
                    top: 34,
                    bottom: 16,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'SIGN UP',
                        style: Get.textTheme.displaySmall
                            ?.copyWith(fontWeight: FontWeight.bold, height: 0),
                      ),
                      Gap(16),
                      RichText(
                        text: TextSpan(
                          text: 'Already Have an account? ',
                          style: Get.textTheme.bodyMedium
                              ?.copyWith(color: Palette.BLACK_SIMI),
                          children: [
                            TextSpan(
                              text: ' Login',
                              style: Get.textTheme.bodyMedium?.copyWith(
                                  color: Palette.PRIMARY,
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.back();
                                },
                            ),
                          ],
                        ),
                      ),
                      Gap(32),
                      FormBuilder(
                        key: controller.signupFormKey ,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTextField(
                              label: 'First name',
                              name: 'first_name',
                              initialValue: 'Angea ',
                              validator: FormBuilderValidators.required(),
                            ),
                            Gap(16),
                           _buildTextField(
            label: 'Last name',
            name: 'last_name',  
            initialValue: 'Tirado',
            validator: FormBuilderValidators.required(),
          ),
                            Gap(16),
                            _buildTextField(
                              label: 'Email',
                              name: 'email',
                              initialValue: 'e@gmail.com',
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.email(),
                              ]),
                            ),
                            Gap(16),
                           _buildPasswordField(
            label: 'Password',
            name: 'password',
            obscureText: controller.obscurePassword,  // Use obscurePassword here
            toggleVisibility: controller.togglePassword,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.minLength(6),
            ]),
          ),
          
                            Gap(16),
                           _buildPasswordField(
            label: 'Confirm Password',
            name: 'password_confirmation',
            obscureText: controller.obscureConfirm,  // Use obscureConfirm here
            toggleVisibility: controller.togglePasswordConfirm,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.minLength(6),
            ]),
          ),
                            const Gap(32),
                            _buildSubmitButton(),
                            const Gap(16),
                          ],
                        ),
                      ),
                      const Gap(8),
                    Container(
                      child: Row(
                        children: [
                          Flexible(
                              child: Container(
                            height: 2,
                            width: Get.size.width,
                            color: Palette.LIGHT_BACKGROUND,
                          )),
                          Gap(8),
                          Text(
                            'Or',
                            style: Get.textTheme.bodyMedium
                                ?.copyWith(color: Palette.LIGHT_TEXT),
                          ),
                          Gap(8),
                          Flexible(
                              child: Container(
                            height: 2,
                            color: Palette.LIGHT_BACKGROUND,
                          )),
                        ],
                      ),
                    ),
                    const Gap(8),
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton.icon(
                        style: ELEVATED_BUTTON_SOCIALITE_STYLE,
                        onPressed: () {},
                        icon: Container(
                          child: SvgPicture.asset(
                            height: 18,
                            width: 18,
                            'assets/images/google-logo.svg', // Added ".svg" extension
                            semanticsLabel:
                                'Google Logo', // Adjusted semantics label
                          ),
                        ),
                        label: Text(
                          'Continue with Google',
                          style: Get.textTheme.bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const Gap(16),
                      const Gap(16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build a reusable text field
  Widget _buildTextField({
    required String label,
    required String name,
    required String initialValue,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Get.textTheme.bodyMedium?.copyWith(color: Palette.LIGHT_TEXT)),
        Gap(2),
        FormBuilderTextField(
          initialValue: initialValue,
          name: name,
          decoration: InputDecoration(
            filled: true,
            fillColor: Palette.LIGHT_BACKGROUND,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0.5, color: Palette.PRIMARY),
              borderRadius: BorderRadius.circular(12),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  // Build password field
 Widget _buildPasswordField({
  required String label,
  required String name,
  required RxBool obscureText,  // Use RxBool instead of bool
  required VoidCallback toggleVisibility,
  required String? Function(String?) validator,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: Get.textTheme.bodyMedium?.copyWith(color: Palette.LIGHT_TEXT)),
      Gap(2),
      Obx(() => FormBuilderTextField(  // Wrap the text field in Obx
        name: name,
        obscureText: obscureText.value,  // Use .value to get the observable value
        decoration: InputDecoration(
          filled: true,
          fillColor: Palette.LIGHT_BACKGROUND,
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          suffixIcon: IconButton(
            icon: Icon(obscureText.value ? Icons.visibility_off : Icons.visibility),
            onPressed: toggleVisibility,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 0.5, color: Palette.PRIMARY),
            borderRadius: BorderRadius.circular(12),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        validator: validator,
      )),
    ],
  );
}


  // Build the submit button
  Widget _buildSubmitButton() {
  return Obx(() => SizedBox(
    height: 50,
    width: Get.size.width,
    child: GradientElevatedButton(
      onPressed: controller.isLoading.value
          ? null  // Disable button when loading
          : () => controller.register(),
      style: GRADIENT_ELEVATED_BUTTON_STYLE,
      child: controller.isLoading.value
          ? CircularProgressIndicator(color: Colors.white)
          : Text(
              'Register',
              style: Get.textTheme.bodyLarge?.copyWith(color: Colors.white),
            ),
    ),
  ));
}


  // Divider for social login
  Widget _buildOrDivider() {
    return Column(
      children: [
        Divider(thickness: 2, color: Palette.LIGHT_BACKGROUND),
        const Text('Or'),
        Divider(thickness: 2, color: Palette.LIGHT_BACKGROUND),
      ],
    );
  }

  // Build social button (example for Facebook)
  Widget _buildSocialButton(BuildContext context) {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(Icons.facebook),
        label: Text('Continue with Facebook'),
      ),
    );
  }
}
