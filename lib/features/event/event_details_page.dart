import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/map_loading.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/event/controller/event_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

class EventDetailsPage extends StatefulWidget {
  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  var controller = Get.find<EventController>();


  @override
  void initState() {
    super.initState();
    controller.prepareMap();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Event Details'),
        
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Get.find<EventController>().refreshEventDetails();
        },
        child: GetBuilder<EventController>(
          builder: (controller) {
            return controller.isMapReady == true? controller.isLoading.value
                ? Center(child: MapLoading())
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Map Section
                        Stack(
                          children: [
                            Container(
                              height: 400,
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: GoogleMap(
                                  mapToolbarEnabled: true,
                                  myLocationEnabled: true,
                                  myLocationButtonEnabled: true,
                                  
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                      controller.selectedItem.value.latitude?.toDouble() ?? 0.0,
                                      controller.selectedItem.value.longitude?.toDouble() ?? 0.0,
                                    ),
                                    zoom: _getZoomLevel(controller.selectedItem.value.radius?.toDouble() ?? 50),
                                  ),
                                  onMapCreated: (GoogleMapController mapController) {
                                    _moveToFitBounds(controller, mapController);
                                  },
                                  markers: {
                                    Marker(
                                      markerId: MarkerId('event_location'),
                                      position: LatLng(
                                        controller.selectedItem.value.latitude?.toDouble() ?? 0.0,
                                        controller.selectedItem.value.longitude?.toDouble() ?? 0.0,
                                      ),
                                      infoWindow: InfoWindow(
                                        title: controller.selectedItem.value.mapLocation ?? 'Event Location',
                                        snippet: 'Radius: ${controller.selectedItem.value.radius?.toStringAsFixed(2)} m',
                                      ),
                                    ),
                                  },
                                  circles: {
                                    Circle(
                                      circleId: CircleId('event_radius'),
                                      center: LatLng(
                                        controller.selectedItem.value.latitude?.toDouble() ?? 0.0,
                                        controller.selectedItem.value.longitude?.toDouble() ?? 0.0,
                                      ),
                                      radius: controller.selectedItem.value.radius?.toDouble() ?? 50,
                                      fillColor: Palette.PRIMARY.withOpacity(0.2),
                                      strokeColor: Palette.PRIMARY,
                                      strokeWidth: 2,
                                    ),
                                  },
                                  zoomGesturesEnabled: true,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 24,
                              right: 24,
                              child: FloatingActionButton.small(
                                backgroundColor: Colors.white,
                                child: Icon(Icons.my_location, color: Palette.PRIMARY),
                                onPressed: () {
                                  Get.find<EventController>().refreshEventDetails();
                                },
                              ),
                            ),
                          ],
                        ),

                        // Event Details Section
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0 ,vertical: 16),
                           decoration: BoxDecoration(
                    color: Palette.LIGHT_BACKGROUND,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        width: 0.2, color: Palette.PRIMARY.withOpacity(0.80))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Description Section
                              Text(
                                'About Event',
                                style: Get.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                controller.selectedItem.value.description ?? 'No description available.',
                                style: Get.textTheme.bodyMedium,
                              ),
                              SizedBox(height: 24),
                                                    
                              // Start Date and End Date Section
                              Row(
                                children: [
                                  Icon(Icons.calendar_today, size: 34, color: Palette.PRIMARY),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${controller.selectedItem.value.startTime ?? 'Start Time'} - ${controller.selectedItem.value.endTime ?? 'End Time'}',
                                      style: Get.textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                                                    
                              // Map Location Section
                              Row(
                                children: [
                                  Icon(Icons.location_on, size: 34, color: Palette.PRIMARY),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      controller.selectedItem.value.mapLocation ?? 'Location not available',
                                      style: Get.textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      Gap(Get.size.height * 0.10),
                      ],
                    ),
                  ): Container();
          },
        ),
      ),
    );
  } 

  void _moveToFitBounds(EventController controller, GoogleMapController mapController) {
    if (controller.selectedItem.value.latitude != null &&
        controller.selectedItem.value.longitude != null) {
      final LatLng eventLocation = LatLng(
        controller.selectedItem.value.latitude!.toDouble(),
        controller.selectedItem.value.longitude!.toDouble(),
      );
      final double radius = controller.selectedItem.value.radius?.toDouble() ?? 50;

      // Calculate bounds based on radius
      final bounds = _calculateBounds(eventLocation, radius);
      mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    }
  }

  LatLngBounds _calculateBounds(LatLng center, double radius) {
    double latAdjustment = radius / 111320; // ~1 degree latitude per 111km
    double lngAdjustment = radius / (111320 * cos(center.latitude * pi / 180));
    return LatLngBounds(
      southwest: LatLng(center.latitude - latAdjustment, center.longitude - lngAdjustment),
      northeast: LatLng(center.latitude + latAdjustment, center.longitude + lngAdjustment),
    );
  }

  double _getZoomLevel(double radius) {
    double zoomLevel = 16; // Default zoom level
    if (radius > 0) {
      double scale = radius / 500; // Adjust scale factor if needed
      zoomLevel = 16 - (log(scale) / log(2)); // Logarithmic scale for zoom
    }
    return zoomLevel.clamp(0.0, 20.0); // Ensure zoom level stays within valid bounds
  }
}
