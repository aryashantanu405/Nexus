import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexus_frontend/models/taskModel.dart';
import 'package:nexus_frontend/repository/taskRepository.dart';

class TaskController extends StateNotifier<TaskScreenStatus> {
  TaskRepository taskRepository;

  TaskController(this.taskRepository)
    : super( TaskScreenStatus(selectedCategory: "all", taskList: [], currentCategoryTasks: [], allTaskCategories: [], loading: false));

  Future<void> getAllTasks() async {
    state = state.copyWith(null, null, null, null, true);
    try{
      final List<TaskModel>? tasks = await taskRepository.getAllTasks();

      final safeTasks = tasks ?? [];

      final distinct = <String>{};

      for(final t in safeTasks)
        {
          if(t.category != null && t.category!.trim().isNotEmpty)
            {
              distinct.add(t.category!);
            }
        }

      final allCategories = ["All", ...distinct];
      state = state.copyWith("all", safeTasks, safeTasks, allCategories, false);
    }
        catch(err, st)
    {
      print(err.toString());
    }
  }

  Future<void> addNewTask(TaskModel newTask) async
  {
    state = state.copyWith(null, null, null, null, true);
    await taskRepository.addNewTask(newTask);
    state = state.copyWith(null, null, null, null, false);
  }

  void categoryTasks(String category) {
    state = state.copyWith(category.toLowerCase(), null, null, null, null);
    List<TaskModel> tasks = [];

    for (TaskModel task in state.taskList) {
      if (task.category?.toLowerCase() == category.toLowerCase() || category.toLowerCase() == "all") {
        tasks.add(task);
      }
    }

   state = state.copyWith(null, null, tasks, null, null);
  }
}

class TaskScreenStatus {
  final String selectedCategory;
  final List<TaskModel> taskList;
  final List<TaskModel> currentCategoryTasks;
  final List<String> allTaskCategories;
  final bool loading;



  TaskScreenStatus({
    required this.selectedCategory,
    required this.taskList,
    required this.currentCategoryTasks,
    required this.allTaskCategories,
    required this.loading
  });

  TaskScreenStatus copyWith(
    String? selectedCategory,
    List<TaskModel>? taskList,
      List<TaskModel>? currentCategoryTasks,
      List<String>? allTaskCategories,
      bool? loading
  ) {
    return TaskScreenStatus(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      taskList: taskList ?? this.taskList,
      currentCategoryTasks: currentCategoryTasks ?? this.currentCategoryTasks,
      allTaskCategories: allTaskCategories ?? this.allTaskCategories,
      loading: loading ?? this.loading
    );
  }
}

final taskControllerProvider =
    StateNotifierProvider<TaskController, TaskScreenStatus>((ref) {
      return TaskController(ref.read(taskRepositoryProvider));
    });
