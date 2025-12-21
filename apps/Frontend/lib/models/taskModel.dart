import 'package:nexus_frontend/models/dateModel.dart';
import 'package:nexus_frontend/models/subtaskModel.dart';

import 'locationModel.dart';

class TaskModel {
  final String title;
  String? description;
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

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      title: json["title"],
      description: json["description"],
      category: json["category"],
      priority: json["priority"],
      status: json["status"],
      aiScore: json["aiScore"],
      taskLocation: LocationModel.fromJson(json["location"]),
      dueDate: DateModel.fromJson(json["dueDate"]),
      dateCreated: DateModel.fromJson(json["dateCreated"]),
      tags: json["tags"],
      subtasks:
          json["subtasks"]
              .map((currTask) => SubtaskModel.fromJson(currTask))
              .toList(),
    );
  }
}
