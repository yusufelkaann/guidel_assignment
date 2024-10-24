import 'package:guidel_assignment/service/poi_service.dart';

class POI {
  final String id;
  final String name;
  final String vicinity;
  final double latitude;
  final double longitude;
  final String imageUrl;

  POI({
    required this.id,
    required this.name,
    required this.vicinity,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
  });

  // Factory method to create POI from JSON
  factory POI.fromJson(Map<String, dynamic> json) {
    String imageUrl = '';
    
    // Check if photos exist in the JSON response
    if (json['photos'] != null && json['photos'].isNotEmpty) {
      // Get the first photo reference and construct the image URL
      String photoReference = json['photos'][0]['photo_reference'];
      imageUrl = POIService.getImageUrl(photoReference);
    }

    return POI(
      id: json['place_id'],
      name: json['name'],
      vicinity: json['vicinity'],
      latitude: json['geometry']['location']['lat'],
      longitude: json['geometry']['location']['lng'],
      imageUrl: imageUrl, // Set the image URL
    );
  }
}
