
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/api/dio/failure.dart';
import 'package:geolocation/core/globalcontroller/modal_controller.dart';
import 'package:geolocation/core/constant/path.dart';
import 'package:geolocation/core/constant/style.dart';
import 'package:geolocation/core/globalwidget/images/local_lottie_image.dart';
import 'package:geolocation/core/globalwidget/loading_widget.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:get/get.dart';


class Modal {



static errorDialog(
  {String? message,
    Failure? failure,
    Widget? visualContent,  
    String? buttonText = "OK",
    VoidCallback? onDismiss,
    bool barrierDismissible = false,
    bool? repeat = true,
    
    }
){

    // Prevent showing multiple dialogs
    if (ModalController.controller.isDialogVisible.value) {
        return;
    }

    // Mark the dialog as visible
    ModalController.controller.setDialog(true);
   Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          (visualContent != null) ? visualContent : LocalLottieImage(
            path: lottiesPath('error.json'),
            repeat: repeat ?? true,
          ),
          Gap(12),
           if(message != null)  Text(
              "${message}",
              style: Get.textTheme.titleLarge?.copyWith(
                color: Colors.red,
              ),
            ),
            Text('${failure?.message}',style:  Get.textTheme.bodyLarge, textAlign: TextAlign.center,),
          ],
        ),
        actions: [
          SizedBox(
  width: double.infinity, // Full width
  child: ElevatedButton(
    style: ELEVATED_BUTTON_STYLE,
    onPressed: onDismiss ?? () {
      Get.back();
      ModalController.controller.setDialog(false);
    },
    child: Text(buttonText ?? "Try Again", style: TextStyle(color: Colors.white) ,),
  ),
),

        ],
      ),
      barrierDismissible: barrierDismissible,
    ).then((_) {
      // Ensure the dialog visibility is reset even if the dialog is dismissed in other ways
      ModalController.controller.setDialog(false);
    });

}


static errorDialogMessage(
  {String? message,
    Failure? failure,
    Widget? visualContent,  
    String? buttonText = "OK",
    VoidCallback? onDismiss,
    bool barrierDismissible = false,
    bool? repeat = true,
    
    }
){

    // Prevent showing multiple dialogs
    if (ModalController.controller.isDialogVisible.value) {
        return;
    }

    // Mark the dialog as visible
    ModalController.controller.setDialog(true);
   Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          (visualContent != null) ? visualContent : LocalLottieImage(
            path: lottiesPath('error.json'),
            repeat: repeat ?? true,
          ),
          Gap(12),
           
            Text('${message}',style:  Get.textTheme.bodyLarge,),
          ],
        ),
        actions: [
          SizedBox(
  width: double.infinity, // Full width
  child: ElevatedButton(
    style: ELEVATED_BUTTON_STYLE,
    onPressed: onDismiss ?? () {
      Get.back();
      ModalController.controller.setDialog(false);
    },
    child: Text(buttonText ?? "Try Again", style: TextStyle(color: Colors.white) ,),
  ),
),

        ],
      ),
      barrierDismissible: barrierDismissible,
    ).then((_) {
      // Ensure the dialog visibility is reset even if the dialog is dismissed in other ways
      ModalController.controller.setDialog(false);
    });

}
static success({
   
    String? message = 'Success!',
  
    Widget? visualContent,  // Lottie/SVG/Image widget
    String? buttonText = "OK",
    VoidCallback? onDismiss,
    bool barrierDismissible = false,
  }) {


    Get.dialog(
      transitionDuration: Duration(milliseconds: 150),  
      AlertDialog(
        
        
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: Get.size.width,),
          (visualContent != null) ? visualContent : LocalLottieImage(
            path: lottiesPath('success.json'),
            repeat: false,
          ),
            Gap(8),
            Text(
      '${message}',
     textAlign: TextAlign.center,
        style: Get.textTheme.bodyMedium?.copyWith(
          color: Colors.black54,
        ), // Center the content text
            )
        
      
            
          ],
        ),
        actions: [
          SizedBox(
             width: double.infinity,
            child: ElevatedButton(
               style: ElevatedButton.styleFrom(
                backgroundColor: Palette.PRIMARY,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: onDismiss ?? () => Get.back(),
              child: Text(buttonText ?? "OK",style: Get.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
            ),
          ),
        ],
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  // Error Dialog with optional Lottie/SVG/Image
 static error({
    Widget? title,
    Widget? content,
    Widget? visualContent,  // Lottie/SVG/Image widget
    String? buttonText = "Try Again",
    VoidCallback? onDismiss,
    bool barrierDismissible = false,
  }) {

    // Prevent showing multiple dialogs
    if (ModalController.controller.isDialogVisible.value) {
        return;
    }

    // Mark the dialog as visible
    ModalController.controller.setDialog(true);

    Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (visualContent != null) visualContent,
            Text(
              "Error",
              style: Get.textTheme.titleLarge?.copyWith(
                color: Colors.red,
              ),
            ),
            if (content != null) content,
          ],
        ),
        actions: [
          SizedBox(
  width: double.infinity, // Full width
  child: ElevatedButton(
    style: ELEVATED_BUTTON_STYLE,
    onPressed: onDismiss ?? () {
      ModalController.controller.setDialog(false);
      Get.back();
    },
    child: Text(buttonText ?? "Try Again", style: TextStyle(color: Colors.white) ,),
  ),
),

        ],
      ),
      barrierDismissible: barrierDismissible,
    ).then((_) {
      // Ensure the dialog visibility is reset even if the dialog is dismissed in other ways
      ModalController.controller.setDialog(false);
    });
  }


  // Loading Dialog with optional Lottie/SVG/Image
  static loading({
    ShapeBorder? shape,    
    Widget? content,
    Widget? visualContent,  // Lottie/SVG/Image widget
    bool barrierDismissible = false,
  }) {
    Get.dialog(
            transitionDuration: Duration(milliseconds: 150),  
      AlertDialog(
        shape: shape??  RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LoadingWidget(message: 'Loading..',)
          ],
        ),
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  // Confirmation Dialog with optional Lottie/SVG/Image
  static confirmation({
    required String titleText,
    required String contentText,
    required VoidCallback onConfirm,
    Widget? visualContent,  // Lottie/SVG/Image widget
    VoidCallback? onCancel,
    String confirmText = "Yes",
    String cancelText = "No",
    bool barrierDismissible = true,
    bool? repeat = true,
  }) {
    Get.dialog(
            transitionDuration: Duration(milliseconds: 150),  

      AlertDialog(


        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

       
          (visualContent != null) ? visualContent : LocalLottieImage(
            path: lottiesPath('question.json'),
            repeat: repeat == false,
          ),
              Gap(8), // Spacing between title and content
                Text(
        titleText,
        textAlign: TextAlign.center,
        style: Get.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),),
              Gap(8), // Spacing between title and content

           
    Text(
      contentText,
     textAlign: TextAlign.center,
        style: Get.textTheme.bodyMedium?.copyWith(
          color: Colors.black54,
        ), // Center the content text
    ),
          ],
        ),
        actions: [    

           Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                cancelText,
                style: Get.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
              onPressed: onCancel ?? () => Get.back(),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Palette.PRIMARY,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                confirmText,
                style: Get.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
              Get.back();
              onConfirm();
            },
            ),
          ],
        ),
 
          // TextButton(
          //   onPressed: onCancel ?? () => Get.back(),
          //   child: Text(cancelText),
          // ),
          // TextButton(
          //   onPressed: () {
          //     Get.back();
          //     onConfirm();
          //   },
          //   child: Text(confirmText),
          // ),
        ],
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  // Progress Dialog with optional Lottie/SVG/Image
  static progress({
    required String titleText,
    required double value,
    Widget? visualContent,  // Lottie/SVG/Image widget
    String? valueLabel,
    bool barrierDismissible = false,
  }) {
    Get.dialog(
            transitionDuration: Duration(milliseconds: 150),  

      AlertDialog(
        title: Text(titleText),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (visualContent != null) visualContent,
            LinearProgressIndicator(value: value),
            if (valueLabel != null) SizedBox(height: 10),
            if (valueLabel != null) Text(valueLabel),
          ],
        ),
      ),
      barrierDismissible: barrierDismissible,
    );
  }
   static showToast(
      {String? msg = "Toast Message",
      Color? color,
      Toast? toastLength,
      Color? textColor,
      ToastGravity? gravity}) {
    Fluttertoast.showToast(
        msg: msg as String,
        toastLength: toastLength ?? Toast.LENGTH_SHORT,
        gravity: gravity ?? ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color ?? Colors.black,
        textColor: textColor ?? Colors.white,
        fontSize: 16.0);
  }

   static void androidDialogNoContext({
    String title = 'Loading',
    bool barrierDismissible = false,
  }) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: 80,
              constraints: BoxConstraints(maxHeight: 80),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      height: 26,
                      width: 26,
                      child: CircularProgressIndicator(
                        color: Palette.PRIMARY,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    title,
                    style: Get.textTheme.bodySmall?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: barrierDismissible,
    );
  }
static Future<bool> confirmation2({
  required String titleText,
  required String contentText,
  Widget? visualContent, // Optional visual content (Lottie/SVG/Image)
  String confirmText = "Yes",
  String cancelText = "No",
  bool barrierDismissible = true,
  bool? repeat = true,
}) async {
  final result = await Get.dialog<bool>(
    AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          visualContent ??
              LocalLottieImage(
                path: lottiesPath('question.json'),
                repeat: repeat == false,
              ),
          const Gap(8),
          Text(
            titleText,
            textAlign: TextAlign.center,
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const Gap(8),
          Text(
            contentText,
            textAlign: TextAlign.center,
            style: Get.textTheme.bodyMedium?.copyWith(
              color: Colors.black54,
            ),
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                cancelText,
                style: Get.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
              onPressed: () {
                Get.back(result: false); // Return false when "No" is clicked
              },
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Palette.PRIMARY,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                confirmText,
                style: Get.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Get.back(result: true); // Return true when "Yes" is clicked
              },
            ),
          ],
        ),
      ],
    ),
    barrierDismissible: barrierDismissible,
  );

  return result ?? false; // Default to false if dialog is dismissed without action
}



 static warning({
    String title = "Warning",
    String message = "Please check your input.",
    Widget? visualContent,
    String buttonText = "OK",
    VoidCallback? onDismiss,
    bool barrierDismissible = true,
  }) {
    Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (visualContent != null)
              visualContent
            else
              LocalLottieImage(
                path: lottiesPath('warning.json'), // Add a warning Lottie animation
                repeat: false,
              ),
            const Gap(12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Get.textTheme.titleLarge?.copyWith(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: Colors.black54,
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Warning color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: onDismiss ?? () => Get.back(),
              child: Text(
                buttonText,
                style: Get.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  // Info Dialog
  static info({
    String title = "Information",
    String message = "Here is some information.",
    Widget? visualContent,
    String buttonText = "OK",
    VoidCallback? onDismiss,
    bool barrierDismissible = true,
  }) {
    Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (visualContent != null)
              visualContent
            else
              LocalLottieImage(
                path: lottiesPath('info.json'), // Add an info Lottie animation
                repeat: false,
              ),
            const Gap(12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Get.textTheme.titleLarge?.copyWith(
                color: Palette.PRIMARY,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: Colors.black54,
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Palette.PRIMARY, // Primary info color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: onDismiss ?? () => Get.back(),
              child: Text(
                buttonText,
                style: Get.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: barrierDismissible,
    );
  }

}




