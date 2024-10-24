import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guidel_assignment/models/poi_model.dart';
import 'package:provider/provider.dart';
import '../providers/poi_type_provider.dart';

class MapService {
  final POIProvider poiProvider;

  MapService(this.poiProvider);

  // Fetch markers for the current position and selected POI type
  Future<Map<String, dynamic>> fetchMarkers(LatLng currentPosition, String selectedType) async {
    Set<Marker> markers = {};

    // Fetch POIs based on the selected type
    await poiProvider.fetchPOIs();

    for (POI poi in poiProvider.pois) {
      
      markers.add(
        Marker(
          icon: BitmapDescriptor.defaultMarker,
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

  // Get the center of the visible region
  Future<LatLng> getCenterPosition(GoogleMapController mapController) async {
    final visibleRegion = await mapController.getVisibleRegion();
    return LatLng(
      (visibleRegion.northeast.latitude + visibleRegion.southwest.latitude) / 2,
      (visibleRegion.northeast.longitude + visibleRegion.southwest.longitude) / 2,
    );
  }
}
