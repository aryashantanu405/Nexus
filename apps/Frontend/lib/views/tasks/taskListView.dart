import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexus_frontend/controllers/location/locationController.dart';
import 'package:nexus_frontend/controllers/task/taskController.dart';
import 'package:nexus_frontend/services/providers/radioButtonProvider.dart';
import 'package:nexus_frontend/views/tasks/addTask.dart';
import 'package:nexus_frontend/widgets/gradientButton.dart';
import 'package:nexus_frontend/widgets/navigationBar.dart';
import 'package:nexus_frontend/widgets/sliverAppBar.dart';
import 'package:nexus_frontend/widgets/taskCard.dart';

import '../../models/taskModel.dart';

class TaskListView extends ConsumerStatefulWidget {
  const TaskListView({super.key});

  @override
  ConsumerState<TaskListView> createState() => _TaskViewState();
}

class _TaskViewState extends ConsumerState<TaskListView> {
  Map<String, List<TaskModel>?> categoryWiseTasks = {};
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9fa),
      body: CustomScrollView(
        slivers: [
          myAppBar(
            "Tasks",
            "All Tasks & Categories",
            "assets/images/loginIcon.png",
          ),

          SliverToBoxAdapter(
            child: Consumer(
              builder: (context, ref, child) {
                final taskListProvider = ref.watch(taskControllerProvider);
                return taskListProvider.loading ?  const CircularProgressIndicator() :
                 Column(
                  children: [
                    myNavigationBar(
                      taskListProvider.allTaskCategories,
                      ref,
                      taskListProvider,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: taskListProvider.currentCategoryTasks.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onHorizontalDragEnd: (details) {
                            if(details.primaryVelocity! == null)
                              {
                                return;
                              }

                            if(details.primaryVelocity! > 0)
                              {
                                return;
                              }

                            if(details.primaryVelocity! < 0)
                              {
                                ref.read(taskControllerProvider.notifier).deleteTask(taskListProvider.currentCategoryTasks[index].id ?? "", ref.read(locationControllerProvider).currentPos);
                              }
                          },
                          child: TaskCard(
                            taskListProvider.currentCategoryTasks[index],
                            context,
                            ref
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Consumer(builder: (context, ref, child) {
        final showUpdate = ref.watch(addTaskScreenSateProvider.select((screenStaus) => screenStaus.showUpdateButton));
        return showUpdate ? SizedBox(
          height: 50.r,
            width: 150.r,
            child: GradientButton(onPressed: (){}, child: Text("Update Tasks", style: TextStyle(color: Colors.white),))) : FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return AddTaskView();
          }));
        },
        child: Container(
          height: 60.r,
          width: 60.r,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xff667eea), Color(0xff764ba2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),

          child: const Icon(Icons.add, color: Colors.white),
        ),
      );}) 
    );
  }
}
