import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:geolocation/core/api/dio/api_service.dart';
import 'package:geolocation/core/api/dio/map_service.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/attendance/event_attendance_list_page.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/collections/controller/collection_controller.dart';
import 'package:geolocation/features/event/create_event_page.dart';
import 'package:geolocation/features/event/event_details_page.dart';
import 'package:geolocation/features/event/model/event.dart';
import 'package:geolocation/features/post/controller/post_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class EventController extends GetxController {
  static EventController controller = Get.find();

  final formKey = GlobalKey<FormBuilderState>();
  final Completer<GoogleMapController> mapController = Completer();
  GoogleMapController? googleMapController;

  Rx<LatLng> selectedLocation = LatLng(0, 0).obs; // Default LatLng
  RxDouble radius = 10.0.obs; // Default radius in meters
  RxBool isLocationSelected = false.obs;
  RxBool isLocationLoading = false.obs;
  var selectedLocationDetails = ''.obs;
  var placeId = ''.obs;

  Position? currentPosition;  
  LatLng? position;
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
final DateFormat readableDateFormat = DateFormat('EEEE, MMMM d, yyyy, h:mm a');
  Marker? locationMarker;
  Circle? radiusCircle;
  Set<Circle> circles = {};
  Set<Marker> markers = {};
  RxBool isMapReady = false.obs;

    var isPublish = true.obs; // Default to true
  
  @override
  void onInit() {
    super.onInit();
    
  }

  Future<void> prepareMap() async {


    var localpermission = await requestLocationPermision();
    if (localpermission) {
      try {
        currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        position =LatLng(currentPosition!.latitude, currentPosition!.longitude);
        cameraPosition = CameraPosition(
            target: position as LatLng, zoom: 16.999, tilt: 40, bearing: -1000);
        if (currentPosition != null) {
          isMapReady( true);
          update();
        } else {
           isMapReady( false);
          update();
        }
      } catch (e) {
         isMapReady( false);
          update();
        
      }
    } else {
      isMapReady( false);
          update();
      
    }

  }

  Future<bool> requestLocationPermision() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return serviceEnabled;
  }

 void setMapReady() {
    isMapReady(true);
    update();
  }

 void viewEvent(Event item){
    selectedItem(item);
    update();
    Get.to(()=> EventDetailsPage(), transition: Transition.cupertino);
 }
  void resetMapReady() {
    isMapReady(false);
    update();
  }

  void selectItemAndNavigateToUpdatePage(Event item) async {
  
   selectedItem(item);
  update(); 

  print('VALUE WHEN SELECT');
  print(selectedItem.value); // Debug print to check the selected item
  print('VALUE WHEN SELECT-----------------');

  await Get.to(() => CreateEventPage(), arguments: {
    'event': item,
    'isEditMode': true, // Set this flag to indicate edit mode
  }, transition: Transition.cupertino);
  }

  

  

  void fillForm() {
  print('---------------VALUE IN FILE FORM BEFORE FILL---------------');
  print(selectedItem.value);
  print('---------------');

  WidgetsBinding.instance.addPostFrameCallback((_) {
    LatLng eventOldLocation = LatLng(
      selectedItem.value.latitude?.toDouble() ?? 0.0,
      selectedItem.value.longitude?.toDouble() ?? 0.0,
    );

  print('---------------VALUE OLD VALUE---------------');
    print('Old Location: $eventOldLocation');
   
     setLocation(eventOldLocation); // This sets marker, circle, and updates location
    selectedLocation.value = eventOldLocation;
    selectedLocationDetails.value = selectedItem.value.mapLocation ?? '';
    placeId.value = selectedItem.value.placeId ?? '';

    
    if (selectedItem.value.radius != null) {
      radius.value = selectedItem.value.radius!.toDouble(); 
      setCircle(eventOldLocation); 
    }

    DateTime? startTime;
    DateTime? endTime;
    try {
      if (selectedItem.value.startTime != null) {
        startTime = readableDateFormat.parse(selectedItem.value.startTime!);
      }
      if (selectedItem.value.endTime != null) {
        endTime = readableDateFormat.parse(selectedItem.value.endTime!);
      }
    } catch (e) {
      print('Error parsing date: $e');
    }

    formKey.currentState?.patchValue({
      'title': selectedItem.value.title,
      'description': selectedItem.value.description,
      'start_time': startTime,
      'end_time': endTime,
      'is_publish': selectedItem.value.isPublish ?? false,
      'is_active': selectedItem.value.isActive ?? false,
      'restrict_event': selectedItem.value.restrictEvent ?? false,
      
    });

    moveCamera(eventOldLocation); // Move the camera to the selected event's location
    update(); // Ensure all bound UI components update with the latest values
  });
}



  void setLocation(LatLng location) async {
    selectedLocation(location);
    isLocationSelected(true);
    print('-------------------------- TAP');
    print('${location}');
    print('--------------------------');
    setMarkers(location);
    setCircle(location);
    moveCamera(location);
    update();
    getLocationDetails(location);
  }

  void setMarkers(LatLng location) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
markers.clear();
    markers.add(Marker(
      markerId: MarkerId('selected-location'),
      position: location,
    ));

    // update();
    });
    

  }

  void setCircle(LatLng location,) async {
     WidgetsBinding.instance.addPostFrameCallback((_) {
     circles.clear();
     circles.add(Circle(
      circleId: CircleId('selected-radius'),
      center: location,
      radius: radius.value,
      fillColor: Palette.PRIMARY.withOpacity(0.2),
      strokeColor: Palette.PRIMARY,
      strokeWidth: 2,
    ));
    // update();
     });
  }


  void setRadius(double newRadius) {
     WidgetsBinding.instance.addPostFrameCallback((_) {
     radius.value = newRadius.roundToDouble();
    setCircle(selectedLocation.value);
    update();
     });
   
  }
 void moveCamera(LatLng position) async {
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    cameraPosition = CameraPosition(
      target: position,
      zoom: 17.999,
      tilt: 30,
      bearing: -1000,
    );

    if (googleMapController == null) {
      googleMapController = await mapController.future;
    }

    if (googleMapController != null) {
      googleMapController?.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition!),
      );
    } else {
      print("GoogleMapController is not initialized yet.");
    }
  });
}


  Future<void> clearData({bool resetSelectedItem = false}) async {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    formKey.currentState?.reset();
    markers.clear();
    circles.clear();
    isLocationSelected.value = false;
    radius.value = 10.0;
    selectedLocationDetails('');
    placeId('');


    update();
  });


  }



  Future<void> getLocationDetails(LatLng position) async {

    if(position != LatLng(0, 0));
    print('GETL LOCATION DEATAILS  ---------------------------------------------|-');
    print(position);
  String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${MapService.MAP_KEY}";

  isLocationLoading(true);
  update();

  var response = await ApiService.getPublicResource(url);
  response.fold((failure) {
    isLocationLoading(false);
    update();
    Modal.errorDialog(failure: failure);
  }, (success) {
    isLocationLoading(false);
   

    var results = success.data['results'];
    print(results);
   
    if (results != null && results.isNotEmpty) {
      selectedLocationDetails(results[0]['formatted_address'] ?? 'Unknown Address');
      placeId(results[0]['place_id'] ?? 'Unknown Place ID');
    } else {
      // Handle the case where no results are returned
      selectedLocationDetails('Unknown Address');
      placeId('Unknown Place ID');
      Modal.warning(message: 'No location details found for this position.');
    }

    update();
  });
    print('LCOATION DEATILS POSITONS -------------------------------------------------');
}


  Future<void> setCameraPositionToMyCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {

      print('Location services are disabled.');
      return;
    }

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

      
      LatLng position =LatLng(currentPosition!.latitude, currentPosition!.longitude);

      
       setLocation(position);

     
    } catch (e) {
      
      print('Error setting camera position: $e');
    }
  }

  

  void createEvent() async {
    if (formKey.currentState?.saveAndValidate() ?? false) {
      if (selectedLocation.value == LatLng(0, 0)) {
        Modal.warning(message: 'Please Select Location First');
        return;
      }

    
      Modal.loading();

    
      final eventData = formKey.currentState!.value;
      final councilPositionId = AuthController.controller.user.value.defaultPosition?.id;
      final councilId = AuthController.controller.user.value.defaultPosition?.councilId;

      if (councilId == null || councilPositionId == null) {
        Get.back();
        Modal.errorDialog( message: 'Council ID or Position ID is missing. Please try again.');
        return;
      }

      Map<String, dynamic> data = {
        'council_position_id': councilPositionId,
        'councilId': councilId,
        'title': eventData['title'],
        'description': eventData['description'],
        // 'latitude': '6.632762066900767',
        // 'longitude': '124.59982473403215',
        'latitude': '${selectedLocation.value.latitude}',
        'longitude': '${selectedLocation.value.longitude}',
        'radius': '${radius.value}',
        'map_location': selectedLocationDetails.value,
        'place_id': placeId.value,
        'is_publish': eventData['is_publish'] ?? true,
        'is_active': eventData['is_active'] ?? true,
        'restrict_event': eventData['restrict_event'] ?? false,
        'start_time': (eventData['start_time'] as DateTime) .toIso8601String(), // Convert DateTime to String
        'end_time': (eventData['end_time'] as DateTime).toIso8601String(),
      };

      print('BEFORE SEND------------------------');
      print(data);
      print('BEFORE SEND--------------------------------------');

      var response = await ApiService.postAuthenticatedResource(
          'councils/${councilId}/events/create', data);
      response.fold((failure) {
        Get.back();
        Modal.errorDialog(failure: failure);
      }, (success) {
        Get.back();
        // print(success.data);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.back();
            clearData();
          
            Get.offNamedUntil('/events', (route) => route.isFirst);
            Modal.success(message: 'Event Created',);
              });
                loadEvents();
       
      });
    } else {
      Modal.warning(message: 'Please fill out all required fields.');
    }
  }


  Future<void> loadEvents() async {
   
    isLoading(true);
    page(1);
    perPage(20);
    lastTotalValue(0);
    events.clear();
    update();
    var councilId = AuthController.controller.user.value.defaultPosition?.councilId;
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

      
          print('event event------------load');
          print(events.length);

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

    if (radius.value <= 0 || selectedLocationDetails.value.isEmpty) {
      Modal.warning(message: 'Please set a valid radius and location.');
      return;
    }

    var eventId = selectedItem.value.id;
    if (eventId == null) {
      Modal.errorDialog(message: 'Invalid event selected. Please try again.');
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
      'is_publish': eventData['is_publish'] ?? true,
      'is_active': eventData['is_active'] ,
      'restrict_event': eventData['restrict_event'] ?? true,
      'start_time': (eventData['start_time'] as DateTime).toIso8601String(),
      'end_time': (eventData['end_time'] as DateTime).toIso8601String(),
    };

    print('-----------------UPDATED VALUE');
    print(data);
    print('-----------------UPDATED VALUE');
    print(updateEvent);
    Modal.loading(content: const Text('Updating event...'));

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
         WidgetsBinding.instance.addPostFrameCallback((_) {

        Get.back();
      
        clearData(); // Optional: Clear data only if navigating away
         
        Get.offNamedUntil('/events', (route) => route.isFirst);
        Modal.success(message: 'Event Updated');
         loadEvents();
         });
      },
    );
  } else {
    Modal.warning(message: 'Please fill out all required fields.');
  }
}

Future<void> refreshEventDetails() async {
      isLoading(true);
      update();
      var eventId = selectedItem.value.id;
      var councilId = selectedItem.value.council?.id;

      if(eventId != null){
        var response = await ApiService.getAuthenticatedResource(
      '/councils/${councilId}/events/$eventId',
   
    );

    response.fold(
      (failure) {
     isLoading(false);
      update();
        Modal.errorDialog(failure: failure);
      },
      (success) {
          isLoading(false);
          selectedItem(Event.fromMap(success.data['data']));
          update();
 
      },
    );
      }
     
}

Future<void> loadAllPageData()  async {
 
     await Future.wait([
        EventController.controller.loadEvents(),
        PostController.controller.loadData(),
         CollectionController.controller.loadData(),
        // TaskController.controller.loadTask(),
      ]);
  } 


Future<void> showCurrentLocation() async {
  try {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {   
      Modal.showToast(msg: "Location services are disabled. Please enable them.");
      return;
    }

    // Check and request location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Modal.showToast(msg: "Location permission denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Modal.showToast(msg: "Location permissions are permanently denied. Please enable them from settings.");
      return;
    }

    // Fetch the user's current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Debugging to check the fetched location
    print("Current Location: Latitude: ${position.latitude}, Longitude: ${position.longitude}");

    // Location is fetched, and the blue dot will be displayed because `myLocationEnabled: true`
  } catch (e) {
    Modal.showToast(msg: "Failed to fetch your location: $e");
  }
}

Future<bool> checkLocationServicesAndPermissions() async {
  // Check if location services are enabled
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await Get.dialog(
      AlertDialog(
        title: Text("Location Services Disabled"),
        content: Text("Location services are turned off. Please enable them to proceed."),
        actions: [
          TextButton(
            onPressed: () {
              Geolocator.openLocationSettings(); // Open location settings
              Get.back(); // Close dialog
            },
            child: Text("Enable"),
          ),
          TextButton(
            onPressed: () => Get.back(), // Close dialog
            child: Text("Cancel"),
          ),
        ],
      ),
    );
    return false;
  }

  // Check location permissions
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      Modal.showToast( msg:  "Permission Denied",);
       
       
      return false;
    }
  }

  if (permission == LocationPermission.deniedForever) {
     Modal.showToast( msg:  "Location permissions are permanently denied. Please enable them in settings.",);
   
    await Geolocator.openAppSettings();
    return false;
  }

  return true; // All checks passed
}

}
