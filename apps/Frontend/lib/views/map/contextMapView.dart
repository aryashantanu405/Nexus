import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexus_frontend/controllers/location/locationController.dart';
import 'package:nexus_frontend/controllers/map/contextMapController.dart';
import 'package:nexus_frontend/controllers/task/taskController.dart';
import 'package:nexus_frontend/widgets/gradientButton.dart';
import 'package:nexus_frontend/widgets/sliverAppBar.dart';

class ContextMapView extends ConsumerWidget {
  const ContextMapView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(child: _mapCard(ref)),
                  SizedBox(height: 16.r),
                  Consumer(
                    builder: (context, ref, child) {
                      final placeName = ref.watch(
                        locationControllerProvider.select(
                          (screenStatus) => screenStatus.currentPlace.placeName,
                        ),
                      );
                      return _locationCard(placeName);
                    },
                  ),
                  SizedBox(height: 16.r),
                  Consumer(
                    builder: (context, ref, child) {
                      final allTasks = ref.watch(
                        contextMapScreenControllerProvider,
                      );
                      return _nearbyTasks(allTasks.selectedTasks);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 50.r,
        width: 125.r,
        child: GradientButton(
          onPressed: () {
            ref.read(locationControllerProvider.notifier).getCurrentLocation();
            ref
                .read(contextMapScreenControllerProvider.notifier)
                .viewTasksBasedOnLocation(
                  ref.read(locationControllerProvider).currentPos,
                  ref.read(taskControllerProvider).taskList,
                );
          },
          child: Text("Relocate", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _mapCard(WidgetRef ref) {
    return Container(
      height: 400.r,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xffd4fcf7), Color(0xfffcd6e0)],
        ),
      ),
      child: Center(child: locationPickingWidget2(ref)),
    );
  }

  Widget _locationCard(String? subtitle) {
    return _gradientCard(
      title: "📍 Current Location",
      subtitle: subtitle ?? "Unknown",
    );
  }

  Widget _nearbyTasks(List<LocationProximityTask> allTasks) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nearby Task Locations",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: allTasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(allTasks[index].currTask.title),
                  subtitle: Text(allTasks[index].currTask.category ?? ""),
                  trailing: Text(allTasks[index].distance.toString()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _gradientCard({required String title, required String subtitle}) {
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
          Text(subtitle, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

Consumer locationPickingWidget2(WidgetRef ref) {
  return Consumer(
    builder: (context, ref, child) {
      final pickedLocation = ref.watch(
        locationControllerProvider.select(
          (screenStatus) => screenStatus.currentPos,
        ),
      );

      if (pickedLocation.latitude.isNaN || pickedLocation.longitude.isNaN) {
        return SizedBox(height: 4.h, child: CircularProgressIndicator());
      }

      return Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: pickedLocation,
              initialZoom: 2,
              onTap: (_, point) {},
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: "com.example.nexus_frontend",
              ),

              MarkerLayer(
                markers: [
                  Marker(
                    point: pickedLocation,
                    child: const Icon(Icons.location_pin),
                    height: 40,
                    width: 40,
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    },
  );
}
