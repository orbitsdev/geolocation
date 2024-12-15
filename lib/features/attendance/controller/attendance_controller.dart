import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocation/core/api/dio/api_service.dart';
import 'package:geolocation/core/api/dio/failure.dart';
import 'package:geolocation/core/globalcontroller/device_controller.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:geolocation/core/services/firebase_service.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/attendance/confirm_attendance_page.dart';
import 'package:geolocation/features/attendance/event_attendance_list_page.dart';
import 'package:geolocation/features/attendance/make_attendace_page.dart';
import 'package:geolocation/features/attendance/model/attendance.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/event/model/event.dart';
import 'package:geolocation/features/event/model/event_attendance.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;

class AttendanceController extends GetxController {
  static AttendanceController controller = Get.find();

  // Observables
  var isLoading = false.obs;
  var isUploading = false.obs;
  RxBool isMapReady = false.obs;
  RxBool isWithinRadius = false.obs; // To enable/disable the button
  RxList<Circle> geofenceCircles = <Circle>[].obs;
  RxList<Marker> markers = <Marker>[].obs;

  var selfiePath = ''.obs; // Observable for the selfie path


 Position? currentPosition;  
  LatLng? position;
  Rxn<Position> checkInPosition = Rxn<Position>();
  Rxn<Position> checkOutPosition = Rxn<Position>();

 var uploadProgress = 0.0.obs;
  GoogleMapController? _googleMapController;
  late StreamSubscription<Position> _positionStream;
 CameraPosition? cameraPosition = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );
   // PAGE DATA
  var isPageLoading = false.obs;
  var isScrollLoading = false.obs;
  var page = 1.obs;
  var perPage = 20.obs;
  var lastTotalValue = 0.obs;
  var hasData = false.obs;
  var attendances = <Attendance>[].obs;
  var selectedItem = EventAttendance().obs;

  //for viewing
  var selectedEvent = Event().obs;

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


  Future<void> initializeData(Event event) async {
   
    // Modal.loading();
    isLoading(true); // Set loading to true
    update();

    var response = await ApiService.getAuthenticatedResource(
      '/councils/${event.council?.id}/events/${event.id}/attendance',
    );

    response.fold(
      (failure) {

        // Get.back();
          isLoading(false); // Set loading to false once initialization is complete
         update();
        Modal.errorDialog(failure: failure); // Handle API failure
      },
      (success) async  {
         await prepareMap();
        // Get.back();
        isLoading(false);
         isWithinRadius(false);
          update();
          selectedItem(EventAttendance.fromMap(success.data['data']));
           await calculateInitialDistance(); 
           startListeningToPosition();
          
      },
    );

    // Perform initial distance calculation with the updated data
   
  


  }

Future<void> checkIn() async {
  try {
    // Fetch the current position

    Modal.loading();
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    Get.back();

    // Store the check-in position
    checkInPosition.value = position;

    // Print the position
    print('--- Check-In Location ---');
    print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
    print('--- End Check-In ---');

    // Navigate to Confirm Attendance page
    print('caleed');
    navigateToConfirmPage(position, isCheckIn: true);
  } catch (e) {
        Get.back();
        Modal.showToast(msg: 'Error during check-in: $e');
  }
}

Future<void> checkOut() async {
  try {
    // Fetch the current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Store the check-out position
    checkOutPosition.value = position;

    // Print the position
    print('--- Check-Out Location ---');
    print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
    print('--- End Check-Out ---');

    // Navigate to Confirm Attendance page
    navigateToConfirmPage(position, isCheckIn: false);
  } catch (e) {
    print('Error during check-out: $e');
  }
}

void navigateToConfirmPage(Position position, {required bool isCheckIn}) {

  Get.to(
    () => const ConfirmAttendancePage(),
    transition: Transition.cupertino,
    arguments: {
      'position': position,
      'isCheckIn': isCheckIn,
    },
  );
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


Future<void> calculateInitialDistance() async {
  try {
    // Get the user's current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final double eventLatitude = selectedItem.value.latitude?.toDouble() ?? 0.0;
    final double eventLongitude = selectedItem.value.longitude?.toDouble() ?? 0.0;
    final double radius = selectedItem.value.radius?.toDouble() ?? 50;

    // Calculate the distance
    final double distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      eventLatitude,
      eventLongitude,
    );

    // Determine if the user is within the radius
    isWithinRadius.value = distance <= radius;

    // Print the initial data
    print('-INITIAL CALCULATION------------------------------------');
    print('Current User Coordinates: Latitude: ${position.latitude}, Longitude: ${position.longitude}');
    print('Event Coordinates: Latitude: $eventLatitude, Longitude: $eventLongitude');
    print('Calculated Distance: $distance meters');
    print(isWithinRadius.value
        ? 'User is within the radius of $radius meters.'
        : 'User is outside the radius of $radius meters.');
    print('-END INITIAL CALCULATION--------------------------------');

    update(); // Notify UI changes
  } catch (e) {
    print('Error calculating initial distance: $e');
    Modal.showToast(msg: 'Failed to fetch your location for initial calculation.');
  }
}

  void startListeningToPosition() {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((Position position) {
    


    final double eventLatitude = selectedItem.value.latitude?.toDouble() ?? 0.0;
    final double eventLongitude = selectedItem.value.longitude?.toDouble() ?? 0.0;
    final double radius = selectedItem.value.radius?.toDouble() ?? 50;

    final double distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      eventLatitude,
      eventLongitude,
    );

    isWithinRadius.value = distance <= radius;

    // Print user and event coordinates
    print('-START LESTINING----------------------------------------');
    print('Current User Coordinates: Latitude: ${position.latitude}, Longitude: ${position.longitude}');
    print('Event Coordinates: Latitude: $eventLatitude, Longitude: $eventLongitude');
    print('Calculated Distance: $distance meters');

    // Check and print if within radius
    if (isWithinRadius.value) {
      print('User is within the radius of $radius meters.');
    } else {
      print('User is outside the radius of $radius meters.');
    }

    update(); // Notify UI changes
    print('-END LESTINING----------------------------------------');
  
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
        '/councils/$councilId/events/$eventId/attendance',
      );

      response.fold(
        (failure) {
          isLoading(false);
          Modal.errorDialog(failure: failure);
        },
        (success) {
          isLoading(false);
          selectedItem(EventAttendance.fromMap(success.data['data']));
          setMarker();
          setGeofenceCircle();
        },
      );
    }
  }

void selectAndNavigateToAttendancePage(Event item) async {
   await Get.to(() => MakeAttendancePage(), arguments: {
          'event':item, 
        });
}

// void selectAndNavigateToAttendanceRecord(Event item) async {
//   selectedEvent(item);
//   update();
//    await Get.to(() => AttendanceListPage());
// }



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

  

  // Function to capture a selfie
  Future<void> takeSelfie() async {
    final ImagePicker picker = ImagePicker();

    try {
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        selfiePath.value = image.path; // Update the selfie path
        print('Selfie captured at: ${image.path}');
      } else {
        print('No selfie captured.');
      }
    } catch (e) {
      print('Error capturing selfie: $e');
    }
  }
  Future<void> clearSelfie() async {

  try {
    // Clear the stored selfie path
    selfiePath.value = '';
   
  } catch (e) {
    
  }
}
Future<void> takeAttendance(bool isCheckIn) async {
  try {
    Modal.loading(); // Show loading modal

    // Get the current position for check-in or check-out
    var position = isCheckIn ? checkInPosition.value : checkOutPosition.value;

    // Validate that the position is captured
    if (position == null) {
      Modal.errorDialog(failure: Failure(message: 'Location not captured. Please try again.'));
      return;
    }
    //officer & council data

     var officerId=    AuthController.controller.user.value.defaultPosition?.id;
     var counciId=   AuthController.controller.user.value.defaultPosition?.councilId;
     var eventId=     selectedItem.value.id;

     // device data 
     String? deviceToken = await FirebaseService.getDeviceToken();
      Map<String, dynamic> deviceData = await DeviceController().getDeviceInfo();

      // Map<String, dynamic> deviceData = {
      //   "device_token": deviceToken,
      //   "device_id": deviceData['id'],
      //   "device_name": deviceData['model'],
     
      // };

    // Prepare the FormData for the request
    var data = dio.FormData.fromMap({
      'check_${isCheckIn ? 'in' : 'out'}_coordinates': {
        'latitude': '${position.latitude}',
        'longitude': '${position.longitude}',
      },
      'event_id': selectedItem.value.id,
  'council_position_id': officerId, 
      if (selfiePath.value.isNotEmpty)
        'selfie_image': await dio.MultipartFile.fromFile(
          selfiePath.value,
          filename: '${isCheckIn ? 'check_in' : 'check_out'}_selfie.jpg',
        ),
      "device_id": deviceData['id'],
      "device_name": deviceData['model'],
    });

 print('--- ATTENDANCE DATA ---');
    for (final field in data.fields) {
      print('Field: ${field.key} = ${field.value}');
    }
    for (final file in data.files) {
      print('File: ${file.key} = ${file.value.filename}, Path: ${file.value.filename}');
    }
    print('--- END OF ATTENDANCE DATA ---');


  

 if (data.files.isNotEmpty) {
      isUploading(true); // Only set isUploading to true if a file exists
    }
 update();
    String endpoint = '/councils/${counciId}/events/${eventId}/attendance/${isCheckIn ? 'check-in' : 'check-out'}';

    // Make the API call
    var response = await ApiService.filePostAuthenticatedResource(endpoint, data, onSendProgress: (int sent, int total) {
              uploadProgress.value = sent / total;
              update();
            },);

   
    response.fold(
      (failure) {
         isUploading(false);

          uploadProgress.value = 0.0;
          update();
        Get.back(); // Close loading modal
        Modal.errorDialog(failure: failure); // Show error modal
      },
      (success) {
        print('SUCCESs--------------');
        print(success.data['data']);
        print('SUCCESs-----------------');
          isUploading(false);
          uploadProgress.value = 0.0;
           update();

        Get.back(); // Close loading modal
        Modal.success(message: 'Attendance ${isCheckIn ? 'Check-In' : 'Check-Out'} recorded successfully.');
        // Reset the selfie path and positions
        selfiePath.value = '';
        if (isCheckIn) {
          checkInPosition.value = null;
        } else {
          checkOutPosition.value = null;
        }
        // Navigate back to the events page
        // Get.offNamedUntil('/events', (route) => route.isFirst);

        // if(AuthController.controller.user.value.defaultPosition?.grantAccess == true){
        //       Get.offNamedUntil('/collections', (route) => route.isFirst);
        //         loadData();
        // }{
        //       Get.offNamedUntil('/home-officer', (route) => route.isFirst);
        //       EventController.controller.loadAllPageData();
        // }
Modal.success(message: isCheckIn 
    ? 'Check-In successful! Have a great day ahead.' 
    : 'Check-Out successful! See you next time.');
      },
    );
  } catch (e) {
    Get.back(); // Close loading modal
    Modal.errorDialog(failure: Failure(message: 'An error occurred: $e'));
  }
}




Future<void> testLoad(Event item) async {



  Modal.loading();
  var eventId = item.id;
  var councilId = item.council?.id;
   var endpoint = '/councils/${councilId}/events/${eventId}/attendance-record';



  Map<String, dynamic> queryParameters = {
    'page': page.value,
    'perPage': perPage.value,
  };

  var response = await ApiService.getAuthenticatedResource(
    endpoint,
    queryParameters: queryParameters,
  );

  response.fold(
    (failure) {
      Get.back();
      Modal.errorDialog(failure: failure);
    },
    (success) {
            Get.back();

      print('------------------- ATTENDANCE RECORD');

      Attendance newAttendance = Attendance.fromMap((success.data['data'][0]));
      print(newAttendance.toJson());
      print('-------------------');
     
    },
  );
}
// Future<void> loadData() async {


//   isPageLoading(true);
//   page(1);
//   perPage(20);
//   lastTotalValue(0);
//   attendances.clear();
//   update();

//   var eventId = selectedEvent.value.id;
//   var councilId = selectedEvent.value.council?.id;

//   // Debug the eventId and councilId
//   print("Event ID: $eventId");
//   print("Council ID: $councilId");

//   if (eventId == null || councilId == null) {
//     isPageLoading(false);
//     Modal.errorDialog(message: "Event ID or Council ID is null.");
//     return;
//   }

//   var endpoint = '/councils/$councilId/events/$eventId/attendance-record';
//   // var endpoint = '/councils/28/events/8/attendance-record';

//   Map<String, dynamic> queryParameters = {
//     'page': page.value,
//     'perPage': perPage.value,
//   };

//   var response = await ApiService.getAuthenticatedResource(
//     endpoint,
//     queryParameters: queryParameters,
//   );

//   response.fold(
//     (failure) {
//       isPageLoading(false);
//       update();
//       Modal.errorDialog(failure: failure);
//     },
//     (success) {
//       print('------------------- ATTENDA RECORD');
//       print(success.data['data'][0]['check_out_coordinates']);
//       print('-------------------');
//       var data = success.data;

      

//       List<EventAttendance> newData = (data['data'] as List<dynamic>)
//           .map((record) => EventAttendance.fromMap(record))
//           .toList();

//       attendances(newData);
//       page.value++;
//       lastTotalValue.value = data['pagination']['total'];
//       hasData.value = attendances.length < lastTotalValue.value;
//       isPageLoading(false);
//       update();
//     },
//   );
// }




  
  // void loadOnScroll() async {
  //   if (isScrollLoading.value) return;

  //   isScrollLoading(true);
  //   update();
   
  
  // var eventId = selectedItem.value.id;
  // var councilId = selectedItem.value.council?.id;

  
  // var endpoint = '/councils/$councilId/events/$eventId/attendance-record';

   
  //   Map<String, dynamic> queryParameters = {
  //     'page': page.value,
  //     'perPage': perPage.value,
  //   };


  //   var response = await ApiService.getAuthenticatedResource(endpoint,
  //       queryParameters: queryParameters);
  //   response.fold((failed) {
  //     isScrollLoading(false);
  //     update();
  //     Modal.errorDialog(failure: failed);
  //   }, (success) {
  //     isScrollLoading(false);
  //     update();

  //     var data = success.data;
  //     if (lastTotalValue.value != data['pagination']['total']) {
  //       loadData();
  //       return;
  //     }

  //     if (attendance.length == data['pagination']['total']) {
  //       return;
  //     }

  //     List<Attendance> newData = (data['data'] as List<dynamic>)
  //         .map((task) => Attendance.fromMap(task))
  //         .toList();
  //     attendance.addAll(newData);
  //     page.value++;
  //     lastTotalValue.value = data['pagination']['total'];
  //     hasData.value = attendance.length < lastTotalValue.value;
  //     update();
  //   });
  // }

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

  Future<void> prepareMap() async {
  var localPermission = await requestLocationPermision();
  if (localPermission) {
    try {
      currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      position = LatLng(currentPosition!.latitude, currentPosition!.longitude);
      cameraPosition = CameraPosition(
          target: position as LatLng, zoom: 16.999, tilt: 40, bearing: -1000);
      if (currentPosition != null) {
        isMapReady(true);
      } else {
        isMapReady(false);
        Modal.showToast(msg: 'Failed to get current location.');
      }
    } catch (e) {
      isMapReady(false);
      Modal.errorDialog(message: 'Error accessing GPS: $e');
    }
  } else {
    isMapReady(false);
    Modal.showToast(msg: 'Location permissions are required to load the map.');
  }
  update();
}

//  Future<void> loadAttendance(int eventId) async {
//    isPageLoading(true);
//    page(1);
//    perPage(20);
//    lastTotalValue(0);
//    attendances.clear();
//     update();
    
   
//     Map<String, dynamic> data = {
//       'page':page,
//       'per_page':perPage,
     
//     };

  
  
//     var response = await ApiService.getAuthenticatedResource('councils/events/${eventId}/attendances', queryParameters: data);
//     response.fold((failed) {
//      isPageLoading(false);
//       update();
//       Modal.errorDialog(failure: failed);
//     }, (success) {
//       var data = success.data;  

     
//       print(data);

      
//       List<EventAttendance> newData = (data['data'] as List<dynamic>)
//           .map((task) => EventAttendance.fromMap(task))
//           .toList();
//      attendances(newData);
//      page.value++;
//      lastTotalValue.value = data['pagination']['total'];
//      hasData.value =attendances.length < lastTotalValue.value;
//      isPageLoading(false);
//       update();
      
//     });
//   }

//   void loadAttendanceOnSCroll(int eventId) async {
//     if (isScrollLoading.value) return;

//    isScrollLoading(true);
//     update();

   
    
//     Map<String, dynamic> data = {
//       'page':page,
//       'per_page':perPage,
     
//     };
    
   
//     var response = await ApiService.getAuthenticatedResource('councils/events/${eventId}/attendances', queryParameters: data);
//     response.fold((failed) {
//      isScrollLoading(false);
//       update();
//       Modal.errorDialog(failure: failed);
//     }, (success) {
//      isScrollLoading(false);
//       update();

//       var data = success.data;
//       if (lastTotalValue.value != data['pagination']['total']) {
//         loadAttendance(eventId);
//         return;
//       }

//       if (attendances.length == data['pagination']['total']) {
//         return;
//       }

//       List<EventAttendance> newData = (data['data'] as List<dynamic>)
//           .map((task) => EventAttendance.fromMap(task))
//           .toList();
//      attendances.addAll(newData);
//       page.value++;
//       lastTotalValue.value = data['pagination']['total'];
//       hasData.value =attendances.length <lastTotalValue.value;
//       update();
//     });
//   }
 Future<void> loadMyAttendance() async {
   isPageLoading(true);
   page(1);
   perPage(20);
   lastTotalValue(0);
   attendances.clear();
    update();
    
   
    Map<String, dynamic> data = {
      'page':page,
      'per_page':perPage,
     
    };

  
  
    var response = await ApiService.getAuthenticatedResource('councils/events/my-attendances', queryParameters: data);
    response.fold((failed) {
     isPageLoading(false);
      update();
      Modal.errorDialog(failure: failed);
    }, (success) {
      var data = success.data;  

     
      print(data);

      
      List<Attendance> newData = (data['data'] as List<dynamic>)
          .map((task) => Attendance.fromMap(task))
          .toList();
     attendances(newData);
     page.value++;
     lastTotalValue.value = data['pagination']['total'];
     hasData.value =attendances.length < lastTotalValue.value;
     isPageLoading(false);
      update();
      
    });
  }

  void loadMyAttendanceOnScroll() async {
    if (isScrollLoading.value) return;

   isScrollLoading(true);
    update();

   
    
    Map<String, dynamic> data = {
      'page':page,
      'per_page':perPage,
     
    };
    
   
    var response = await ApiService.getAuthenticatedResource('councils/events/my-attendances', queryParameters: data);
    response.fold((failed) {
     isScrollLoading(false);
      update();
      Modal.errorDialog(failure: failed);
    }, (success) {
     isScrollLoading(false);
      update();

      var data = success.data;
      if (lastTotalValue.value != data['pagination']['total']) {
        loadMyAttendance();
        return;
      }

      if (attendances.length == data['pagination']['total']) {
        return;
      }

      List<Attendance> newData = (data['data'] as List<dynamic>)
          .map((task) => Attendance.fromMap(task))
          .toList();
     attendances.addAll(newData);
      page.value++;
      lastTotalValue.value = data['pagination']['total'];
      hasData.value =attendances.length <lastTotalValue.value;
      update();
    });
  }

}