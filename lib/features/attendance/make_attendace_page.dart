import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class AttendanceController extends GetxController {
  // Observables
  RxBool isMapReady = false.obs;
  RxList<Circle> geofenceCircles = <Circle>[].obs;
  Rx<LatLng> currentPosition = LatLng(0, 0).obs;

  // Map initial position
  CameraPosition initialPosition = const CameraPosition(
    target: LatLng(6.632986, 124.598800), // Default target location
    zoom: 15,
  );

  // Geofence radius and center
  final double geofenceRadius = 50.0; // Example 50 meters
  final LatLng geofenceCenter = LatLng(6.632986, 124.598800); // Example center

  // Called when the map is created
  void onMapCreated(GoogleMapController controller) {
    _initializeGeofence();
    isMapReady(true); // Mark map as ready
  }

  // Initialize Geofence on Map
  void _initializeGeofence() {
    geofenceCircles.add(
      Circle(
        circleId: const CircleId('geofence'),
        center: geofenceCenter,
        radius: geofenceRadius,
        fillColor: Colors.blue.withOpacity(0.2),
        strokeColor: Colors.blue,
        strokeWidth: 2,
      ),
    );
    update(); // Notify UI changes
  }

  // Function to check attendance
  Future<void> checkInOrOut() async {
    Position position = await _determinePosition();

    final distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      geofenceCenter.latitude,
      geofenceCenter.longitude,
    );

    if (distance <= geofenceRadius) {
      Get.snackbar('Success', 'You are within the geofence. Attendance marked!');
      // TODO: Call API to mark attendance
    } else {
      Get.snackbar('Error', 'You are outside the geofence. Move closer!');
    }
  }

  // Helper to get current position
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
