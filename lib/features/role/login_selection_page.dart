import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/constant/style.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/home/admin_home_main_page.dart';
import 'package:geolocation/features/role/model/role.dart';
import 'package:get/get.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';
import 'package:shimmer/main.dart';

class LoginSelectionPage extends StatefulWidget {
  const LoginSelectionPage({Key? key}) : super(key: key);

  @override
  State<LoginSelectionPage> createState() => _LoginSelectionState();
}

class _LoginSelectionState extends State<LoginSelectionPage> {
  String selectedRole = Role.ADMIN; // Default selected role

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Palette.BACKGROUND,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gap(Get.size.height * 0.10),
              Text(
                'Continue As',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Choose your role within the council to access the relevant tools and resources tailored to your responsibilities.',
                textAlign: TextAlign.center,
                style: Get.textTheme.bodyMedium
                    ?.copyWith(color: Palette.LIGHT_TEXT),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildRoleOption(Role.ADMIN, Icons.school),
                  buildRoleOption(Role.OFFICER, Icons.person_outline),
                ],
              ),

              Gap(48),
               SizedBox(
                                        height: 50,
                                    width: Get.size.width,
                                  child: ElevatedButton(
                                   onPressed:(selectedRole!= Role.ADMIN) ? null : (){
                                        switch(selectedRole){
                                          case Role.ADMIN:
                                        Get.to(()=> AdminHomeMainPage(), transition: Transition.cupertino);
                                          return ;
                                          default:
                                        Modal.showToast(msg: 'Not Available For Now');

                                        return;
                                          
                                        }
                                   },
                                    style:ELEVATED_BUTTON_STYLE,
                                    child:Text(
                                        'Confirm',
                                        style: Get.textTheme.bodyLarge
                                            ?.copyWith(color: Colors.white),
                                      )),
                                ),
            ],
          ),
        ));
  }

  Widget buildRoleOption(String role, IconData icon) {
    bool isSelected = selectedRole == role;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = role;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Palette.PRIMARY : Colors.white,
          border: Border.all(
            color: isSelected ? Palette.PRIMARY : Palette.LIGHT_TEXT,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(icon,
                size: 40,
                color: isSelected ? Colors.white : Palette.LIGHT_TEXT),
            SizedBox(height: 10),
            Text(
              role,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Palette.LIGHT_TEXT,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
