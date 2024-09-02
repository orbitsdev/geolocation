import 'package:flutter/material.dart';
import 'package:geolocation/core/theme/game_pallete.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/event/controller/event_controller.dart';
import 'package:geolocation/features/event/create_event_page.dart';
import 'package:geolocation/features/event/event_details_page.dart';
import 'package:geolocation/features/event/model/event.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


class EventPage extends StatelessWidget {
  final EventController controller = Get.find<EventController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Upcoming Events',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Palette.PRIMARY),
            onPressed: () {
              // Navigate to the event creation page
              Get.to(() => CreateEventPage());
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.events.isEmpty) {
          return Center(
            child: Text(
              'No events available.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.all(16),
              sliver: SliverMasonryGrid.count(
                crossAxisCount: 1, // Cross-axis count set to 1 for a list-like appearance
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                childCount: controller.events.length,
                itemBuilder: (context, index) {
                  final event = controller.events[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to the event detail page
                      Get.to(() => EventDetailPage(event: event));
                    },
                    child: _buildEventCard(event),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildEventCard(Event event) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Palette.PRIMARY, Palette.DARK_PRIMARY],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Icon or Image
          Icon(
            Icons.event,
            color: Colors.white,
            size: 36,
          ),
          SizedBox(height: 16),

          // Event Title
          Text(
            event.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),

          // Event Date
          Text(
            'Date: ${event.date}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 8),

          // Event Description
          Text(
            event.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
