import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocation/features/event/model/event.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventController extends GetxController {

   var events = <Event>[].obs; 
    void fetchEvents() {
    // For now, we'll just add some dummy data
    events.addAll([
      Event(
        id: '1',
        title: 'University Sports Meet',
        description: 'Annual sports meet at the university stadium.',
        date: '2024-09-20',
        latitude: 37.42796133580664,
        longitude: -122.085749655962,
        radius: 100.0,
      ),
      Event(
        id: '2',
        title: 'Academic Seminar',
        description: 'Seminar on recent academic developments.',
        date: '2024-09-22',
        latitude: 37.4219983,
        longitude: -122.084,
        radius: 150.0,
      ),
    ]);
  }

  static EventController controller = Get.find();
  
  final formKey = GlobalKey<FormBuilderState>();
  final Completer<GoogleMapController> mapController = Completer();
  
  Rx<LatLng> selectedLocation = LatLng(0, 0).obs; // Default LatLng
  RxDouble radius = 100.0.obs; // Default radius in meters
  RxBool isLocationSelected = false.obs;

  Position? currentPosition;
  CameraPosition? cameraPosition = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  @override
  void onInit() {
    super.onInit();
    setCameraPositionToMyCurrentPosition(); // Automatically set the camera position to the user's current location
  }


@override
  void onReady() {
    super.onReady();
    fetchEvents(); // Load events when the controller is ready
  }

  Future<void> setCameraPositionToMyCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, show a message or handle accordingly
      print('Location services are disabled.');
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, show a message or handle accordingly
        print('User denied location permissions.');
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied, handle accordingly
      print('Location permissions are permanently denied, we cannot request permissions.');
      return;
    }

    // If permissions are granted, get the current position
    try {
      currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Set the map's target position based on the current position
      LatLng position = LatLng(currentPosition!.latitude, currentPosition!.longitude);

      // Update camera position
      cameraPosition = CameraPosition(
        target: position,
        zoom: 16.999, // Adjust as needed
        tilt: 40,     // Adjust as needed
        bearing: -1000, // Adjust as needed
      );

      // Update selected location and isLocationSelected flag
      selectedLocation.value = position;
      isLocationSelected.value = true;

      // Animate the map's camera to the new position
      final GoogleMapController googleMapController = await mapController.future;
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition!),
      );
    } catch (e) {
      // Handle any errors (e.g., location unavailable)
      print('Error setting camera position: $e');
    }
  }

  void setLocation(LatLng location) {
    selectedLocation.value = location;
    isLocationSelected.value = true;
  }

  void setRadius(double value) {
    radius.value = value;
  }

  void createEvent() {
    if (formKey.currentState?.saveAndValidate() ?? false) {
      final eventData = formKey.currentState?.value;
      print('Event Data: $eventData');
      // Implement your save logic here
      Get.back(); // Go back to the previous page after saving
    }
  }
}
