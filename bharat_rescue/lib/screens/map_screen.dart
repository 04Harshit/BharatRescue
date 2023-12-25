import 'dart:convert';
import 'package:bharat_rescue/models/coordinates.dart';
import 'package:bharat_rescue/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../components/custom_marker.dart';
import '../utils/consts.dart';

// const LatLng currentLocation = LatLng(25.1193, 55.3773);

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool mapLoaded = false;
  List<Marker> positions = [];

  Future getLocation() async {
    isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationServiceEnabled) {
      LocationPermission permission;
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
      // Request the current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Access the latitude and longitude
      latitude = position.latitude;
      longitude = position.longitude;
    }

    setState(() {
      pos = LatLng(latitude, longitude);
      positions.add(CustomMarker(
              position: pos, icon: Icons.person_pin_circle, color: Colors.red)
          .createMarker());
    });

    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('GET',
        Uri.parse('https://sih-backend.azurewebsites.net/api/centre/nearest'));
    request.body = json.encode({
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var coordinates = await response.stream.bytesToString();
      List<String> stringList =
          coordinates.replaceAll('[', '').replaceAll(']', '').split(',');
      List<double> doubleList =
          stringList.map((str) => double.tryParse(str) ?? 0.0).toList();
      LatLng posn = LatLng(doubleList[1], doubleList[0]);
      setState(() {
        positions.add(CustomMarker(
                position: posn, icon: Icons.fmd_good, color: Colors.green)
            .createMarker());
      });
    } 
    else {
      print(response.reasonPhrase);
    }
  }

  Future fetchCentres() async {
    final response = await http.get(Uri.parse(
        'https://sih-backend.azurewebsites.net/api/centre/publicinfo'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      for (Map<String, dynamic> index in data) {
        Coordinates centre = Coordinates.fromJson(index);
        if (centre.location != null) {
          LatLng posn = LatLng(centre.location!.coordinates![1],
              centre.location!.coordinates![0]);
          positions.add(CustomMarker(
                  position: posn, icon: Icons.fmd_good, color: blueColor)
              .createMarker());
        }
      }
    }
    setState(() {
      mapLoaded = true;
    });
  }

  Future nearestCentre() async {
    
    // final queryParameters = {
    //   'latitude': latitude.toString(),
    //   'longitude': longitude.toString(),
    // };
    // final uri = Uri.http('https://sih-backend.azurewebsites.net', '/api/center/nearest', queryParameters);
    // final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    // final response = await http.get(uri, headers: headers);
    // var response = await http.post(
    //     Uri.parse('https://sih-backend.azurewebsites.net/api/center/nearest'),
    //     body: ({
    //       'latitude': latitude.toString(),
    //       'longitude': longitude.toString(),
    //     }));
    // print(response.statusCode);
    // if (response.statusCode == 200) {
    //   final Map<String, dynamic> responseData = json.decode(response.body);
    //   Coordinates coordinates = Coordinates.fromJson(responseData);
    //   LatLng posn = LatLng(
    //       coordinates[1], coordinates[0]);
    //   positions.add(CustomMarker(
    //           position: posn, icon: Icons.fmd_good, color: Colors.green)
    //       .createMarker());
    // }
    
  }

  @override
  void initState() {
    getLocation();
    fetchCentres();
    nearestCentre();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (mapLoaded)
        ? Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                  center: pos,
                  zoom: currZoom,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: positions,
                  ), // Marker
                ],
              )
            ],
          )
        : const Center(child: CircularProgressIndicator());
  }
}
