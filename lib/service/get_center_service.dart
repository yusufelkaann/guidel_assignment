import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetCenterService{
  Future<LatLng> getCenterPosition(GoogleMapController mapController) async {
    final visibleRegion = await mapController.getVisibleRegion();
    return LatLng(
      (visibleRegion.northeast.latitude + visibleRegion.southwest.latitude) / 2,
      (visibleRegion.northeast.longitude + visibleRegion.southwest.longitude) / 2,
    );
  }
}