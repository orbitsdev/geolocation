
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/api/dio/failure.dart';
import 'package:geolocation/core/globalcontroller/modal_controller.dart';
import 'package:geolocation/core/constant/path.dart';
import 'package:geolocation/core/constant/style.dart';
import 'package:geolocation/core/globalwidget/images/local_lottie_image.dart';
import 'package:geolocation/core/globalwidget/loading_widget.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/auth/model/council_position.dart';
import 'package:geolocation/features/collections/create_or_edit_collection_page.dart';
import 'package:geolocation/features/event/model/event.dart';
import 'package:geolocation/features/post/create_or_edit_post_page.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';


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


// static void showEventOptions({
//   required Event event,

//   required VoidCallback onViewDetails,
//   required VoidCallback onViewAttendance,
//   required VoidCallback onUpdateEvent,
//   required VoidCallback onDeleteEvent,
// }) {
//   Get.bottomSheet(
//     Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
//       decoration: BoxDecoration(
//         color: Palette.BACKGROUND, // Use the correct background color
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(16),
//           topRight: Radius.circular(16),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, -4),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Header with Close Button
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   Icon(
//                     Icons.event,
//                     size: 28,
//                     color: Palette.TEXT_DARK, // Text dark color
//                   ), // Event icon
//                   const SizedBox(width: 8),
//                   Text(
//                     'Event Options',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                       color: Palette.TEXT_DARK,
//                     ),
//                   ),
//                 ],
//               ),
//               GestureDetector(
//                 onTap: () => Get.back(),
//                 child: Icon(
//                   Icons.close,
//                   color: Palette.LIGHT_TEXT, // Light text color for close button
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),

//           _buildOption(
//             icon: Icons.info_outline,
//             text: 'View Event Details',
//             onTap: onViewDetails,
//             iconColor: Palette.DARK_PRIMARY,
//           ),
//           const SizedBox(height: 12),
//           _buildOption(
//             icon: Icons.access_time,
//             text: 'View Attendance',
//             onTap: onViewAttendance,
//             iconColor: Palette.DARK_PRIMARY,
//           ),
//           const SizedBox(height: 12),
//           _buildOption(
//             icon: Icons.edit,
//             text: 'Update Event',
//             onTap: onUpdateEvent,
//             iconColor: Palette.DARK_PRIMARY,
//           ),
//           const SizedBox(height: 12),
//           _buildOption(
//             icon: Icons.delete_outline,
//             text: 'Delete Event',
//             onTap: onDeleteEvent,
//             iconColor: Palette.DARK_PRIMARY,
//           ),
//         ],
//       ),
//     ),
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//   );
// }

// static Widget _buildOption({
//   required IconData icon,
//   required String text,
//   required VoidCallback onTap,
//    Color? iconColor,
// }) {
//   return RippleContainer(
//     onTap: onTap,
//     child: Row(
//       children: [
//         Icon(
//           icon,
//           size: 24,
//           color: iconColor ?? null, // Use the correct color for the icon
//         ),
//         const SizedBox(width: 12),
//         Text(
//           text,
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//             color: Palette.TEXT_DARK, // Text dark color for options
//           ),
//         ),
//       ],
//     ),
//   );
// }


// //
// static showCollectionMenu() {
//   Get.bottomSheet(
//     Wrap(
//       children: [
//         ListTile(
//           leading: Icon(Icons.edit),
//           title: Text('Edit Collection'),
//           onTap: () {
//             // Handle edit action
//             Get.back(); // Close the bottom sheet
//           },
//         ),
//         ListTile(
//           leading: Icon(Icons.delete),
//           title: Text('Delete Collection'),
//           onTap: () {
//             // Handle delete action
//             Get.back(); // Close the bottom sheet
//           },
//         ),
//       ],
//     ),
//     isScrollControlled: true,
//     backgroundColor: Colors.white,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//     ),
//   );
// }


static void showEventOptions({
  required Event event,
  required VoidCallback onViewDetails,
  required VoidCallback onViewAttendance,
  required VoidCallback onUpdateEvent,
  required VoidCallback onDeleteEvent,
}) {
  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Event Options',
                style: Get.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Palette.gray600),
                onPressed: () => Get.back(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // View Event Details
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.info_outline, color: Colors.blue.shade700),
            ),
            title: const Text('View Event Details'),
            onTap: () {
              Get.back(); // Close the modal
              onViewDetails();
            },
          ),
          const Divider(),

          // View Attendance
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.access_time, color: Colors.green.shade700),
            ),
            title: const Text('View Attendance'),
            onTap: () {
              Get.back(); // Close the modal
              onViewAttendance();
            },
          ),
          const Divider(),

          // Update Event
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.edit, color: Colors.orange.shade700),
            ),
            title: const Text('Update Event'),
            onTap: () {
              Get.back(); // Close the modal
              onUpdateEvent();
            },
          ),
          const Divider(),

          // Delete Event
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.delete_outline, color: Colors.red.shade700),
            ),
            title: const Text('Delete Event'),
            onTap: () {
              Get.back(); // Close the modal
              onDeleteEvent();
            },
          ),
        ],
      ),
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}


static void showCreationModal() {
  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          // Text(
          //   'Choose Action',
          //   style: Get.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          // ),
          // const SizedBox(height: 16),

          // // Create Post
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.post_add, color: Colors.green.shade700),
            ),
            title: const Text('Create Post'),
            subtitle: const Text('Share updates or news with others.'),
            onTap: () {
              Get.back(); // Close the modal
               Get.to(()=> CreateOrEditPostPage(), transition: Transition.cupertino);
            },
          ),
          const Divider(),

          // // Create Event
          // ListTile(
          //   leading: Container(
          //     padding: const EdgeInsets.all(8),
          //     decoration: BoxDecoration(
          //       color: Colors.green.shade50,
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //     child: Icon(Icons.event, color: Colors.green.shade700),
          //   ),
          //   title: const Text('Create Event'),
          //   subtitle: const Text('Plan and manage events easily.'),
          //   onTap: () {
          //     Get.back(); // Close the modal
          //     // Navigate to Create Event
          //   },
          // ),
          // const Divider(),

          // Create Collection
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.collections, color: Colors.pink.shade700),
            ),
            title: const Text('Create Collection'),
            subtitle: const Text('Organize and manage your collections.'),
            onTap: () {
              Get.back(); // Close the modal
               Get.to(()=> CreateOrEditCollectionPage(), transition: Transition.cupertino);
            },
          ),
        ],
      ),
    ),
    isScrollControlled: true,
  );
}


static void showEventActionModal({
  required VoidCallback onViewEvent,
  required VoidCallback onViewAttendance,
  required VoidCallback onMakeAttendance,
}) {
  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Choose Action',
            style: Get.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // View Event Details
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.event, color: Colors.blue.shade700),
            ),
            title: const Text('View Event'),
            subtitle: const Text('See the event details and information.'),
            onTap: () {
              Get.back(); // Close the modal
              onViewEvent();
            },
          ),
          const Divider(),

          // View Attendance
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.people, color: Colors.orange.shade700),
            ),
            title: const Text('View Attendance'),
            subtitle: const Text('Check attendance records of participants.'),
            onTap: () {
              Get.back(); // Close the modal
              onViewAttendance();
            },
          ),
          const Divider(),

          // Make Attendance
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.check_circle, color: Colors.green.shade700),
            ),
            title: const Text('Make Attendance'),
            subtitle: const Text('Mark your attendance for the event.'),
            onTap: () {
              Get.back(); // Close the modal
              onMakeAttendance();
            },
          ),
        ],
      ),
    ),
    isScrollControlled: true,
  );
}


static void showMemberActionModal(
   
  {
  required CouncilPosition position,
    required VoidCallback onViewMember,
    required VoidCallback onEditMember,
    required VoidCallback onDeleteMember,
  }) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Choose Action',
              style: Get.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // View Member
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.person, color: Colors.blue.shade700),
              ),
              title: const Text('View Member'),
              subtitle: const Text('View the member profile and details.'),
              onTap: () {
                Get.back(); // Close the modal
                onViewMember();
              },
            ),
            const Divider(),

            // Edit Member
            // ListTile(
            //   leading: Container(
            //     padding: const EdgeInsets.all(8),
            //     decoration: BoxDecoration(
            //       color: Colors.orange.shade50,
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //     child: Icon(Icons.edit, color: Colors.orange.shade700),
            //   ),
            //   title: const Text('Edit Member'),
            //   subtitle: const Text('Modify member details and information.'),
            //   onTap: () {
            //     Get.back(); // Close the modal
            //     onEditMember();
            //   },
            // ),
            // const Divider(),

            // Delete Member
           if(!position.owner(AuthController.controller.user.value.defaultPosition?.id as int)&& position.grantAccess == false) ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.delete, color: Colors.red.shade700),
              ),
              title: const Text('Delete Member'),
              subtitle: const Text(
                'Remove this member permanently.',
              ),
              onTap: () {
                Get.back(); // Close the modal
                onDeleteMember();
              },
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}




