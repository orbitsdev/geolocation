import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/constant/path.dart';
import 'package:geolocation/core/globalwidget/images/local_lottie_image.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:get/get.dart';

class ModalTestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Modal Test Page")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Modal.success(
                  title: Text("Success"),
                  content: Text("This is a success message."),
                 
                  buttonText: "Close",
                );
              },
              child: Text("Show Success Modal"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Modal.error(
                   visualContent: LocalLottieImage( path: lottiesPath('error.json'), repeat: false,),
                  title: Text("Error"),
                  content: Text("This is an error message."),
                  buttonText: "Retry",
                );
              },
              child: Text("Show Error Modal"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Modal.loading(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                  content:Row(
  mainAxisAlignment: MainAxisAlignment.start, // Center items horizontally
  children: [
    SizedBox(width: 24), // Add space between the spinner and text
    CircularProgressIndicator(),
    SizedBox(width: 36), // Add space between the spinner and text
    Text(
      "Loading...",
      style: Get.textTheme.titleMedium,
    ),
  ],
)
,
                );
              },
              child: Text("Show Loading Modal"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Modal.confirmation(
                    visualContent: LocalLottieImage( path: lottiesPath('question.json'),width: 90,height: 90, repeat: false,),
                  titleText: "Confirm Action",
                  contentText: "Are you sure you want to proceed?",
                  onConfirm: () {
                    // Handle confirmation action
                    print("Confirmed!");
                  },
                  onCancel: () {
                    print("Cancelled");
                  },
                );
              },
              child: Text("Show Confirmation Modal"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Modal.progress(
                  titleText: "File Upload",
                  value: 0.7, // Simulate 70% progress
                  valueLabel: "70% complete",
                );
              },
              child: Text("Show Progress Modal"),
            ),
          ],
        ),
      ),
    );
  }
}
