import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:geolocation/core/constant/style.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:geolocation/features/auth/pages/signup_page.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';

class LoginPage extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    final loginFormKey = GlobalKey<FormBuilderState>();

    return Scaffold(
      backgroundColor: Palette.PRIMARY,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
              //  FocusScope.of(context).unfocus();
           
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 60),
            child: Column(
              children: [
                Gap(Get.size.height * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.macro_off, color: Colors.white, size: 24),
                    const Gap(2),
                    Text(
                      'Geolocation',
                      style: Get.textTheme.titleLarge?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Gap(24),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 22, vertical: 34),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Login',
                        style: Get.textTheme.displaySmall
                            ?.copyWith(fontWeight: FontWeight.bold, height: 0),
                      ),
                      Gap(16),
                      RichText(
                        text: TextSpan(
                          text: 'Don\'t have an account? ',
                          style: Get.textTheme.bodyMedium
                              ?.copyWith(color: Palette.BLACK_SIMI),
                          children: <TextSpan>[
                            TextSpan(
                              text: ' Signup',
                              style: Get.textTheme.bodyMedium?.copyWith(
                                  color: Palette.PRIMARY,
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(() => SignupPage(),
                                      transition: Transition.cupertino);
                                },
                            ),
                          ],
                        ),
                      ),
                      Gap(32),
                      FormBuilder(
                        key: loginFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email', style: Get.textTheme.bodyMedium),
                            const Gap(2),
                            FormBuilderTextField(
                              //  initialValue: '@gmail.com',
                              name: 'email',
                              decoration: _inputDecoration(''),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.email(),
                              ]),
                            ),
                            const Gap(16),
                            Text('Password', style: Get.textTheme.bodyMedium),
                            const Gap(2),
                            Obx(() => FormBuilderTextField(
                                  // initialValue: 'password',
                                  name: 'password',
                                  obscureText: controller.obscureText.value,
                                  decoration: _inputDecoration(
                                          '')
                                      .copyWith(
                                    suffixIcon: IconButton(
                                      icon: Icon(controller.obscureText.value
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: controller.togglePassword,
                                    ),
                                  ),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.minLength(6),
                                  ]),
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Obx(() => Checkbox.adaptive(
                                          value: controller.rememberMe.value,
                                          onChanged: (value) =>
                                              controller.toggleRememberMe(),
                                        )),
                                    Text('Remember me',
                                        style: Get.textTheme.bodySmall),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Text("Forgot Password?",
                                      style: Get.textTheme.bodyMedium!
                                          .copyWith(
                                        color: Palette.PRIMARY,
                                      )),
                                ),
                              ],
                            ),
                            const Gap(32),
                            Obx(() => SizedBox(
                                  height: 50,
                                  width: Get.size.width,
                                  child: GradientElevatedButton(
                                    onPressed: controller.isLoginLoading.value
                                        ? null
                                        : () async {

                                         
                                            if (loginFormKey.currentState  ?.saveAndValidate() ==
                                                true) {
                                              final formData = loginFormKey.currentState  ?.value;
                                              await controller.login(formData);
                                            }
                                          },
                                    style: GRADIENT_ELEVATED_BUTTON_STYLE,
                                    child: controller.isLoginLoading.value
                                        ? CircularProgressIndicator(
                                            color: Colors.white)
                                        : Text(
                                            'Login',
                                            style: Get.textTheme.bodyLarge
                                                ?.copyWith(color: Colors.white),
                                          ),
                                  ),
                                )),
                          ],
                        ),
                      ),
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

  // Input decoration helper
  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      filled: true,
      fillColor: Palette.LIGHT_BACKGROUND,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(12),
      ),
      hintText: hintText,
    );
  }
}
