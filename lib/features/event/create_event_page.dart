import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/formatters/radius_formatter.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/event/controller/event_controller.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({Key? key}) : super(key: key);

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  var controller = Get.find<EventController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create Event'),
        actions: [
          // TextButton(
          //   onPressed: () {
          //     controller.createEvent(); // Call controller method to save event
          //   },
          //   child: Text(
          //     'Save',
          //     style: TextStyle(color: Palette.PRIMARY),
          //   ),
          // ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: FormBuilder(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Title
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
                  hintText: 'Select event start time',
                  filled: true,
                  fillColor: Palette.LIGHT_BACKGROUND,
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
              Gap(8),
              Obx(() => SizedBox(
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
                            controller.mapController
                                .complete(googleMapController);
                          },
                          onTap: (LatLng position) {
                            controller.setNewLocation(position);
                          },
                          markers: controller.isLocationSelected.value
                              ? {
                                  Marker(
                                    markerId: MarkerId('selected-location'),
                                    position: controller.selectedLocation.value,
                                  ),
                                }
                              : {},
                          circles: controller.isLocationSelected.value
                              ? {
                                  Circle(
                                    circleId: CircleId('selected-radius'),
                                    center: controller.selectedLocation.value,
                                    radius: controller.radius.value,
                                    fillColor: Colors.blue.withOpacity(0.2),
                                    strokeColor: Colors.blue,
                                    strokeWidth: 2,
                                  ),
                                }
                              : {},
                        ),
                        if (controller.isLocationSelected.value)
                          Positioned(
                            top: 60,
                            right: 8,
                            child: FloatingActionButton(
                              backgroundColor: Colors.red,
                              mini: true,
                              onPressed: () => controller
                                  .clearLocation(), // Call the clear location method
                              child: Icon(Icons.clear, color: Colors.white),
                              tooltip: "Clear Location",
                            ),
                          ),
                      ],
                    ),
                  )),
              Gap(16),

              // Radius Input
              Text(
                'Set Event Radius (meters)',
                style: Get.textTheme.bodyMedium
                    ?.copyWith(color: Palette.LIGHT_TEXT),
              ),
              Gap(8),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      name: 'radius',
                      initialValue: controller.radius.value.toString(),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Palette.LIGHT_BACKGROUND,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0.5, color: Palette.PRIMARY),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 1.0, color: Colors.transparent),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 1.0, color: Colors.transparent),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1.0, color: Colors.red),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Enter radius',
                      ),
                      onChanged: (value) {
                        controller.setRadius(
                            double.tryParse(value as String) ?? 100.0);
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        RadiusInputFormatter(min: 50, max: 1000),
                      ],
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.min(
                            50), // Minimum radius of 50 meters
                        FormBuilderValidators.max(
                            1000), // Maximum radius of 5000 meters
                      ]),
                    ),
                  ),
                ],
              ),
              Gap(8),
              Obx(() => Slider(
                    value: controller.radius.value,
                    min: 50,
                    max: 5000,
                    divisions: 100,
                    label: controller.radius.value.round().toString(),
                    onChanged: (value) {
                      controller.setRadius(value);
                    },
                  )),

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
                  controller.createEvent();
                },
                child: Text(
                  'Save Event',
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
