import 'dart:async';
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
  RxBool isWithinRadius = false.obs; // To enable/disable the button
  RxList<Circle> geofenceCircles = <Circle>[].obs;
  RxList<Marker> markers = <Marker>[].obs;
  var selectedItem = Event().obs;

  GoogleMapController? _googleMapController;
  late StreamSubscription<Position> _positionStream;

  @override
  void onInit() {
    super.onInit();
    _requestLocationPermission(); // Check permissions
  }

  @override
  void onClose() {
    _positionStream.cancel();
    super.onClose();
  }

  // Request location permissions and start location updates
  Future<void> _requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Error', 'Location services are disabled. Please enable them.');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Permission Denied', 'Location permission is required.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('Permission Denied Forever',
          'Location permissions are permanently denied. Please enable them in settings.');
      return;
    }

    startListeningToPosition(); // Start position updates
  }

  void startListeningToPosition() {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((Position position) {
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        selectedItem.value.latitude?.toDouble() ?? 0.0,
        selectedItem.value.longitude?.toDouble() ?? 0.0,
      );

      isWithinRadius.value = distance <= (selectedItem.value.radius?.toDouble() ?? 50);
      update();
    });
  }

  // Map initial position
  CameraPosition get initialPosition => CameraPosition(
        target: LatLng(
          selectedItem.value.latitude?.toDouble() ?? 0.0,
          selectedItem.value.longitude?.toDouble() ?? 0.0,
        ),
        zoom: _getZoomLevel(selectedItem.value.radius?.toDouble() ?? 50),
      );

  void onMapCreated(GoogleMapController mapController) {
    _googleMapController = mapController;
    setMarker();
    setGeofenceCircle();
    isMapReady(true);
    update();
  }

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

  void moveCamera() {
    if (_googleMapController != null && isMapReady.isTrue) {
      _googleMapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              selectedItem.value.latitude?.toDouble() ?? 0.0,
              selectedItem.value.longitude?.toDouble() ?? 0.0,
            ),
            zoom: _getZoomLevel(selectedItem.value.radius?.toDouble() ?? 50),
          ),
        ),
      );
    }
  }

  Future<void> refreshEventDetails() async {
    isLoading(true);
    update();

    var eventId = selectedItem.value.id;
    var councilId = selectedItem.value.council?.id;

    if (eventId != null) {
      var response = await ApiService.getAuthenticatedResource(
        '/councils/$councilId/events/$eventId',
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

 void selectAndNavigateToAttendancePage(Event item) {
  Get.to(() => MakeAttendancePage(), arguments: item);
}



  double _getZoomLevel(double radius) {
    double zoomLevel = 16;
    if (radius > 0) {
      double scale = radius / 500;
      zoomLevel = 16 - (log(scale) / log(2.3));
    }
    return zoomLevel.clamp(0.0, 20.0);
  }

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
      Get.snackbar('Error', 'You are outside the geofence.');
    }
  }

  Future<Position> _determinePosition() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
