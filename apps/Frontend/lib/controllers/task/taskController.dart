
import 'package:flutter_riverpod/legacy.dart';
import 'package:nexus_frontend/models/taskModel.dart';
import 'package:nexus_frontend/repository/taskRepository.dart';

class TaskController extends StateNotifier<TaskScreenStatus> {
  TaskRepository taskRepository;

  TaskController(this.taskRepository)
    : super( TaskScreenStatus(selectedCategory: "all", taskList: [], currentCategoryTasks: [], allTaskCategories: [], loading: false, submitting: false));

  Future<void> getAllTasks() async {
    state = state.copyWith(null, null, null, null, true, null);
    try{
      final List<TaskModel>? tasks = await taskRepository.getAllTasks();
      if(tasks == null || tasks.isEmpty)
        {
          state = state.copyWith(null, null, null, null, false, null);
          return;
        }

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
      state = state.copyWith("all", safeTasks, safeTasks, allCategories, false, null);
    }
        catch(err)
    {
      print(err.toString());

    }
  }

  Future<void> addNewTask(TaskModel newTask) async
  {
    state = state.copyWith(null, null, null, null, true, true);
    await taskRepository.addNewTask(newTask);
    await getAllTasks();
    state = state.copyWith(null, null, null, null, false, false);
  }

  void categoryTasks(String category) {
    state = state.copyWith(category.toLowerCase(), null, null, null, null, null);
    List<TaskModel> tasks = [];

    for (TaskModel task in state.taskList) {
      if (task.category?.toLowerCase() == category.toLowerCase() || category.toLowerCase() == "all") {
        tasks.add(task);
      }
    }

   state = state.copyWith(null, null, tasks, null, null, null);
  }

  Future<void> markTasksComplete(List<String> taskIds) async
  {
    state = state.copyWith(null, null, null, null, true, null);
    final updated = await taskRepository.markTasksComplete(taskIds);

    if(!updated)
      {
        state = state.copyWith(null, null, null, null, false, null);
        return;
      }

    await getAllTasks();
  }


}

class TaskScreenStatus {
  final String selectedCategory;
  final List<TaskModel> taskList;
  final List<TaskModel> currentCategoryTasks;
  final List<String> allTaskCategories;
  final bool loading;
  final bool submitting;



  TaskScreenStatus({
    required this.selectedCategory,
    required this.taskList,
    required this.currentCategoryTasks,
    required this.allTaskCategories,
    required this.loading,
    required this.submitting
  });

  TaskScreenStatus copyWith(
    String? selectedCategory,
    List<TaskModel>? taskList,
      List<TaskModel>? currentCategoryTasks,
      List<String>? allTaskCategories,
      bool? loading,
      bool? submitting
  ) {
    return TaskScreenStatus(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      taskList: taskList ?? this.taskList,
      currentCategoryTasks: currentCategoryTasks ?? this.currentCategoryTasks,
      allTaskCategories: allTaskCategories ?? this.allTaskCategories,
      loading: loading ?? this.loading,
      submitting: submitting ?? this.submitting
    );
  }
}

final taskControllerProvider =
    StateNotifierProvider<TaskController, TaskScreenStatus>((ref) {
      return TaskController(ref.read(taskRepositoryProvider));
    });
