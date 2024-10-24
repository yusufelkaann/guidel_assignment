import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:guidel_assignment/models/poi_model.dart';
import 'package:guidel_assignment/service/current_location_service.dart';
import 'package:guidel_assignment/service/poi_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class POIProvider with ChangeNotifier {
  final POIService _poiService = POIService();
  final LocationService _locationService = LocationService();
  List<POI> _pois = [];
  String _selectedType = 'restaurant';
  String? _errorMessage;

  // Initialize current position as null
  LatLng? currentPosition;

  List<POI> get pois => _pois;
  String get selectedType => _selectedType;
  String? get errorMessage => _errorMessage;

  final List<String> _types = ['restaurant', 'school', 'hospital', 'museum'];
  List<String> get types => _types;

  // Method to fetch current location and then fetch POIs
  Future<void> initialize() async {
    currentPosition = await _locationService.fetchCurrentLocation();
    if (currentPosition != null) {
      await fetchPOIs(); // Fetch POIs for the default selected type
    } else {
      _errorMessage = 'Could not fetch current location.';
      notifyListeners();
    }
  }

  void setSelectedType(String type) {
    _selectedType = type;
    fetchPOIs(); // Fetch POIs for the selected type
    notifyListeners();
  }

  Future<void> fetchPOIs() async {
    if (currentPosition == null) {
      _errorMessage = 'Current position is not available.';
      notifyListeners();
      return; // Return early if current position is not set
    }

    try {
      _errorMessage = null;
      _pois = await _poiService.getNearbyPOIs(currentPosition!, _selectedType);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching POIs: $e");
      }
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
