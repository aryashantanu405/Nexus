import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nexus_frontend/models/taskModel.dart';
import 'package:nexus_frontend/services/providers/radioButtonProvider.dart';
import 'package:nexus_frontend/utils/colorPallete.dart';

Card TaskCard(TaskModel myTask, BuildContext context, WidgetRef ref) {
  return Card(
    child: Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xfff8f9fa),
        border: const BorderDirectional(
          start: BorderSide(
            width: 4,
            color: Color(0xff667eea),
            strokeAlign: -1,
          ),
        ),
      ),

      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Text(
                    myTask.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: "Inter",
                      color: Color(0xff333333),
                    ),
                  ),
                ),
                SizedBox(width: 5.r),

                myTask.priority != null
                    ? priorityBadge(myTask.priority ?? "")
                    : const SizedBox(height: 0, width: 0),
              ],
            ),
            SizedBox(height: 5.r),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Wrap(
                    spacing: 30.r,
                    runSpacing: 5.r,
                    alignment: WrapAlignment.spaceBetween,
                    runAlignment: WrapAlignment.start,
                    children: [
                      myTask.dueDate == null
                          ? SizedBox(height: 0, width: 0)
                          : taskSpecBadge(
                            "assets/images/loginIcon.png",
                            "Due on: ${DateFormat.yMMMMd().format(DateTime(myTask.dueDate?.year ?? 0, myTask.dueDate?.month ?? 0, myTask.dueDate?.day ?? 0))}",
                          ),
                      taskSpecBadge("assets/images/loginIcon.png", "Due in 6 days"),
                      taskSpecBadge("assets/images/loginIcon.png", "Due in 6 days"),
                    ],
                  ),
                ),
                Consumer(builder: (context, ref, child) {
                  final selectedIds = ref.watch(addTaskScreenSateProvider.select((screenStatus) => screenStatus.selectedTaskIds));
                  return Checkbox(value: selectedIds.contains(myTask.id), onChanged: (value) {
                    if(value!)
                      {
                        ref.read(addTaskScreenSateProvider.notifier).selectATask(myTask.id!);
                      }
                    else{
                      ref.read(addTaskScreenSateProvider.notifier).disselectATask(myTask.id!);
                    }

                  });
                },)
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Container priorityBadge(String priority) {
  Color backgroundCol() {
    if (priority == "high") {
      return ColorPallete.highPriorityBackground;
    } else if (priority == "medium") {
      return ColorPallete.mediumPriorityBackground;
    }

    return ColorPallete.lowPriorityBackground;
  }

  Color textCol() {
    if (priority == "high") {
      return ColorPallete.highPriorityText;
    } else if (priority == "medium") {
      return ColorPallete.mediumPriorityText;
    }

    return ColorPallete.lowPriorityText;
  }

  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      color: backgroundCol(),
    ),

    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.r, vertical: 5.r),
      child: Text(
        priority.toUpperCase(),
        style: TextStyle(
          color: textCol(),
          fontSize: 11,
          fontWeight: FontWeight.w900,
          fontFamily: "Inter",
        ),
      ),
    ),
  );
}

SizedBox taskSpecBadge(String imagePath, String title) {
  return SizedBox(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image(height: 15.r, width: 15.r, image: AssetImage(imagePath)),
        SizedBox(width: 2.r),
        Flexible(child: Text(title)),
      ],
    ),
  );
}
