import 'package:geolocation/features/event/model/event.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class AttendanceController extends GetxController {
  var events = <Event>[].obs;
  var attendedEvents = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadEvents();
  }

  void loadEvents() {
    // Load events (from backend or local data)
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
      // More events...
    ]);
  }

  bool isWithinGeofence(Event event) {
    // Calculate distance between user's current location and event location
    // This example assumes you have the current location available as a `Position` object.
    Position? currentPosition;
    // Mock current position for demonstration:
    currentPosition = Position(
      headingAccuracy:21 ,
      altitudeAccuracy: 21,
  latitude: 37.42796133580664,
  longitude: -122.085749655962,
  timestamp: DateTime.now(),
  altitude: 0.0,
  accuracy: 0.0,
  heading: 0.0,
  speed: 0.0,
  speedAccuracy: 0.0,
);

    if (currentPosition == null) return false;

    double distanceInMeters = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      event.latitude,
      event.longitude,
    );

    return distanceInMeters <= event.radius;
  }

  void markAttendance(Event event) {
    if (!attendedEvents.contains(event.id)) {
      attendedEvents.add(event.id);
      // Save attendance to backend or local storage
    }
  }

  bool hasMarkedAttendance(Event event) {
    return attendedEvents.contains(event.id);
  }
}
