import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:geolocation/core/api/dio/api_service.dart';
import 'package:geolocation/core/api/dio/map_service.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/event/model/event.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventController extends GetxController {

   var events = <Event>[].obs; 
   
  
  
  
   


  static EventController controller = Get.find();
  
  final formKey = GlobalKey<FormBuilderState>();
  final Completer<GoogleMapController> mapController = Completer();
  
  Rx<LatLng> selectedLocation = LatLng(0, 0).obs; // Default LatLng
  RxDouble radius = 50.0.obs; // Default radius in meters
  RxBool isLocationSelected = false.obs;
  RxBool isLocationLoading = false.obs;
  var selectedLocationDetails = ''.obs;
  var placeId = ''.obs;


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

  void setNewLocation(LatLng location) async {
    selectedLocation(location);
    isLocationSelected(true);
    update();
    print('----------------');
    print(selectedLocation);
    print('----------------');

     await  getLocationDetails(location);
  }
 void clearLocation() {
    selectedLocation.value = LatLng(0, 0); // Reset to default LatLng
    isLocationSelected.value = false; // Mark location as unselected
    radius.value = 50.0; // Optionally reset radius to default
    selectedLocationDetails('');
    placeId('');
  }


  Future<void> getLocationDetails(LatLng position) async {

     String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${MapService.MAP_KEY}";

      isLocationLoading(true);
      update();
      var response = await  ApiService.getPublicResource(url);
      response.fold((failure){
          isLocationLoading(false);
          Modal.errorDialog(failure: failure);
      }, (success){
          isLocationLoading(false);
          // print(success.data['----------------------']);
          // print(success.data['results']);
          print('------------------------PLACE');

          selectedLocationDetails(success.data['results'][0]['formatted_address']);
          placeId(success.data['results'][0]['place_id']);
           print(success.data['results'][0]['place_id']);
           print(success.data['results'][0]['formatted_address']);
          print('------------------------END');
      });
     
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
        zoom: 17.999, // Adjust as needed
        tilt: 30,     // Adjust as needed
        bearing: -1000, // Adjust as needed
      );

      // Update selected location and isLocationSelected flag
     
      setNewLocation(position);

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

  

  void setRadius(double newRadius) {
    radius.value = newRadius.roundToDouble();
    update();
  }
void createEvent() async {

 
  if (formKey.currentState?.saveAndValidate() ?? false) {
    if (selectedLocation.value == LatLng(0, 0)) {
      Modal.warning(message: 'Please Select Location First');
      return;
    }

    // Show loading modal
    //  Modal.loading();

    // Prepare event data
    final eventData = formKey.currentState!.value;
    final councilPositionId = AuthController.controller.user.value.defaultPosition?.id;
    final councilId = AuthController.controller.user.value.defaultPosition?.councilId;

   

    if (councilId == null || councilPositionId == null) {
      Get.back(); 
      Modal.errorDialog(message: 'Council ID or Position ID is missing. Please try again.');
      return;
    }

     Map<String, dynamic> data = {
      'council_position_id': councilPositionId,
      'councilId': councilId,
      'title': eventData['title'],
      'description': eventData['description'],
      'latitude': selectedLocation.value.latitude,
      'longitude': selectedLocation.value.longitude,
      'radius': radius.value,
      'map_location': selectedLocationDetails.value,
      'place_id': placeId.value,
      'start_time': (eventData['start_time'] as DateTime).toIso8601String(), // Convert DateTime to String
  'end_time': (eventData['end_time'] as DateTime).toIso8601String(),
    };

    //  print(councilId);
    //  print(councilPositionId);
      print('BEFOR SEND');
      print(data);

  var response = await ApiService.postAuthenticatedResource('councils/${councilId}/events/create', data);
  response.fold((failure){
    print('STATUS CODE ${failure.message}');
    print(failure.statusCode);
    print(failure.exception);
  }, (success){
      print('AFTER SEND------');
      print(success.data);
      print('AFTER SEND------------');
      Modal.success(message: 'Event Created');
  });


   
  } else {
    Modal.warning(message: 'Please fill out all required fields.');
  }
}

   
}
