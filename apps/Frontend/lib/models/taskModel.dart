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
  DateTime? dueDate;
  DateModel? dateCreated;
  List<String>? tags;
  List<SubtaskModel>? subtasks;
  double? urgencyScore;

  TaskModel({
    required this.title,
    this.description,
    this.id,
    this.category,
    this.priority,
    this.urgencyScore,
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
      "dueDate" : dueDate?.toIso8601String(),
      "subtasks" : subtasks?.map((subtask) => subtask.toJson()).toList(),
      "urgencyScore" : urgencyScore,

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
      urgencyScore: json["urgencyScore"],
      aiScore: json["aiScore"],
      taskLocation: json["location"] == null ? null :  LocationModel.fromJson(json["location"]),
      dueDate: json["dueDate"] == null ? null : DateTime.parse(json["dueDate"]),
      dateCreated: json["dateCreated"] == null ? null : DateModel.fromString(json["dateCreated"]),
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
