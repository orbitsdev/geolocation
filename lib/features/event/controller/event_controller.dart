import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:geolocation/core/api/dio/api_service.dart';
import 'package:geolocation/core/api/dio/map_service.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/event/create_event_page.dart';
import 'package:geolocation/features/event/model/event.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventController extends GetxController {
  static EventController controller = Get.find();

  final formKey = GlobalKey<FormBuilderState>();
  final Completer<GoogleMapController> mapController = Completer();
  GoogleMapController? googleMapController;

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

  // PAGE DATA
  var isLoading = false.obs;
  var isScrollLoading = false.obs;
  var page = 1.obs;
  var perPage = 20.obs;
  var lastTotalValue = 0.obs;
  var hasData = false.obs;
  var events = <Event>[].obs;
  var selectedItem = Event().obs;

  Marker? locationMarker;
  Circle? radiusCircle;
  Set<Circle> circles = {};
  Set<Marker> markers = {};

  @override
  void onInit() {
    super.onInit();
    setCameraPositionToMyCurrentPosition(); // Automatically set the camera position to the user's current location
  }

  void selectItemAndNavigateToUpdatePage(Event item) async {
    clearData();

    selectedItem(item);
    update();

    await Get.to(()=> CreateEventPage(isEditMode: true),transition: Transition.cupertino);
  }

  void selectItem(Event item){
    selectedItem(item);
    update();
  }

  void fillForm() {
     WidgetsBinding.instance.addPostFrameCallback((_) {
      
  selectedLocation.value = LatLng(
    selectedItem.value.latitude?.toDouble() ?? 0.0,
    selectedItem.value.longitude?.toDouble() ?? 0.0,
  );
  isLocationSelected(true);
  
  if (selectedItem.value.radius != null) {
    radius.value = selectedItem.value.radius!.toDouble();
  }

  
  selectedLocationDetails.value = selectedItem.value.mapLocation ?? '';
  placeId.value = selectedItem.value.placeId ?? '';

 
 controller.formKey.currentState?.patchValue({
  'title': selectedItem.value.title,
  'description': selectedItem.value.description,
  'start_time': selectedItem.value.startTime != null ? DateTime.parse(selectedItem.value.startTime!): null,
  'end_time': selectedItem.value.endTime != null ? DateTime.parse(selectedItem.value.endTime!) : null,
});

 markers = {
    Marker(
      markerId: MarkerId('selected-location'),
      position: selectedLocation.value,
    ),
  };

  circles = {
    Circle(
      circleId: CircleId('selected-radius'),
      center: selectedLocation.value,
      radius: radius.value,
      fillColor: Palette.PRIMARY.withOpacity(0.2),
      strokeColor: Palette.PRIMARY,
      strokeWidth: 2,
    ),
  };

  update();
     });
  
  
}

  void setNewLocation(LatLng location) async {
    selectedLocation(location);
    isLocationSelected(true);
    
     markers = {
    Marker(
      markerId: MarkerId('selected-location'),
      position: location,
    ),
  };

  circles = {
    Circle(
      circleId: CircleId('selected-radius'),
      center: location,
      radius: radius.value,
      fillColor: Palette.PRIMARY.withOpacity(0.2),
      strokeColor: Palette.PRIMARY,
      strokeWidth: 2,
    ),
  };

  update();

    await getLocationDetails(location);
  }

  void clearLocation() {
    selectedLocation.value = LatLng(0, 0); 
    isLocationSelected.value = false; 
    radius.value = 50.0; 

  markers.clear();
  circles.clear();
    selectedLocationDetails('');
    placeId('');
    update();
  }

  Future<void> getLocationDetails(LatLng position) async {
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${MapService.MAP_KEY}";

    isLocationLoading(true);
    update();
    var response = await ApiService.getPublicResource(url);
    response.fold((failure) {
      isLocationLoading(false);
      Modal.errorDialog(failure: failure);
    }, (success) {
      isLocationLoading(false);
      update();
      // print(success.data['----------------------']);
      // print(success.data['results']);
      print('------------------------PLACE');

      selectedLocationDetails(success.data['results'][0]['formatted_address']);
      placeId(success.data['results'][0]['place_id']);
      print(success.data['results'][0]['place_id']);
      print(success.data['results'][0]['formatted_address']);
      print('------------------------END');

      moveCamera(position);
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
      print(
          'Location permissions are permanently denied, we cannot request permissions.');
      return;
    }

    // If permissions are granted, get the current position
    try {
      currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Set the map's target position based on the current position
      LatLng position =
          LatLng(currentPosition!.latitude, currentPosition!.longitude);

      // Update camera position
      cameraPosition = CameraPosition(
        target: position,
        zoom: 17.999, // Adjust as needed
        tilt: 30, // Adjust as needed
        bearing: -1000, // Adjust as needed
      );

      // Update selected location and isLocationSelected flag

      setNewLocation(position);

      // Animate the map's camera to the new position
      googleMapController = await mapController.future;
      googleMapController?.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition!),
      );
    } catch (e) {
      // Handle any errors (e.g., location unavailable)
      print('Error setting camera position: $e');
    }
  }

  void moveCamera(LatLng position) async {
    cameraPosition = CameraPosition(
      target: position as LatLng, zoom: 17.999, // Adjust as needed
      tilt: 30, // Adjust as needed
      bearing: -1000,
    );
    googleMapController = await mapController.future;
    googleMapController?.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition as CameraPosition),
    );
    update();
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
      final councilPositionId =
          AuthController.controller.user.value.defaultPosition?.id;
      final councilId =
          AuthController.controller.user.value.defaultPosition?.councilId;

      if (councilId == null || councilPositionId == null) {
        Get.back();
        Modal.errorDialog(
            message: 'Council ID or Position ID is missing. Please try again.');
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
        'start_time': (eventData['start_time'] as DateTime)
            .toIso8601String(), // Convert DateTime to String
        'end_time': (eventData['end_time'] as DateTime).toIso8601String(),
      };

      print('BEFOR SEND');
      print(data);

      var response = await ApiService.postAuthenticatedResource(
          'councils/${councilId}/events/create', data);
      response.fold((failure) {
        print('STATUS CODE ${failure.message}');
        print(failure.statusCode);
        print(failure.exception);
        Modal.errorDialog(failure: failure);
      }, (success) {
         clearData();
          Get.offNamedUntil('/events', (route) => route.isFirst);
        Modal.success(message: 'Event Created',);
      });
    } else {
      Modal.warning(message: 'Please fill out all required fields.');
    }
  }

  void clearData() {
      WidgetsBinding.instance.addPostFrameCallback((_) {

    formKey.currentState?.reset();
    clearLocation();
    update();
      });
  }

  // PAGE

  Future<void> loadEvents() async {
    isLoading(true);
    page(1);
    perPage(20);
    lastTotalValue(0);
    events.clear();
    update();
    update();
    var councilId =
        AuthController.controller.user.value.defaultPosition?.councilId;
    Map<String, dynamic> data = {
      'page': page,
      'per_page': perPage,
      'councilId': councilId,
    };

    print(data);

    var response = await ApiService.getAuthenticatedResource(
        'councils/${councilId}/events',
        queryParameters: data);
    response.fold((failed) {
      isLoading(false);
      update();
      Modal.errorDialog(failure: failed);
    }, (success) {
      var data = success.data;

      List<Event> newData = (data['data'] as List<dynamic>)
          .map((task) => Event.fromMap(task))
          .toList();
      events(newData);
      page.value++;
      lastTotalValue.value = data['pagination']['total'];
      hasData.value = events.length < lastTotalValue.value;
      isLoading(false);
      update();
    });
  }

  void loadOnScroll() async {
    if (isScrollLoading.value) return;

    isScrollLoading(true);
    update();
    var councilId =
        AuthController.controller.user.value.defaultPosition?.councilId;
    Map<String, dynamic> data = {
      'page': page,
      'per_page': perPage,
      'councilId': councilId,
    };

    var response = await ApiService.getAuthenticatedResource(
        'councils/${councilId}/events',
        queryParameters: data);
    response.fold((failed) {
      isScrollLoading(false);
      update();
      Modal.errorDialog(failure: failed);
    }, (success) {
      isScrollLoading(false);
      update();

      var data = success.data;
      if (lastTotalValue.value != data['pagination']['total']) {
        loadEvents();
        return;
      }

      if (events.length == data['pagination']['total']) {
        return;
      }

      List<Event> newData = (data['data'] as List<dynamic>)
          .map((task) => Event.fromMap(task))
          .toList();
      events.addAll(newData);
      page.value++;
      lastTotalValue.value = data['pagination']['total'];
      hasData.value = events.length < lastTotalValue.value;
      update();
    });
  }

  Future<void> delete(int id) async {
    Modal.confirmation(
      titleText: "Confirm Delete",
      contentText:
          "Are you sure you want to delete this task? This action cannot be undone.",
      onConfirm: () async {
        final councilId =
            AuthController.controller.user.value.defaultPosition?.councilId;
        Modal.loading(content: const Text('Deleting record...'));
        var response = await ApiService.deleteAuthenticatedResource(
          '/councils/${councilId}/events/${id}',
        );

        response.fold(
          (failure) {
            Get.back(); // Close the modal
            Modal.errorDialog(failure: failure);
          },
          (success) {
            Get.back(); // Close the modal
            events.removeWhere((t) => t.id == id);
            update();
            Modal.success(message: 'Task deleted successfully!');
          },
        );
      },
      onCancel: () {
        Get.back();
      },
    );
  }

  void updateEvent() async {
  if (formKey.currentState?.saveAndValidate() ?? false) {
    if (selectedLocation.value == LatLng(0, 0)) {
      Modal.warning(message: 'Please Select Location First');
      return;
    }

    final eventData = formKey.currentState!.value;

    Map<String, dynamic> data = {
      'title': eventData['title'],
      'description': eventData['description'],
      'latitude': selectedLocation.value.latitude,
      'longitude': selectedLocation.value.longitude,
      'radius': radius.value,
      'map_location': selectedLocationDetails.value,
      'place_id': placeId.value,
      'start_time': (eventData['start_time'] as DateTime).toIso8601String(),
      'end_time': (eventData['end_time'] as DateTime).toIso8601String(),
    };

    Modal.loading(content: const Text('Updating event...'));
  var eventId = selectedItem.value.id;
    var response = await ApiService.putAuthenticatedResource(
      '/councils/${AuthController.controller.user.value.defaultPosition?.councilId}/events/$eventId',
      data,
    );

    response.fold(
      (failure) {
        Get.back(); // Close modal
        Modal.errorDialog(failure: failure);
      },
      (success) {
        clearData();
        Get.back(); // Close modal
        Modal.success(message: 'Event updated successfully');
        Get.offNamedUntil('/events', (route) => route.isFirst);
      },
    );
  } else {
    Modal.warning(message: 'Please fill out all required fields.');
  }
}

}
