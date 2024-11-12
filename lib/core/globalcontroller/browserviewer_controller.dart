import 'package:flutter/material.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:get/get.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:geolocation/core/api/dio/failure.dart';

class BrowserviewerController extends GetxController {
  InAppWebViewController? webViewController;
  RxString currentUrl = ''.obs;
  bool isDisposed = false;

  void setCurrentUrl(String url) {
    if (isDisposed) return;
    currentUrl.value = url;
    update();
  }

  

  Future<bool> confirmExit() async {
  if (isDisposed) return false;

  bool shouldExit = await Modal.confirmation2(
    titleText: 'Confirm Exit',
    contentText: 'Are you sure you want to exit this page?',
    confirmText: 'Yes',
    cancelText: 'No',
    barrierDismissible: false,
  );

  if (shouldExit) {
    // If "Yes" is confirmed, close and reset the URL or exit
    // Exit the page
    return true;
  } else {
    // If "No" is selected, simply close the dialog
    return false;
  }
}



  void handleLoadError(Failure failure) {
    if (isDisposed) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  void closeResetUrl() {
    if (isDisposed) return;
    currentUrl.value = '';
    update();
    Get.back(result: 'refresh');
  }

  void closeThenResetUrl() {
    if (isDisposed) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<BrowserviewerController>()) {
        Get.back(result: 'close');
      }
    });
  }

  @override
  void onClose() {
    isDisposed = true;
    super.onClose();
  }
}
