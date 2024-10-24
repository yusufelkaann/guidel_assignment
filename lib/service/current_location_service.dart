import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
//function to get the current location of the user
Future<LatLng?> fetchCurrentLocation() async {
  // Check for location permission
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      if (kDebugMode) {
        print('Location permission denied.');
      }
      return null; // Permission denied
    }
  }

  try {
    // Get current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    //after getting the location return latLng to use for poi
    return LatLng(position.latitude, position.longitude); // Return LatLng
  } catch (e) {
    if (kDebugMode) {
      print('Failed to fetch location: $e');
    }
    return null; // Return null if fetching fails
  }
}
}