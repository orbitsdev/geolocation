// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'package:geolocation/core/formatters/radius_formatter.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/event/controller/event_controller.dart';
import 'package:intl/number_symbols_data.dart';

class CreateEventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<EventController>();

    // Retrieve the arguments
    final arguments = Get.arguments;
    final isEditMode = arguments?['isEditMode'] ?? false;
    final event = arguments?['event'];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('--------------------------  VENT LOAD');
      print(event);
      print(isEditMode);
      if (isEditMode == true && event != null) {
        controller.selectedItem.value = event;
        print('Selected DATA ${controller.selectedItem.value}');
        controller.fillForm();
        controller.update();
      } else {
        controller.setCameraPositionToMyCurrentPosition();
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              if (isEditMode == true) {
                controller.clearData();
                Get.back();
              } else {
                Get.back();
              }
            },
            icon: Icon(Icons.arrow_back)),
        title: Text(isEditMode == true ? 'Update Event' : 'Create Event'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: FormBuilder(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(8),
              GetBuilder<EventController>(builder: (eventcontroller) {
                return SizedBox(
                  height: 300, // Adjust as needed
                  child: Stack(
                    children: [
                      GoogleMap(
                        gestureRecognizers: {
                          Factory<OneSequenceGestureRecognizer>(
                            () => EagerGestureRecognizer(),
                          ),
                        },
                        mapType: MapType.normal,
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        initialCameraPosition:
                            controller.cameraPosition as CameraPosition,
                        onMapCreated:
                            (GoogleMapController googleMapController) {
                          eventcontroller.googleMapController =
                              googleMapController;
                          eventcontroller
                              .setMapReady(); // Set the map ready state
                        },
                        onLongPress: (LatLng position){
                          eventcontroller.setLocation(position);

                        },
                        onTap: (LatLng position) {
                          eventcontroller.setLocation(position);
                        },
                        markers: controller.markers,
                        circles: controller.circles,
                      ),

                      // Overlay Progress Indicator
                      if (!eventcontroller.isMapReady.value)
                        Center(
                          child: CircularProgressIndicator(),
                        ),

                      if (eventcontroller.isLocationSelected.value)
                        Positioned(
                          top: 60,
                          right: 8,
                          child: FloatingActionButton(
                            backgroundColor: Colors.red,
                            mini: true,
                            onPressed: () => eventcontroller.clearData(),
                            child: Icon(Icons.clear, color: Colors.white),
                            tooltip: "Clear Location",
                          ),
                        ),
                    ],
                  ),
                );
              }),

              Gap(16),

              Text(
                'Set Event Radius',
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              Gap(8),
              GetBuilder<EventController>(builder: (taskcontroller) {
                return SizedBox(
                  height: 3, // Ensure a fixed height for both states
                  child: taskcontroller.isLocationLoading.value
                      ? LinearProgressIndicator(color: Palette.PRIMARY)
                      : Container(
                          color: Colors
                              .transparent), // Transparent to avoid visual impact
                );
              }),
              Gap(8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Current Radius',
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: Palette.PRIMARY,
                    ),
                  ),
                  GetBuilder<EventController>(builder: (eventController) {
                    return Text(
                      '${eventController.radius.value.round()} meters', // Clearly label the unit
                      style: Get.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Palette.PRIMARY,
                      ),
                    );
                  })
                ],
              ),

// Radius Slider
              GetBuilder<EventController>(
                builder: (eventController) {
                  return Slider(
                    value: eventController.radius.value,
                    min: 10,
                    max: 1000,
                    divisions: (1000 - 10),
                    label: '${eventController.radius.value.round()} meters',
                    onChanged: (value) {
                      eventController
                          .setRadius(value); // Update both UI and logic
                    },
                  );
                },
              ),

// Additional Note
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Palette.LIGHT_BACKGROUND,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        width: 0.2, color: Palette.PRIMARY.withOpacity(0.80))),
                child: Text(
                  'Note: Ensure the selected radius covers the event area to allow attendees within the geofence.',
                  style:
                      Get.textTheme.bodySmall?.copyWith(color: Palette.PRIMARY),
                ),
              ),

              Gap(8),
              GetBuilder<EventController>(builder: (eventController) {
                return controller.selectedLocationDetails.value != ''
                    ? RippleContainer(
                        onTap: () => eventController.moveCamera(LatLng(
                            eventController.selectedItem.value.latitude
                                as double,
                            eventController.selectedItem.value.longitude
                                as double)),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                // Add light gray border
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 8,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Coordinates',
                                  style: Get.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  ' ${controller.selectedLocation.value.latitude}, '
                                  '${controller.selectedLocation.value.longitude}',
                                  style: Get.textTheme.bodyMedium?.copyWith(
                                    color: Colors.black87,
                                  ),
                                ),
                                Divider(color: Colors.grey.shade300),
                                Text(
                                  'Location Details',
                                  style: Get.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  '${controller.selectedLocationDetails.value}',
                                  style: Get.textTheme.bodyMedium?.copyWith(
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container();
              }),
              Gap(8),
              Text(
                'Event Title',
                style: Get.textTheme.bodyMedium
                    ?.copyWith(color: Palette.LIGHT_TEXT),
              ),
              Gap(8),
              FormBuilderTextField(
                name: 'title',
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Palette.LIGHT_BACKGROUND,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 0.5, color: Palette.PRIMARY),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 1.0, color: Colors.transparent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 1.0, color: Colors.transparent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1.0, color: Colors.red),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Enter event title',
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              Gap(16),

              // Event Description
              Text(
                'Event Description',
                style: Get.textTheme.bodyMedium
                    ?.copyWith(color: Palette.LIGHT_TEXT),
              ),
              Gap(8),
              FormBuilderTextField(
                name: 'description',
                maxLines: 3,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Palette.LIGHT_BACKGROUND,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 0.5, color: Palette.PRIMARY),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 1.0, color: Colors.transparent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 1.0, color: Colors.transparent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1.0, color: Colors.red),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Enter event description',
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              Gap(16),

              // Event Date
              Text(
                'Start Time',
                style: Get.textTheme.bodyMedium
                    ?.copyWith(color: Palette.LIGHT_TEXT),
              ),
              Gap(8),
              // Start Time Picker
              FormBuilderDateTimePicker(
                name: 'start_time',
                inputType: InputType.both, // Allows date and time selection
//  initialValue: DateTime.now(), // Set default to current date/time
                format: DateFormat(
                    'dd MMM yyyy, hh:mm a'), // Customize display format
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Palette.LIGHT_BACKGROUND,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 0.5, color: Palette.PRIMARY),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 1.0, color: Colors.transparent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 1.0, color: Colors.transparent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1.0, color: Colors.red),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Select event start time',
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  (val) {
                    if (val != null && val.isBefore(DateTime.now())) {
                      return 'Start time must be today or later';
                    }
                    return null;
                  },
                ]),
              ),

              Gap(16),

              Text(
                'End Time',
                style: Get.textTheme.bodyMedium
                    ?.copyWith(color: Palette.LIGHT_TEXT),
              ),

              FormBuilderDateTimePicker(
                name: 'end_time',
                inputType: InputType.both,
                // initialValue: DateTime.now().add(Duration(hours: 1)), // Default 1 hour later
                format: DateFormat(
                    'dd MMM yyyy, hh:mm a'), // Customize display format
                decoration: InputDecoration(
                  hintText: 'Select event end time',
                  filled: true,
                  fillColor: Palette.LIGHT_BACKGROUND,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 0.5, color: Palette.PRIMARY),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 1.0, color: Colors.transparent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 1.0, color: Colors.transparent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1.0, color: Colors.red),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  (val) {
                    final startTime = controller
                        .formKey.currentState?.fields['start_time']?.value;
                    if (val != null &&
                        startTime != null &&
                        val.isBefore(startTime)) {
                      return 'End time must be after start time';
                    }
                    return null;
                  },
                ]),
              ),

              Gap(16),

              // Google Map for Location
              Text(
                'Event Location',
                style: Get.textTheme.bodyMedium
                    ?.copyWith(color: Palette.LIGHT_TEXT),
              ),

              Gap(Get.size.height * 0.05),
            ],
          ),
        ),
      ),
      bottomSheet: GetBuilder<EventController>(
        builder: (controller) {
          return Container(
            height: Get.size.height * 0.11,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Color(0x000000).withOpacity(0.03),
                offset: Offset(0, -4),
                blurRadius: 3,
                spreadRadius: 0,
              )
            ]),
            child: Container(
              width: Get.size.width,
              constraints: const BoxConstraints(minWidth: 150),
              height: Get.size.height,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.PRIMARY,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (isEditMode == true) {
                    controller.updateEvent();
                  } else {
                    controller.createEvent();
                  }
                },
                child: Text(
                  isEditMode == true ? 'Update Event' : 'Save Event',
                  style: Get.textTheme.bodyLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
