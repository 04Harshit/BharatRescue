import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

bool isLocationServiceEnabled = false;
double latitude = 28.7239;
double longitude = 77.0879;
double currZoom = 4.5;
LatLng pos = const LatLng(28.7239, 77.0879);
const TextStyle kHeading1 = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
const TextStyle kHeading2 = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
const TextStyle kHeading3 = TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
const TextStyle kTitle2 = TextStyle(fontSize: 28, fontWeight: FontWeight.w700);