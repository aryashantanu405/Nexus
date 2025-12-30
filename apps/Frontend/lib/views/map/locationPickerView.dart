import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexus_frontend/services/providers/radioButtonProvider.dart';


class LocationPickerView extends ConsumerStatefulWidget {
  const LocationPickerView({super.key});

  @override
  ConsumerState<LocationPickerView> createState() => _LocationPickerViewState();
}

class _LocationPickerViewState extends ConsumerState<LocationPickerView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: locationPickingWidget(ref),
    );
  }
}


Consumer locationPickingWidget(WidgetRef ref)
{
  return Consumer( builder: (context, ref, child) {
    final pickedLocation = ref.watch(addTaskScreenSateProvider.select((screenStatus) => screenStatus.taskLocation));

    if(pickedLocation.latitude.isNaN || pickedLocation.longitude.isNaN)
      {
        return SizedBox(
          height: 4.h,
          child: CircularProgressIndicator(),
        );
      }

    return Stack(
      children: [
        FlutterMap(options: MapOptions(
            initialCenter: pickedLocation, initialZoom: 17.5, onTap: (_, point) {
              ref.read(addTaskScreenSateProvider.notifier).updateTaskLocation(point);
        }), children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: "com.example.nexus_frontend",
          ),

          MarkerLayer(markers: [
            Marker(point: pickedLocation, child: const Icon(Icons.location_pin), height: 40, width: 40)
          ])
        ]),
        Positioned(bottom: 20.r, left: 20.r, right: 20.r, child: ElevatedButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text("Confirm Location")))
      ],
    );
  },

  );
}
