
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
class Modal {

static success({
    Widget? title,
    Widget? content,
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
            if (visualContent != null) visualContent,
             
            Text("Success", style: Get.textTheme.titleLarge?.copyWith(
              color: Colors.green
            )),
            if (content != null) content,
          ],
        ),
        actions: [
          TextButton(
            onPressed: onDismiss ?? () => Get.back(),
            child: Text(buttonText ?? "OK"),
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
    Get.dialog(
            transitionDuration: Duration(milliseconds: 150),  

      AlertDialog(
        title: title ?? Text("Error", style: TextStyle(color: Colors.red)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (visualContent != null) visualContent,
            if (content != null) content,
          ],
        ),
        actions: [
          TextButton(
            onPressed: onDismiss ?? () => Get.back(),
            child: Text(buttonText ?? "Try Again"),
          ),
        ],
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  // Loading Dialog with optional Lottie/SVG/Image
  static loading({
    Widget? content,
    Widget? visualContent,  // Lottie/SVG/Image widget
    bool barrierDismissible = false,
  }) {
    Get.dialog(
            transitionDuration: Duration(milliseconds: 150),  

      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (visualContent != null) visualContent,
            if (content != null) SizedBox(height: 20),
            if (content != null) content,
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
  }) {
    Get.dialog(
            transitionDuration: Duration(milliseconds: 150),  

      AlertDialog(
        title: Text(titleText),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (visualContent != null) visualContent,
            Text(contentText),
          ],
        ),
        actions: [
          TextButton(
            onPressed: onCancel ?? () => Get.back(),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              onConfirm();
            },
            child: Text(confirmText),
          ),
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
}




