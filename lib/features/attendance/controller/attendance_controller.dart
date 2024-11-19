import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocation/core/api/dio/api_service.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/attendance/make_attendace_page.dart';
import 'package:geolocation/features/event/model/event.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class AttendanceController extends GetxController {
  static AttendanceController controller = Get.find();

  // Observables
  var isLoading = false.obs;
  RxBool isMapReady = false.obs;
  RxList<Circle> geofenceCircles = <Circle>[].obs;
  RxList<Marker> markers = <Marker>[].obs;
  var selectedItem = Event().obs;

  GoogleMapController? _googleMapController;

  // Map initial position
  CameraPosition get initialPosition => CameraPosition(
        target: LatLng(
          selectedItem.value.latitude?.toDouble() ?? 0.0,
          selectedItem.value.longitude?.toDouble() ?? 0.0,
        ),
        zoom: _getZoomLevel(selectedItem.value.radius?.toDouble() ?? 50),
      );

  // Called when the map is created
  void onMapCreated(GoogleMapController mapController) {
    _googleMapController = mapController;
    setMarker();
    setGeofenceCircle();
    isMapReady(true);
  }

  // Add marker for the event location
  void setMarker() {
    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId('event_location'),
        position: LatLng(
          selectedItem.value.latitude?.toDouble() ?? 0.0,
          selectedItem.value.longitude?.toDouble() ?? 0.0,
        ),
        infoWindow: InfoWindow(
          title: selectedItem.value.title ?? 'Event Location',
          snippet: selectedItem.value.mapLocation ?? '',
        ),
      ),
    );
    update();
  }

  // Add geofence circle for the event location
  void setGeofenceCircle() {
    geofenceCircles.clear();
    geofenceCircles.add(
      Circle(
        circleId: const CircleId('geofence'),
        center: LatLng(
          selectedItem.value.latitude?.toDouble() ?? 0.0,
          selectedItem.value.longitude?.toDouble() ?? 0.0,
        ),
        radius: selectedItem.value.radius?.toDouble() ?? 50,
        fillColor: Palette.PRIMARY.withOpacity(0.2),
        strokeColor: Palette.PRIMARY,
        strokeWidth: 2,
      ),
    );
    update();
  }

  // Check if the user is within the geofence
  Future<void> checkInOrOut() async {
    Position position = await _determinePosition();
    final distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      selectedItem.value.latitude?.toDouble() ?? 0.0,
      selectedItem.value.longitude?.toDouble() ?? 0.0,
    );

    if (distance <= (selectedItem.value.radius?.toDouble() ?? 50)) {
      Get.snackbar('Success', 'You are within the geofence. Attendance marked!');
    } else {
      Get.snackbar('Error', 'You are outside the geofence. Move closer!');
    }
  }

  // Get the user's current position
  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw 'Location services are disabled.';

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied.';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied.';
    }

    return await Geolocator.getCurrentPosition();
  }

  // Refresh event details from API
  Future<void> refreshEventDetails() async {
    isLoading(true);
    update();

    var eventId = selectedItem.value.id;
    var councilId = selectedItem.value.council?.id;

    if (eventId != null) {
      var response = await ApiService.getAuthenticatedResource(
        '/councils/${councilId}/events/$eventId',
      );

      response.fold(
        (failure) {
          isLoading(false);
          Modal.errorDialog(failure: failure);
        },
        (success) {
          isLoading(false);
          selectedItem(Event.fromMap(success.data['data']));
          setMarker();
          setGeofenceCircle();
        },
      );
    }
  }

  // Move Camera to Event Location
  void moveCamera() {
    if (_googleMapController != null) {
      _googleMapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              selectedItem.value.latitude?.toDouble() ?? 0.0,
              selectedItem.value.longitude?.toDouble() ?? 0.0,
            ),
zoom: _getZoomLevel(selectedItem.value.radius?.toDouble()??0.0),
            // zoom: 16,
            // tilt: 30,
          ),
        ),
      );
    }
  }

  // Calculate dynamic zoom level based on radius
  double _getZoomLevel(double radius) {
    double zoomLevel = 16;
    if (radius > 0) {
      double scale = radius / 500;
      zoomLevel = 16 - (log(scale) / log(2.3));
    }
    return zoomLevel.clamp(0.0, 20.0);
  }
  
void selectAndNavigateToAttendancePage(Event item){
    selectedItem(item);
    update();
    Get.to(()=> MakeAttendancePage());

  }
}
