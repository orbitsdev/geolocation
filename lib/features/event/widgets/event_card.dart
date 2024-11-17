// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:geolocation/core/theme/palette.dart';

import 'package:geolocation/features/event/model/event.dart';

class EventCard extends StatelessWidget {

  Event event;
   EventCard({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
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
            '${event.title}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),

          Text(
            'COODIDATNES: ${event.latitude} - ${event.longitude} ',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          Text(
            'PLACEID: ${event.placeId}  ',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          Text(
            'RADIUS: ${event.radius}  ',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          Text(
            'Date: ${event.startTime} - ${event.endTime} ',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          // Event Date
          SizedBox(height: 8),

          // Event Description
          Text(
            '${event.description}',
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
