import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guidel_assignment/models/poi_model.dart';
import 'package:guidel_assignment/service/current_location_service.dart';
import '../providers/poi_type_provider.dart';

class MarkerService {
  final POIProvider poiProvider;

  MarkerService(this.poiProvider);

  Future<LatLng?> fetchCurrentLocation() async {
    final locationService = LocationService();
    return await locationService.fetchCurrentLocation();
  }

  // Helper function to load marker image as Uint8List
  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!.buffer.asUint8List();
  }


  /*function to fetch markers for the selectedPoiType and currentPosition
      -takes position and selectedType as a parameter
      -goes through the fetched pois and matches them with the appropriate marker
  */
  Future<Map<String, dynamic>> fetchMarkers(LatLng currentPosition, String selectedType) async {
    Set<Marker> markers = {};
    
    // Fetch POIs based on the selected type
    await poiProvider.fetchPOIs();

    // Load the custom marker icons as Uint8List
    Uint8List restaurantIcon = await _getBytesFromAsset('assets/images/restaurant.png', 96);
    Uint8List schoolIcon = await _getBytesFromAsset('assets/images/education.png', 96);
    Uint8List hospitalIcon = await _getBytesFromAsset('assets/images/hospital-pin.png', 96);
    Uint8List museumIcon = await _getBytesFromAsset('assets/images/museum-pin.png', 96);

    for (POI poi in poiProvider.pois) {
      BitmapDescriptor markerIcon;

      // Select the appropriate marker icon based on the selectedType
      switch (selectedType) {
        case 'restaurant':
          markerIcon = BitmapDescriptor.fromBytes(restaurantIcon);
          break;
        case 'school':
          markerIcon = BitmapDescriptor.fromBytes(schoolIcon);
          break;
        case 'hospital':
          markerIcon = BitmapDescriptor.fromBytes(hospitalIcon);
          break;
        case 'museum':
          markerIcon = BitmapDescriptor.fromBytes(museumIcon);
          break;
        default:
          markerIcon = BitmapDescriptor.defaultMarker; // Fallback to default marker
      }

      markers.add(
        Marker(
          icon: markerIcon,
          markerId: MarkerId(poi.id),
          position: LatLng(poi.latitude, poi.longitude),
          infoWindow: InfoWindow(
            title: poi.name,
            snippet: 'Lat: ${poi.latitude}, Lng: ${poi.longitude}',
          ),
        ),
      );
    }
    
    return {'markers': markers, 'pois': poiProvider.pois};
  } 
} 