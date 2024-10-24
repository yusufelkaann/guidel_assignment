// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guidel_assignment/components/category_tile.dart';
import 'package:guidel_assignment/styles/custom_colors.dart';
import 'package:guidel_assignment/styles/custom_sizes.dart';
import 'package:guidel_assignment/models/poi_model.dart';
import 'package:guidel_assignment/service/get_center_service.dart';
import 'package:guidel_assignment/service/marker_service.dart';
import 'package:provider/provider.dart';
import '../providers/poi_provider.dart';
import 'package:guidel_assignment/service/current_location_service.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  LatLng? _currentPosition;
  List<POI> _pois = [];
  late MarkerService _mapService;
  late LocationService _locationService;
  late GetCenterService _centerService;
  double _currentZoom = 14.0;
  
  @override
  void initState() {
    super.initState();
    final poiProvider = Provider.of<POIProvider>(context, listen: false);
    _mapService = MarkerService(poiProvider);
    _locationService = LocationService();
    _centerService = GetCenterService();
    _fetchCurrentLocation();
  }
  
  
  /* 
  fetches to the location of the user using the fetchCurrentLocation 
  function in the location service
  */
  Future<void> _fetchCurrentLocation() async {
    _currentPosition = await _locationService.fetchCurrentLocation();
    if (_currentPosition != null) {
      Provider.of<POIProvider>(context, listen: false).currentPosition = _currentPosition;
      await _fetchMarkers();
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition!, 14.0));
    }
  }

  /*
    fetches appropriate markers using fetchMarkers function in MapService
  */
  Future<void> _fetchMarkers() async {
    final poiProvider = Provider.of<POIProvider>(context, listen: false);
    final result = await _mapService.fetchMarkers(_currentPosition!, poiProvider.selectedType);

    _markers = result['markers'];
    _pois = result['pois'];

    setState(() {});
  }

  
  /*
  function to search for POI's for the location of user's phone's center:
        -gets the location of the center using getCenterPosition
        -fetches markers for this location
   */
  Future<void> _searchHere() async {
    if (_mapController != null) {
      final centerPosition = await _centerService.getCenterPosition(_mapController!);
      final poiProvider = Provider.of<POIProvider>(context, listen: false);
      poiProvider.currentPosition = centerPosition;
      await _fetchMarkers();
      setState(() {});
    }
  }

  // Function to zoom in
  void _zoomIn() {
    if (_mapController != null) {
      setState(() {
        _currentZoom++;
        _mapController!.animateCamera(CameraUpdate.zoomIn());
      });
    }
  }

  // Function to zoom out
  void _zoomOut() {
    if (_mapController != null) {
      setState(() {
        _currentZoom--;
        _mapController!.animateCamera(CameraUpdate.zoomOut());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final poiProvider = Provider.of<POIProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // GoogleMap
              Expanded(
                child: GoogleMap(
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                    if (_currentPosition != null) {
                      _mapController?.animateCamera(
                        CameraUpdate.newLatLngZoom(_currentPosition!, 14.0),
                      );
                    }
                  },
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition ??
                        const LatLng(37.42796133580664, -122.085749655962),
                    zoom: 14.0,
                  ),
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
              ),
            ],
          ),
        
            // Draggable Scrollable Sheet
           // Check if there are any POIs to show
            DraggableScrollableSheet(
              initialChildSize: 0.3,
              minChildSize: 0.2,
              maxChildSize: 0.8,
              builder: (context, scrollController) {
                return Container(
                  padding: const EdgeInsets.all(CustomSizes.mediumPadding),
                  decoration: BoxDecoration(
                    color: CustomColors.tertiary,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(CustomSizes.largeRadius)),
                  ),
                  child: Column(
                    children: [
                      // Search Here button when on tapped finds POI's for the current center of the map
                      TextButton(
                        onPressed: () {
                          _searchHere(); 
                        },
                        child: Text(
                          "Search Here",
                          style: TextStyle(fontSize: CustomSizes.mediumFontSize, color: CustomColors.secondaryColor),
                        ),
                      ),
                    
                      // Category tiles in horizontal scroll
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: poiProvider.types.map((type) {
                            return CategoryTile(
                              category: type,
                              isSelected: type == poiProvider.selectedType,
                              onTap: () {
                                poiProvider.setSelectedType(type);
                                _fetchMarkers(); // Fetch markers when a category is tapped
                              },
                            );
                          }).toList(),
                        ),
                      ),

                      // Expanded ListView for POIs
                      Expanded(
                        child: _pois.isEmpty
                            ?Center(
                              child: Text(
                                'No landmarks found in this area.',
                                style: TextStyle(fontSize: CustomSizes.smallFontSize, fontWeight: FontWeight.bold),
                              ),
                            )
                        : ListView.builder(
                          controller: scrollController,
                          itemCount: _pois.length,
                          itemBuilder: (context, index) {
                            final poi = _pois[index];
                            return GestureDetector(
                              onTap: () {
                                // Show details for the tapped POI or update map position
                                _mapController?.animateCamera(
                                  CameraUpdate.newLatLng(LatLng(poi.latitude, poi.longitude)),
                                );
                              },
                              child: Card(
                                color: CustomColors.primaryColor,
                                margin: EdgeInsets.symmetric(vertical: CustomSizes.margin),
                                child: ListTile(
                                  leading: poi.imageUrl.isNotEmpty
                                      ? Image.network(
                                          poi.imageUrl,
                                          width: CustomSizes.cardHeight,
                                          height: CustomSizes.cardHeight,
                                          fit: BoxFit.cover,
                                        )
                                      : Icon(Icons.place, size: CustomSizes.cardHeight), // Default icon when image is null
                                  title: Text(
                                    poi.name,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text('Lat: ${poi.latitude}, Lng: ${poi.longitude}'),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Positioned(
              bottom: 80.0,
              right: 10.0,
              child: Column(children: [
                //zoom in button
                FloatingActionButton(
                  onPressed: _zoomIn,
                  heroTag: 'Zoom In',
                  mini: true,
                  backgroundColor: CustomColors.primaryColor,
                  child:Icon(Icons.zoom_in, color: CustomColors.secondaryColor)          
                ),

                SizedBox(height: 10,),
                //zoom out button
                FloatingActionButton(
                  onPressed: _zoomOut,
                  heroTag: 'Zoom Out',
                  mini: true,
                  backgroundColor: CustomColors.primaryColor,
                  child:Icon(Icons.zoom_out, color: CustomColors.secondaryColor)          
                )

              ],
            )
          ),
        ],
      ),
    );
  }



}
