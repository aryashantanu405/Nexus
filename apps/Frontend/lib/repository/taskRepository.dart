

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_frontend/models/taskModel.dart';
import 'package:nexus_frontend/services/dioProvider.dart';

class TaskRepository{
  final Dio dio;

  TaskRepository(this.dio);

  Future<List<TaskModel>?> getAllTasks() async
  {
    try{

      final response = await dio.get("/tasks/getalltasks");

      final data = response.data;




      if(response.statusCode == 200)
        {
          print("Success");
        }

      final allTasks = data["data"]["tasks"];



      List<TaskModel>? myTasks = List<TaskModel>.from(allTasks.map((task) => TaskModel.fromJson(task)));

      return myTasks;
    }
        on DioException catch(err)
    {
      print(err.response?.data);
      return null;
    }
  }
  
  Future<void> addNewTask(TaskModel newTask) async{
    try{
      final response = await dio.post("/tasks/createtask", data: newTask.toJson());

      print(newTask.dueDate?.year);
      if(response.statusCode == 201)
        {
          print("Success");
        }

      if(response.statusCode == 500)
        {
          print(response.data);
        }
    }
        on DioException catch(err)
    {

      print(err.response);
      return;
    }
  }

  Future<bool> markTasksComplete(List<String> taskIds) async{
    try{
      final response = await dio.post("/tasks/completetask", data: taskIds);

      if(response.statusCode == 200)
        {
          print("Success");
          return true;
        }

      return false;
    }
        on DioException catch(err)
    {
      print(err.response);
      return false;
    }
  }
}

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository(ref.read(dioProvider));
});