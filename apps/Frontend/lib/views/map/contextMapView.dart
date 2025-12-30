import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nexus_frontend/widgets/sliverAppBar.dart';

class ContextMapView extends StatefulWidget {
  const ContextMapView({super.key});

  @override
  State<ContextMapView> createState() => _ContextMapViewState();
}

class _ContextMapViewState extends State<ContextMapView> {
  GoogleMapController? _mapController;

  LatLng _currentLocation = const LatLng(25.6200, 85.1720); // fallback
  bool _permissionGranted = false;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  /// ---------------- LOCATION PERMISSION ----------------
  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint("Location permission permanently denied");
      return;
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      _permissionGranted = true;
      _getCurrentLocation();
    }
  }

  /// ---------------- GET CURRENT LOCATION ----------------
  Future<void> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_currentLocation, 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      body: CustomScrollView(
        slivers: [
          myAppBar(
            "Context Map",
            "Location-based Reminders",
            "assets/images/loginIcon.png",
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: [
                  _mapCard(),
                  SizedBox(height: 16.r),
                  _locationCard(),
                  SizedBox(height: 16.r),
                  _nearbyTasks(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- MAP CARD ----------------
  Widget _mapCard() {
    return Container(
      height: 180.r,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _currentLocation,
            zoom: 15,
          ),
          myLocationEnabled: _permissionGranted,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          onMapCreated: (controller) {
            _mapController = controller;
          },
          markers: {
            Marker(
              markerId: const MarkerId("current"),
              position: _currentLocation,
              infoWindow: const InfoWindow(title: "Your Location"),
            ),
          },
        ),
      ),
    );
  }

  /// ---------------- LOCATION CARD ----------------
  Widget _locationCard() {
    return _gradientCard(
      title: "📍 Current Location",
      subtitle: "Live GPS Location\n🌤 28°C · Cloudy",
    );
  }

  /// ---------------- NEARBY TASKS ----------------
  Widget _nearbyTasks() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nearby Task Locations",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            ListTile(
              title: Text("Big Bazaar"),
              subtitle: Text("🛒 Buy groceries"),
              trailing: Text("0.8 km"),
            ),
            ListTile(
              title: Text("Central Library"),
              subtitle: Text("📚 Return books"),
              trailing: Text("1.2 km"),
            ),
            ListTile(
              title: Text("Campus Gym"),
              subtitle: Text("💪 Evening workout"),
              trailing: Text("0.3 km"),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------- GRADIENT CARD ----------------
  Widget _gradientCard({
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xff667eea), Color(0xff764ba2)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
