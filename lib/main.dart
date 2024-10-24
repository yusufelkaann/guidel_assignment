//        import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:guidel_assignment/providers/poi_provider.dart';
import 'package:guidel_assignment/view/map_page.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        POIProvider poiProvider = POIProvider();
        poiProvider.initialize(); // Initialize POIProvider
        return poiProvider;
      },
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MapPage(),
      ),
    );
  }
}


