




import 'package:flutter_riverpod/legacy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:nexus_frontend/models/taskModel.dart';


class ContextMapScreenController extends StateNotifier<ScreenStatus>{
  ContextMapScreenController():super(ScreenStatus(selectedTasks: [], taskLoading: false));
  void viewTasksBasedOnLocation(LatLng currPos, List<TaskModel> allTasks)
  {
    List<LocationProximityTask> proximityTasks = [];
    for(TaskModel task in allTasks)
      {
        if(task.taskLocation != null && task.taskLocation?.position != null)
          {
            double dist = Geolocator.distanceBetween(currPos.latitude, currPos.longitude, task.taskLocation?.lat ?? 0, task.taskLocation?.lng ?? 0);
            if(dist <= 10)
              {
                proximityTasks.add(LocationProximityTask(currTask: task, distance: dist));
              }
          }
      }

    state = state.copyWith(proximityTasks, null);
  }
}

class LocationProximityTask{
  final TaskModel currTask;
  final double distance;

  LocationProximityTask({required this.currTask, required this.distance});
}

class ScreenStatus{
  final List<LocationProximityTask> selectedTasks;
  final bool taskLoading;

  ScreenStatus({required this.selectedTasks, required this.taskLoading});

  ScreenStatus copyWith(List<LocationProximityTask>? selectedTasks, bool? taskLoading)
  {
    return ScreenStatus(selectedTasks: selectedTasks ?? this.selectedTasks, taskLoading: taskLoading ?? this.taskLoading);
  }
}

final contextMapScreenControllerProvider = StateNotifierProvider<ContextMapScreenController, ScreenStatus>((ref) {
  return ContextMapScreenController();
});