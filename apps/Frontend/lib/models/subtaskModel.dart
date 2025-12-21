class SubtaskModel{
  final String title;
  bool? completed;

  SubtaskModel({required this.title, this.completed});

  factory SubtaskModel.fromJson(Map<String, dynamic> json)
  {
    return SubtaskModel(title: json["title"], completed: json["completed"]);
  }

}