# guidel_assignment

# Flutter Map App
A mobile application built with Flutter to show points of interest (POI) on Google Maps. Users can search for landmarks, zoom in and out, and explore different categories of POIs. This app helps tourists easily find places of interest based on their location.

## Features
- View current location on Google Maps
- Search for POIs based on categories
- Zoom in and out functionality
- Display information about landmarks


## Installation

### Prerequisites
- Flutter SDK [Get Flutter](https://flutter.dev/docs/get-started/install)
- Google Maps API key [Generate API Key](https://developers.google.com/maps/documentation/javascript/get-api-key)

### Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/yusufelkaann/guidel_assignment.git
   ```
2. Navigate to the project directory:
   ```bash
   cd guidel_assignment
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Add your Google Maps API Key to `android/app/src/main/AndroidManifest.xml` and `ios/Runner/AppDelegate.swift` and also to poi_service file

5. Run the app:
   ```bash
   flutter run
   ```


## Usage
Once the app is installed and running, you can:
- See your current location on the map.
- Tap "Search Here" to find POIs around the map center.
- Use the zoom in/out buttons to adjust the map view.
- Select different POI categories from the top bar.

## Technologies Used
- [Flutter](https://flutter.dev/) - A UI toolkit for building natively compiled applications for mobile.
- [Google Maps API](https://developers.google.com/maps) - To integrate maps.
- [Provider](https://pub.dev/packages/provider) - State management.
