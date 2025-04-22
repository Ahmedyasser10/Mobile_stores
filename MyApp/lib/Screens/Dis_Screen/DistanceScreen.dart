import 'dart:math';

import 'package:flutter/material.dart';
import '../../models/store.dart';

class DistanceScreen extends StatefulWidget {
  final Store store;

  const DistanceScreen({super.key, required this.store});

  @override
  _DistanceScreenState createState() => _DistanceScreenState();
}

class _DistanceScreenState extends State<DistanceScreen> {
  late double _currentLatitude;
  late double _currentLongitude;
  String _distance = "Loading...";

  @override
  void initState() {
    super.initState();
    _getFakeLocation(); // Use fake location for testing
  }

  // Use fake location in Mansoura, Egypt
  Future<void> _getFakeLocation() async {
    // Define a fake location (Mansoura, Egypt)
    double fakeLatitude = 31.0432;  // Mansoura's latitude
    double fakeLongitude = 31.3793;  // Mansoura's longitude

    // Once fake position is set, update state with location and distance
    setState(() {
      _currentLatitude = fakeLatitude;
      _currentLongitude = fakeLongitude;
      _calculateDistance();
    });
  }

  // Calculate distance from current location to store location
  void _calculateDistance() {
    double storeLatitude = widget.store.lat;
    double storeLongitude = widget.store.lng;

    // Calculate the distance using the haversine formula or any available method
    double distanceInMeters = _calculateDistanceBetweenCoordinates(
      _currentLatitude,
      _currentLongitude,
      storeLatitude,
      storeLongitude,
    );

    setState(() {
      // Convert to kilometers and display distance
      _distance = "${(distanceInMeters / 1000).toStringAsFixed(2)} km";
    });
  }

  // Function to calculate distance between two coordinates (using the haversine formula)
  double _calculateDistanceBetweenCoordinates(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Radius of Earth in kilometers

    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a = (sin(dLat / 2) * sin(dLat / 2)) +
        (cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2));
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c * 1000; // Return distance in meters
  }

  // Convert degrees to radians
  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Distance to Store'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Store: ${widget.store.storeName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Store Type: ${widget.store.storeType}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Store Rating: ${widget.store.rating}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            // Display the distance result here
            Text(
              'Distance: $_distance',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
