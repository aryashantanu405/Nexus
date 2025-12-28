import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexus_frontend/widgets/sliverAppBar.dart';

class ContextMapView extends StatelessWidget {
  const ContextMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      body: CustomScrollView(
        slivers: [
          /// ✅ SAME APP BAR AS ADD TASK & FOCUS
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

  Widget _mapCard() {
    return Container(
      height: 180.r,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xffd4fcf7), Color(0xfffcd6e0)],
        ),
      ),
      child: const Center(
        child: Text(
          "Google Maps Integration",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _locationCard() {
    return _gradientCard(
      title: "📍 Current Location",
      subtitle: "NIT Patna Campus\n🌤 28°C · Cloudy",
    );
  }

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
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
