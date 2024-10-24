import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetCenterService{

  /*
  function to find the coordinates for the center of the screen
  */
  Future<LatLng> getCenterPosition(GoogleMapController mapController) async {
    final visibleRegion = await mapController.getVisibleRegion();
    return LatLng(
      (visibleRegion.northeast.latitude + visibleRegion.southwest.latitude) / 2,
      (visibleRegion.northeast.longitude + visibleRegion.southwest.longitude) / 2,
    );
  }
}