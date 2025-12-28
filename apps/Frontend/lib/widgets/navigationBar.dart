import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexus_frontend/controllers/task/taskController.dart';

SizedBox myNavigationBar(
  List<String> navNames,
  WidgetRef ref,
  TaskScreenStatus taskScreenStatus,
) {
  return SizedBox(
    height: 60.r,
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: navNames.length,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        bool isSelected =
            navNames[index].toLowerCase() == ref.read(taskControllerProvider).selectedCategory;
        return GestureDetector(
          onTap: () {
            ref
                .read(taskControllerProvider.notifier)
                .categoryTasks(navNames[index]);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: isSelected ? const Color(0xff667eea) : Colors.white,
                  ),

                  child: Padding(
                    padding:  EdgeInsets.all(10.r),
                    child: Text(
                      navNames[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xff333333),
                      ),
                    ),
                  ),
                ),
              ), SizedBox(width: 20.r,)
            ],
          ),
        );
      },
    ),
  );
}


// SizedBox myNavigationBar2(
//     List<String> navNames,
//     WidgetRef ref,
//     TaskScreenStatus taskScreenStatus,
//     ) {
//   return SizedBox(
//     height: 60.r,
//     child: ListView(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       scrollDirection: Axis.horizontal,
//       children: []
//         bool isSelected =
//             navNames[index] == taskScreenStatus.selectedCategory;
//         return GestureDetector(
//           onTap: () {
//             ref
//                 .read(taskControllerProvider.notifier)
//                 .categoryTasks(navNames[index]);
//           },
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(30),
//               color: isSelected ? Colors.deepPurple : Colors.white,
//             ),
//
//             child: Text(
//               navNames[index],
//               style: TextStyle(
//                 color: isSelected ? Colors.white : Color(0xff333333),
//               ),
//             ),
//           ),
//         );
//
//     ),
//   );
// }
//
//
// Widget categoryButton()
// {
//   return
// }