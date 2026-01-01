import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nexus_frontend/controllers/location/locationController.dart';
import 'package:nexus_frontend/controllers/task/taskController.dart';
import 'package:nexus_frontend/models/locationModel.dart';
import 'package:nexus_frontend/models/subtaskModel.dart';
import 'package:nexus_frontend/models/taskModel.dart';
import 'package:nexus_frontend/services/providers/radioButtonProvider.dart';
import 'package:nexus_frontend/views/map/locationPickerView.dart';
import 'package:nexus_frontend/widgets/gradientButton.dart';
import 'package:nexus_frontend/widgets/sliverAppBar.dart';

class AddTaskView extends ConsumerStatefulWidget {
  const AddTaskView({super.key});

  @override
  ConsumerState<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends ConsumerState<AddTaskView> {
  List<TextEditingController> subtaskTitleControllers = [];
  TextEditingController taskTitleController = TextEditingController();
  TextEditingController taskDescriptionController = TextEditingController();
  TextEditingController taskCategoryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9fa),

      body: CustomScrollView(
        slivers: [
          myAppBar(
            "Add Task",
            "Update Your Task List",
            "assets/images/loginIcon.png",
          ),
          basicTaskFeatureForm(
            ref,
            subtaskTitleControllers,
            context,
            taskTitleController,
            taskDescriptionController,
            taskCategoryController,
          ),
        ],
      ),
    );
  }
}

SliverToBoxAdapter basicTaskFeatureForm(
  WidgetRef ref,
  List<TextEditingController> subtaskTitleControllers,
  BuildContext context,
  TextEditingController taskTitleController,
  TextEditingController taskDescriptionController,
  TextEditingController taskCategoryController,
) {
  return SliverToBoxAdapter(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 30.r, horizontal: 20.r),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Task Title",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.r),
              ),
              SizedBox(height: 5.r),
              TextFormField(
                controller: taskTitleController,
                maxLines: 1,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Title can't be empty";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: const Color(0xffE1E5E0),
                  filled: true,
                ),
              ),
            ],
          ),
          SizedBox(height: 25.r),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Description",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.r),
              ),
              SizedBox(height: 5.r),
              TextFormField(
                controller: taskDescriptionController,
                maxLines: 2,

                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: const Color(0xffE1E5E0),
                  filled: true,
                ),
              ),
            ],
          ),
          SizedBox(height: 25.r),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Category",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.r),
              ),
              SizedBox(height: 5.r),
              TextFormField(
                controller: taskCategoryController,
                maxLines: 1,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Title can't be empty";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: const Color(0xffE1E5E0),
                  filled: true,
                ),
              ),
            ],
          ),
          SizedBox(height: 25.r),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Priority",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.r),
              ),
              SizedBox(height: 10.r),
              Consumer(
                builder: (context, ref, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      radioButton("LOW", const Color(0xff09B43F), ref),
                      radioButton("MEDIUM", const Color(0xffEE510D), ref),
                      radioButton("HIGH", const Color(0xffC50909), ref),
                    ],
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 25.r),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Due Date",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.r),
              ),
              SizedBox(height: 10.r),
              GestureDetector(
                onTap: () async {
                  await ref
                      .read(addTaskScreenSateProvider.notifier)
                      .selectDate(context);
                },
                child: Container(
                  height: 50.r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: const Color(0xffE1E5E0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15.r),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Consumer(
                          builder: (context, ref, child) {
                            final selectedDate = ref.watch(
                              addTaskScreenSateProvider.select(
                                (screenStatus) => screenStatus.dueDate,
                              ),
                            );
                            return selectedDate.year == 0
                                ? const Text("Select date")
                                : Text(
                                  DateFormat.yMMMMd().format(selectedDate),
                                );
                          },
                        ),
                        Image(
                          height: 25.r.r,
                          width: 25.r,
                          image: const AssetImage(
                            "assets/images/calendar_icon.png",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 25.r),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Urgency Score",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.r),
              ),
              SizedBox(height: 10.r),
              Consumer(
                builder: (context, ref, child) {
                  final sliderVal = ref.watch(
                    addTaskScreenSateProvider.select(
                      (screenStatus) => screenStatus.urgencyScore,
                    ),
                  );
                  return Slider(
                    value: sliderVal,
                    onChanged: (value) {
                      ref
                          .read(addTaskScreenSateProvider.notifier)
                          .changeUrgencyScore(value);
                    },
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 25.r),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Task Location",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.r),
              ),
              SizedBox(height: 10.r),
              Consumer(
                builder: (context, ref, child) {

                  return GestureDetector(
                    onTap: ()  {
                      ref.read(addTaskScreenSateProvider.notifier).updateTaskLocation(ref.read(locationControllerProvider).currentPos);
                      Navigator.push(context, MaterialPageRoute(builder: (_) {

                        return LocationPickerView();
                      }));
                    },
                    child: Container(
                      height: 50.r,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: const Color(0xffE1E5E0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(15.r),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Consumer(
                              builder: (context, ref, child) {
                                final taskLocation = ref.watch(addTaskScreenSateProvider.select((screenStatus) => screenStatus.taskLocation));
                                return taskLocation.latitude == 0? Text("Select Location") : Text("Location Selected");
                              },
                            ),
                            Image(
                              height: 25.r.r,
                              width: 25.r,
                              image: const AssetImage(
                                "assets/images/calendar_icon.png",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 25.r),
          //Subtask Builder
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Subtasks",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.r),
              ),
              SizedBox(height: 5.r),
              Consumer(
                builder: (context, ref, child) {
                  final allSubtasks = ref.watch(
                    addTaskScreenSateProvider.select(
                      (screenState) => screenState.tempSubtasks,
                    ),
                  );
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: allSubtasks.length,
                    itemBuilder: (context, index) {
                      return allSubtasks[index].saved
                          ? Column(
                            children: [
                              savedSubtaskWidget(
                                subtaskTitleControllers[index].text,
                                ref,
                                index,
                              ),
                              SizedBox(height: 5.r),
                            ],
                          )
                          : Column(
                            children: [
                              unsavedSubtaskWidget(
                                index,
                                subtaskTitleControllers,
                                ref,
                              ),
                              SizedBox(height: 5.r),
                            ],
                          );
                    },
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 25.r),

          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 40.r,
              width: 130.r,
              child: GradientButton(
                onPressed: () {
                  ref.read(addTaskScreenSateProvider.notifier).addNewSubtask();
                  subtaskTitleControllers.add(TextEditingController());
                },
                child: const Text(
                  "Add Subtask",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 25.r),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 40.r,
                child: GradientButton(
                  onPressed: () async {
                    if (taskTitleController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Task title can't be empty"),
                        ),
                      );
                      return;
                    }
                    final allSubtasks = ref.watch(
                      addTaskScreenSateProvider.select(
                        (screenStatus) => screenStatus.tempSubtasks,
                      ),
                    );
                    for (TempSubtaskModel task in allSubtasks) {
                      if (task.saved == false || task.title.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "No subtask can be unsaved or subtask title can't be empty",
                            ),
                          ),
                        );
                        return;
                      }
                    }

                    String taskPriority =
                        ref.read(addTaskScreenSateProvider).selectedPriority;

                    List<SubtaskModel> taskSubtasks =
                        ref
                            .read(addTaskScreenSateProvider)
                            .tempSubtasks
                            .map(
                              (currSubtask) =>
                                  SubtaskModel(title: currSubtask.title),
                            )
                            .toList();
                    final dueDate = ref.read(addTaskScreenSateProvider).dueDate;
                    final currUrgencyScore =
                        ref.read(addTaskScreenSateProvider).urgencyScore;

                    final currLocation = ref.read(addTaskScreenSateProvider).taskLocation;




                    final myNewTask = TaskModel(
                      title: taskTitleController.text,
                      description: taskDescriptionController.text,
                      category: taskCategoryController.text,
                      priority: taskPriority,
                      subtasks: taskSubtasks,
                      dueDate: dueDate,
                      urgencyScore: currUrgencyScore,
                      taskLocation: LocationModel(position: currLocation, lat: currLocation.latitude, lng: currLocation.longitude),
                    );

                    await ref
                        .read(taskControllerProvider.notifier)
                        .addNewTask(myNewTask);

                    ref.read(addTaskScreenSateProvider.notifier).reset();

                    Navigator.pop(context);
                  },
                  child: Consumer(
                    builder: (context, ref, child) {
                      final taskStatus = ref.watch(
                        taskControllerProvider.select(
                          (myTask) => myTask.submitting,
                        ),
                      );

                      return taskStatus
                          ? CircularProgressIndicator()
                          : Text(
                            "Submit",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 40.r,
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text(
                    "Discard",
                    style: TextStyle(color: Color(0xff333333)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget radioButton(String label, Color labelColor, WidgetRef ref) {
  final selectedLabel = ref.watch(
    addTaskScreenSateProvider.select(
      (screenState) => screenState.selectedPriority,
    ),
  );
  return Row(
    children: [
      GestureDetector(
        onTap: () {
          ref
              .read(addTaskScreenSateProvider.notifier)
              .changePriority(label.toLowerCase());
        },
        child: Container(
          height: 20.r,
          width: 20.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xff333333), width: 1),
          ),

          child: Padding(
            padding: EdgeInsets.all(3.r),
            child: Container(
              height: 15.r,
              width: 15.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    selectedLabel.toLowerCase() == label.toLowerCase()
                        ? const Color(0xffCBCFCA)
                        : const Color(0xfff8f9fa),
              ),
            ),
          ),
        ),
      ),
      SizedBox(width: 8.r),
      Text(
        label,
        style: TextStyle(
          color: labelColor,
          fontWeight: FontWeight.bold,
          fontSize: 13.r,
        ),
      ),
    ],
  );
}

Widget savedSubtaskWidget(String taskTitle, WidgetRef ref, int index) {
  return Container(
    height: 50.r,
    decoration: BoxDecoration(
      color: const Color(0xffE1E5E0),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
      padding: EdgeInsets.all(15.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(taskTitle),
          GestureDetector(
            onTap: () {
              ref.read(addTaskScreenSateProvider.notifier).editTask(index);
            },
            child: Image(
              height: 20.r,
              width: 20.r,
              image: const AssetImage("assets/images/right_icon.png"),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget unsavedSubtaskWidget(
  int index,
  List<TextEditingController> titleControllers,
  WidgetRef ref,
) {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xffE1E5E0),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
      padding: EdgeInsets.all(15.r),
      child: Column(
        children: [
          Text("Subtask ${index + 1}"),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Task Title",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.r),
              ),
              SizedBox(height: 5.r),
              TextFormField(
                controller: titleControllers[index],
                maxLines: 1,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Title can't be empty";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: const Color(0xfff8f9fa),
                  filled: true,
                ),
              ),
            ],
          ),
          SizedBox(height: 15.r),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  ref
                      .read(addTaskScreenSateProvider.notifier)
                      .saveASubtask(titleControllers[index].text, index);
                },
                child: Row(
                  children: [
                    Image(
                      width: 20.r,
                      height: 20.r,
                      image: const AssetImage("assets/images/save_icon.png"),
                    ),
                    const Text(
                      "Save",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  ref
                      .read(addTaskScreenSateProvider.notifier)
                      .deleteSubtask(index);
                  titleControllers.removeAt(index);
                },
                child: Row(
                  children: [
                    Image(
                      width: 20.r,
                      height: 20.r,
                      image: const AssetImage("assets/images/delete_icon.png"),
                    ),
                    const Text(
                      "Delete",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
