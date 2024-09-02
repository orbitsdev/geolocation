import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/event/controller/event_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateEventPage extends GetView<EventController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create Event'),
        actions: [
          TextButton(
            onPressed: () {
              controller.createEvent(); // Call controller method to save event
            },
            child: Text(
              'Save',
              style: TextStyle(color: Palette.PRIMARY),
            ),
          ),
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
                'Event Date',
                style: Get.textTheme.bodyMedium
                    ?.copyWith(color: Palette.LIGHT_TEXT),
              ),
              Gap(8),
              FormBuilderDateTimePicker(
                name: 'date',
                inputType: InputType.date,
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
                  hintText: 'Select event date',
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
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
                    child: GoogleMap(
                      gestureRecognizers: {
                            Factory<OneSequenceGestureRecognizer>(
                              () => EagerGestureRecognizer(),
                            ),
                          },
                      mapType: MapType.normal,
                      initialCameraPosition: controller.cameraPosition as CameraPosition,
                      onMapCreated: (GoogleMapController googleMapController) {
                        controller.mapController.complete(googleMapController);
                      },
                      onTap: (LatLng position) {
                        controller.setLocation(position);
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
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.min(
                            50), // Minimum radius of 50 meters
                        FormBuilderValidators.max(
                            5000), // Maximum radius of 5000 meters
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
            ],
          ),
        ),
      ),
    );
  }
}
