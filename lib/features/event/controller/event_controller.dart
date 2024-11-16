import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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
    radius.value = 100.0; // Optionally reset radius to default
    selectedLocationDetails('');
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

  

  void setRadius(double value) {
    radius.value = value;
    update();
  }

  void createEvent() {
    if (formKey.currentState?.saveAndValidate() ?? false) {


      if(selectedLocation.value == null){
        Modal.warning(message: 'Please Select Location First');
        return ;
      }
      final eventData = formKey.currentState?.value;
      var councilPositionId = AuthController.controller.user.value.defaultPosition?.id; 
      print(councilPositionId);
      print(eventData!['title']);
      print(eventData['description']);
      print(eventData['start_time']);
      print(eventData['end_time']);
      print(eventData['radius']);
      return ;
    }

    //  $validatedData = $request->validate([
    //         'council_position_id' => 'required|exists:council_positions,id',
    //         'title' => 'required|string|max:255',
    //         'description' => 'nullable|string',
    //         'content' => 'nullable|string',
    //         'latitude' => 'required|numeric',
    //         'longitude' => 'required|numeric',
    //         'radius' => 'required|numeric',
    //         'start_time' => 'required|date',
    //         'end_time' => 'required|date',
    //         'is_active' => 'sometimes|boolean',
    //         'restrict_event' => 'sometimes|boolean',
    //         'max_capacity' => 'sometimes|nullable|integer|min:1',
    //         'type' => 'required|string',
    //     ]);
  } 


  //MAP


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
          // print(success.data['------------------------PLACE']);
          selectedLocationDetails('----------------------  ');
           print(success.data['results'][0]['formatted_address']);
          // selectedLocationDetails(success.data['results'][0]['formatted_address']);
          selectedLocationDetails('--------------------');
      });
     
  }
}
