import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SampleMapController extends GetxController {

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
        zoom: 18.999, // Adjust as needed
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


}