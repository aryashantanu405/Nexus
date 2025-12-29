import 'package:nexus_frontend/models/dateModel.dart';
import 'package:nexus_frontend/models/subtaskModel.dart';

import 'locationModel.dart';

class TaskModel {
  final String title;
  String? description;
  String? id;
  String? category;
  String? priority;
  String? status;
  int? aiScore;
  LocationModel? taskLocation;
  DateModel? dueDate;
  DateModel? dateCreated;
  List<String>? tags;
  List<SubtaskModel>? subtasks;

  TaskModel({
    required this.title,
    this.description,
    this.id,
    this.category,
    this.priority,
    this.status,
    this.aiScore,
    this.taskLocation,
    this.dueDate,
    this.dateCreated,
    this.tags,
    this.subtasks,
  });


  Map<String, dynamic> toJson()
  {
    return {
      "title" : title,
      "description" : description,
      "category" : category,
      "priority" : priority,
      "dueDate" : "${dueDate?.year}-${dueDate?.month}-${dueDate?.day}",
      "subtasks" : subtasks?.map((subtask) => subtask.toJson()).toList()
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      title: json["title"],
      id: json["id"],
      description: json["description"],
      category: json["category"],
      priority: json["priority"],
      status: json["status"],
      aiScore: json["aiScore"],
      taskLocation: json["location"] == null ? null :  LocationModel.fromJson(json["location"]),
      dueDate: json["dueDate"] == null ? null : DateModel.fromJson(json["dueDate"]),
      dateCreated: json["dateCreated"] == null ? null : DateModel.fromJson(json["dateCreated"]),
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      subtasks:
      json["subtasks"] ?. json["subtasks"]
              .map((currTask) => SubtaskModel.fromJson(currTask))
              .toList(),
    );
  }
}
