import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CustomMarker {
  final LatLng position;
  final IconData icon;
  final Color color;

  CustomMarker({
    required this.position,
    required this.icon,
    required this.color,
  });

  Marker createMarker() {
    return Marker(
      width: 45.0,
      height: 45.0,
      point: position,
      builder: (context) {
        return Icon(
          icon,
          color: color,
          size: 40,
        );
      },
    );
  }
}