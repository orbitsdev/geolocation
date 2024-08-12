import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/constant/path.dart';
import 'package:geolocation/core/global_components/image/offline_image.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/signin/controllers/login_controller.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
const LoginScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Palette.PRIMARY,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 8,
            right: 8,
            bottom: 60.0,
          ),
          child: Column(
            children: [
              Gap(36),
              Container(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 24,
                  bottom: 24,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14)),
                child: Column(
                  children: [


                        Container(
                          width: 90,
                          height:90,
                          child: OfflineImage(
                            borderRadius: BorderRadius.circular(10),
                            path: imagePath('logo.png'))),

                           Gap(34),
                    
                    GetBuilder(
                      init: LoginController(),
                      builder: (controller) {
                        return FormBuilder(
                          key: controller.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FormBuilderTextField(
                                initialValue: 'e@gmail.com',
                                  style: Get.textTheme.bodyMedium!.copyWith(color: Colors.blue),
                                name: 'email',
                                decoration: InputDecoration(
                                  
                                  filled: true,
                                  fillColor: Colors.grey,
                                  // labelText: '',
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal:
                                          10), // Adjust the vertical padding here
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(width: 2.0, color: Colors.red),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide:  const  BorderSide(
                                        width: 1.0, color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const  BorderSide(
                                        width: 1.0, color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(width: 1.0, color: Colors.red),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.email(),
                                ]),
                              ),
                              Gap(8),
                              FormBuilderTextField(
                                initialValue: 'password',
                                style: Get.textTheme.bodyMedium!.copyWith(color: Colors.red),
                                name: 'password',
                                decoration: InputDecoration(
                                  fillColor: Colors.red,
                                  filled: true,
                                  // labelText: 'Password',
                                  contentPadding: const  EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal:
                                          10), // Adjust the vertical padding here
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(width: 2.0, color: Colors.red),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const  BorderSide(
                                        width: 1.0, color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const  BorderSide(
                                        width: 1.0, color: Colors.transparent),
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
                                      onPressed: (){

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
                               const  Gap(16),     
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              width: 1.0, color: Colors.pink),
                                        ),
                                      ),
                                      child: Text(
                                        "Register Here",
                                        style: Get.textTheme.bodyMedium!.copyWith(
                                          color: Colors.blue
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ))),
                                      child: Text(
                                        "Forget Password",
                                         style: Get.textTheme.bodyMedium!.copyWith(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                             const  Gap(32),
                              Center(
                                child: SizedBox(
                                  height: 45,
                                  // width: MediaQuery.of(context).size.width * 0.55,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child:  Text(
                                       'Login',
                                      style:  Get.textTheme.bodyMedium!.copyWith(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                    ),
                                  ),
                                ),
                              ),
                              const Gap(16),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey,
                                ),
                                height: 1,
                              ),
                        
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
                      }
                    ),

                   const  Gap(24),
                    RichText(
                      text: TextSpan(
                          text: 'Dont have an account?',
                          style: TextStyle(
                              height: 1.3, fontSize: 14, color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: ' Signup',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                   
                                  }),
                            
                          ]),
                    ),
                    const Gap(24),
                    // GetBuilder<LoginController>(
                    //   builder: (controller) {
                    //     return SizedBox(
                    //                                height:  45,
                    //       width: MediaQuery.of(context).size.width * 0.70,
                    //       child: ElevatedButton.icon(
                    //          style: ElevatedButton.styleFrom(
                    //            backgroundColor: Colors.white
                    //         ),
                    //         onPressed: () {
                              
                    //         },
                    //         icon:   Container(
                    //           child: SvgPicture.asset(
                    //             height: 24,
                    //             width: 24,
                    //             'assets/images/google-logo.svg', // Added ".svg" extension
                    //             semanticsLabel:
                    //                 'Google Logo', // Adjusted semantics label
                    //           ),
                    //         ),
                    //         label: Text('Continue with Google', style: Get.textTheme.bodyMedium!.copyWith(),),
                    //       ),
                    //     );
                    //   }
                    // ),
                   const Gap(24),
                    SizedBox(
                         height:  45,
                          width: MediaQuery.of(context).size.width * 0.70,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.white

                        ),
                        onPressed: () {},
                        icon: Container(
                       
                          child: SvgPicture.asset(
                            height: 24,
                            width: 24,
                            'assets/images/facebook-logo.svg', // Added ".svg" extension
                            semanticsLabel:
                                'Google Logo', // Adjusted semantics label
                          ),
                        ),
                        label: Text('Continue with Facebook' ,style: Get.textTheme.bodyMedium!.copyWith(),),
                      ),
                    ),
                    const Gap(16),
                  
                  ],
                ),
              ),
              const Gap(24),
              Container(
                width: MediaQuery.of(context).size.width * 0.70,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: 'By signing up, you agree to the',
                      style: const TextStyle(
                          height: 1.3, color: Colors.white, fontSize: 12),
                      children: <TextSpan>[
                        TextSpan(
                            text: ' Terms of Service',
                            style:
                                TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                
                                
                                // navigate to desired screen
                              }),
                        TextSpan(
                          text: ' and acknowledge you’ve read our',
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                        ),
                        TextSpan(
                            text: ' Privacy Policy.',
                            style:
                                TextStyle(decoration: TextDecoration.underline,  fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // navigate to desired screen

                                 
                                // navigate to desired screen
                              }),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}