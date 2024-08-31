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
import 'package:geolocation/features/signin/controllers/login_controller.dart';
import 'package:geolocation/features/signup/signup_page.dart';
import 'package:get/get.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.PRIMARY,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            bottom: 60.0,
          ),
          child: Column(
            children: [
              Gap(Get.size.height * 0.05),

              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.macro_off,
                      color: Colors.white,
                      size: 24,
                    ),
                    const Gap(2),
                    Text(
                      'Geolocation',
                      style: Get.textTheme.titleLarge?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),

              Gap(24),
              Container(
                padding: EdgeInsets.only(
                  left: 22,
                  right: 32,
                  top: 34,
                  bottom: 16,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14)),
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
                                    Get.to(()=> SignupPage(), transition: Transition.cupertino);
                                  }),
                          ]),
                    ),
                    Gap(32),
                    GetBuilder(
                        init: LoginController(),
                        builder: (controller) {
                          return FormBuilder(
                            key: controller.formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Email',
                                  style: Get.textTheme.bodyMedium
                                      ?.copyWith(color: Palette.LIGHT_TEXT),
                                ),
                                Gap(2),
                                FormBuilderTextField(
                                  initialValue: 'e@gmail.com',
                                  style: Get.textTheme.bodyMedium!.copyWith(),
                                  name: 'email',
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Palette.LIGHT_BACKGROUND,

                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal:
                                            10), // Adjust the vertical padding here
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 0.5, color: Palette.PRIMARY),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 1.0,
                                          color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 1.0,
                                          color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 1.0, color: Colors.red),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.email(),
                                  ]),
                                ),
                                Gap(16),
                                Text(
                                  'Password',
                                  style: Get.textTheme.bodyMedium
                                      ?.copyWith(color: Palette.LIGHT_TEXT),
                                ),
                                Gap(2),
                                FormBuilderTextField(
                                  initialValue: 'password',
                                  name: 'password',
                                  style: Get.textTheme.bodyMedium!.copyWith(),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Palette.LIGHT_BACKGROUND,
                                    // labelText: 'Password',
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal:
                                            10), // Adjust the vertical padding here
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 0.5, color: Palette.PRIMARY),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 1.0,
                                          color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 1.0,
                                          color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    suffixIcon: SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: IconButton(
                                        icon: Icon(
                                          controller.obscureText
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          controller.togglePassword();
                                        },
                                      ),
                                    ),
                                  ),
                                  obscureText: controller.obscureText,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.minLength(6),
                                  ]),
                                ),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox.adaptive(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4)),
                                            value: controller.rememberme,
                                            onChanged: (value) =>
                                                controller.toggleRememberMe()),
                                        Text(
                                          'Remember me',
                                          style: Get.textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Text(
                                        "Forget Password? ",
                                        style:
                                            Get.textTheme.bodyMedium!.copyWith(
                                          color: Palette.PRIMARY,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(32),
                                // Center(
                                //   child: SizedBox(
                                //     height: 50,
                                //     width: Get.size.width,
                                //     // width: MediaQuery.of(context).size.width * 0.55,
                                //     child: ElevatedButton(
                                //       onPressed: () => controller.login(),
                                //       child: Text(
                                //         'Login',
                                //         style: Get.textTheme.bodyLarge
                                //             ?.copyWith(color: Colors.white),
                                //       ),
                                //       style: ELEVATED_BUTTON_STYLE,
                                //     ),
                                //   ),
                                // ),
                                SizedBox(
                                        height: 50,
                                    width: Get.size.width,
                                  child: GradientElevatedButton(
                                   onPressed: () => controller.login(),
                                    style:GRADIENT_ELEVATED_BUTTON_STYLE,
                                    child:Text(
                                        'Login',
                                        style: Get.textTheme.bodyLarge
                                            ?.copyWith(color: Colors.white),
                                      )),
                                ),
                                Gap(16),

                                // MaterialButton(
                                //   color: Theme.of(context).colorScheme.secondary,
                                //   onPressed: () {
                                //     // Validate and save the form values
                                //     _formKey.currentState?.saveAndValidate();
                                //     debugPrint(_formKey.currentState?.value.toString());

                                //     // On another side, can access all field values without saving form with instantValues
                                //     _formKey.currentState?.validate();
                                //     debugPrint(_formKey.currentState?.instantValue.toString());
                                //   },
                                //   child: const Text('Login'),
                                // )
                              ],
                            ),
                          );
                        }),
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
                          'Continue with Facebook',
                          style: Get.textTheme.bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const Gap(16),
                  ],
                ),
              ),

              // Container(
              //   width: MediaQuery.of(context).size.width * 0.70,
              //   child: RichText(
              //     textAlign: TextAlign.center,
              //     text: TextSpan(
              //         text: 'By signing up, you agree to the',
              //         style: const TextStyle(
              //             height: 1.3, color: Colors.white, fontSize: 12),
              //         children: <TextSpan>[
              //           TextSpan(
              //               text: ' Terms of Service',
              //               style:
              //                   TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold),
              //               recognizer: TapGestureRecognizer()
              //                 ..onTap = () {

              //                   // navigate to desired screen
              //                 }),
              //           TextSpan(
              //             text: ' and acknowledge you’ve read our',
              //             style:
              //                 TextStyle(decoration: TextDecoration.underline),
              //           ),
              //           TextSpan(
              //               text: ' Privacy Policy.',
              //               style:
              //                   TextStyle(decoration: TextDecoration.underline,  fontWeight: FontWeight.bold),
              //               recognizer: TapGestureRecognizer()
              //                 ..onTap = () {

              //                 }),
              //         ]),
              //   ),
              // ),
              Gap(Get.size.height * 0.02)
            ],
          ),
        ),
      ),
    );
  }
}
