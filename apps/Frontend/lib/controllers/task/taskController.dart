
import 'package:flutter_riverpod/legacy.dart';
import 'package:latlong2/latlong.dart';
import 'package:nexus_frontend/models/taskModel.dart';
import 'package:nexus_frontend/repository/taskRepository.dart';

class TaskController extends StateNotifier<TaskScreenStatus> {
  TaskRepository taskRepository;

  TaskController(this.taskRepository)
    : super( TaskScreenStatus(selectedCategory: "all", taskList: [], currentCategoryTasks: [], allTaskCategories: [], loading: false, submitting: false,  selectedTaskIds: {}, showUpdateButton: false));

  Future<void> getAllTasks(LatLng currLocation) async {
    state = state.copyWith(null, null, null, null, true, null,  null, null);
    try{
      final List<TaskModel>? tasks = await taskRepository.getAllTasks(currLocation);
      if(tasks == null || tasks.isEmpty)
        {
          state = state.copyWith(null, null, null, null, false, null, null, null);
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
      state = state.copyWith("all", safeTasks, safeTasks, allCategories, false, null, null, null);
    }
        catch(err)
    {
      print(err.toString());

    }
  }

  Future<void> addNewTask(TaskModel newTask, LatLng currLocation) async
  {
    state = state.copyWith(null, null, null, null, true, true, null, null);
    await taskRepository.addNewTask(newTask);
    await getAllTasks(currLocation);
    state = state.copyWith(null, null, null, null, false, false, null, null);
  }

  void categoryTasks(String category) {
    if(category.toLowerCase() == "completed" || category.toLowerCase() == "on-going")
    {
      statusWiseCategory(category);
      return;
    }
    state = state.copyWith(category.toLowerCase(), null, null, null, null, null, null, null);

    if(category.toLowerCase() == "all")
      {
        List<TaskModel> myTasks = state.taskList;
        state = state.copyWith(null, null, myTasks, null, null, null, null, null);
        return;
      }
    List<TaskModel> tasks = [];

    for (TaskModel task in state.taskList) {
      if (((task.category?.toLowerCase() == category.toLowerCase()) && (task.status?.toLowerCase() != "completed")) || category.toLowerCase() == "all") {
        tasks.add(task);
      }
    }

   state = state.copyWith(null, null, tasks, null, null, null, null, null);
  }


  void statusWiseCategory(String status)
  {
    state = state.copyWith(status.toLowerCase(), null, null, null, null, null, null, null);
    List<TaskModel> tasks = [];

    for (TaskModel task in state.taskList) {
      if (task.status?.toLowerCase() == status.toLowerCase() || status.toLowerCase() == "all") {
        tasks.add(task);
      }
    }

    state = state.copyWith(null, null, tasks, null, null, null, null, null);
  }

  Future<void> markTasksComplete(List<String> taskIds, LatLng currLocation) async
  {
    state = state.copyWith(null, null, null, null, true, null, null, null);
    final updated = await taskRepository.markTasksComplete(taskIds);

    if(!updated)
      {
        state = state.copyWith(null, null, null, null, false, null, null, null);
        return;
      }

    await getAllTasks(currLocation);
  }

  Future<void> deleteTask(String taskId, LatLng currLocation) async
  {
    state = state.copyWith(null, null, null, null, true, null, null, null);
    final deleted = await taskRepository.deleteTask(taskId);

    if(!deleted)
      {
        state = state.copyWith(null, null, null, null, false, null, null, null);
        return;
      }

    await getAllTasks(currLocation);
  }

  void selectATask(String taskId)
  {
    final selectedIds = Set<String>.from(state.selectedTaskIds);
    selectedIds.add(taskId);

    state = state.copyWith(null, null, null, null, null, null,  selectedIds, true);
  }

  void disselectATask(String taskId)
  {
    final selectedIds = Set<String>.from(state.selectedTaskIds);
    selectedIds.remove(taskId);

    if(selectedIds.isEmpty)
    {
      state = state.copyWith(null, null, null, null, null, null,  selectedIds, false);
      return;
    }
    state = state.copyWith(null, null, null, null, null, null,  selectedIds, true);
  }



}

class TaskScreenStatus {
  final String selectedCategory;
  final List<TaskModel> taskList;
  final List<TaskModel> currentCategoryTasks;
  final List<String> allTaskCategories;
  final bool loading;
  final bool submitting;
  final Set<String> selectedTaskIds;
  final bool showUpdateButton;



  TaskScreenStatus({
    required this.selectedCategory,
    required this.taskList,
    required this.currentCategoryTasks,
    required this.allTaskCategories,
    required this.loading,
    required this.submitting,
    required this.selectedTaskIds,
    required this.showUpdateButton
  });

  TaskScreenStatus copyWith(
    String? selectedCategory,
    List<TaskModel>? taskList,
      List<TaskModel>? currentCategoryTasks,
      List<String>? allTaskCategories,
      bool? loading,
      bool? submitting,
      Set<String>? selectedTaskIds,
      bool? showUpdateButton
  ) {
    return TaskScreenStatus(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      taskList: taskList ?? this.taskList,
      currentCategoryTasks: currentCategoryTasks ?? this.currentCategoryTasks,
      allTaskCategories: allTaskCategories ?? this.allTaskCategories,
      loading: loading ?? this.loading,
      submitting: submitting ?? this.submitting,
        selectedTaskIds: selectedTaskIds ?? this.selectedTaskIds,
        showUpdateButton: showUpdateButton ?? this.showUpdateButton
    );
  }
}

final taskControllerProvider =
    StateNotifierProvider<TaskController, TaskScreenStatus>((ref) {
      return TaskController(ref.read(taskRepositoryProvider));
    });
