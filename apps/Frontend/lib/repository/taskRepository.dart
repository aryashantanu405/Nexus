import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:nexus_frontend/models/taskModel.dart';
import 'package:nexus_frontend/services/dioProvider.dart';

class TaskRepository {
  final Dio dio;

  TaskRepository(this.dio);

  Future<List<TaskModel>?> getAllTasks(LatLng currLocation) async {
    try {
      final response = await dio.get("/tasks/getalltasks");

      final data = response.data;

      if (response.statusCode == 200) {
        print("Success");
      }

      final allTasks = data["data"]["tasks"];

      List<TaskModel>? myTasks = List<TaskModel>.from(
        allTasks.map((task) => TaskModel.fromJson(task)),
      );

      for (int i = 0; i < myTasks.length; i++) {
        TaskModel currTask = myTasks[i];
        if (currTask.taskLocation != null &&
            currTask.taskLocation?.position != null) {
          double dist = Geolocator.distanceBetween(
            currLocation.latitude,
            currLocation.longitude,
            currTask.taskLocation?.lat ?? 0,
            currTask.taskLocation?.lng ?? 0,
          );

          currTask.distanceBetween = dist.truncateToDouble();

          String unit = "m";

          if(currTask.distanceBetween! >= 1000)
            {
              unit = "km";
              double myDist = currTask.distanceBetween!;
              myDist = myDist/1000;

              currTask.distanceBetween = myDist.truncateToDouble();
            }

          currTask.distanceUnit = unit;



          myTasks[i] = currTask;

        }
      }

      return myTasks;
    } on DioException catch (err) {
      print(err.response?.data);
      return null;
    }
  }

  Future<void> addNewTask(TaskModel newTask) async {
    try {
      final response = await dio.post(
        "/tasks/createtask",
        data: newTask.toJson(),
      );

      print(newTask.dueDate?.year);
      if (response.statusCode == 201) {
        print("Success");
      }

      if (response.statusCode == 500) {
        print(response.data);
      }
    } on DioException catch (err) {
      print(err.response);
      return;
    }
  }

  Future<bool> markTasksComplete(List<String> taskIds) async {
    try {
      final response = await dio.post("/tasks/completetask", data: taskIds);

      if (response.statusCode == 200) {
        print("Success");
        return true;
      }

      return false;
    } on DioException catch (err) {
      print(err.response);
      return false;
    }
  }

  Future<bool> deleteTask(String taskId) async
  {
    try{
      final response = await dio.delete("/deletetask/${taskId}");

      if(response.statusCode == 200)
        {
          return true;
        }

      return false;
    }
        on DioException catch(err)
    {
      return false;
    }
  }
}

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository(ref.read(dioProvider));
});
