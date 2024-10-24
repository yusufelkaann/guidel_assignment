import 'dart:convert';
import 'package:guidel_assignment/models/poi_model.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class POIService {
  static const apiKey = "YOUR_API_KEY";
  Future<List<POI>> getNearbyPOIs(LatLng currentPosition, String type) async {
    
    const String baseUrl =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
    final String url =
        '$baseUrl?location=${currentPosition.latitude},${currentPosition.longitude}'
        '&radius=1000&type=$type&key=$apiKey';
  

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((poi) => POI.fromJson(poi))
          .toList();
    } else {
      throw Exception('Failed to fetch POIs: ${response.body}');
    }
  }
  // Function to construct the image URL from photo_reference
  static String getImageUrl(String photoReference) {
    return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey';
  }

}
