import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../models/store.dart';

class DistanceScreen extends StatefulWidget {
  final Store store;

  const DistanceScreen({super.key, required this.store});

  @override
  _DistanceScreenState createState() => _DistanceScreenState();
}

class _DistanceScreenState extends State<DistanceScreen> {
  double? _currentLatitude;
  double? _currentLongitude;
  String _distance = "Loading...";
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _distance = "Location services are disabled";
          _errorMessage = "Please enable location services on your device";
          _isLoading = false;
        });
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _distance = "Location permission denied";
            _errorMessage = "Please grant location permission in app settings";
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _distance = "Location permission permanently denied";
          _errorMessage = "Please enable location permissions in app settings";
          _isLoading = false;
        });
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      setState(() {
        _currentLatitude = position.latitude;
        _currentLongitude = position.longitude;
        _isLoading = false;
      });

      _calculateDistance();
    } catch (e) {
      setState(() {
        _distance = "Error getting location";
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _calculateDistance() {
    if (_currentLatitude == null || _currentLongitude == null) {
      setState(() {
        _distance = "Location not available";
      });
      return;
    }

    double storeLatitude = widget.store.lat;
    double storeLongitude = widget.store.lng;

    double distanceInMeters = _calculateDistanceBetweenCoordinates(
      _currentLatitude!,
      _currentLongitude!,
      storeLatitude,
      storeLongitude,
    );

    setState(() {
      _distance = "${(distanceInMeters / 1000).toStringAsFixed(2)} km";
    });
  }

  double _calculateDistanceBetweenCoordinates(
      double lat1,
      double lon1,
      double lat2,
      double lon2,
      ) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c * 1000; // Convert to meters
  }

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
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Distance: $_distance',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (_errorMessage.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage,
                    style: const TextStyle(
                        fontSize: 14, color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _getCurrentLocation,
                    child: const Text('Try Again'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}