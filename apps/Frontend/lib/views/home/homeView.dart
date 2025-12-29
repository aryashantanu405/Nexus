import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nexus_frontend/controllers/auth/authController.dart';
import 'package:nexus_frontend/controllers/task/taskController.dart';
import 'package:nexus_frontend/controllers/user/userController.dart';
import 'package:nexus_frontend/utils/homeScreenOutlineButton.dart';
import 'package:nexus_frontend/widgets/sliverAppBar.dart';
import 'package:nexus_frontend/widgets/taskCard.dart';
import 'package:nexus_frontend/views/tasks/addTask.dart';
import 'package:nexus_frontend/views/map/contextMapView.dart';
import 'package:nexus_frontend/views/focus/focusView.dart';
import 'package:nexus_frontend/views/analytics/analyticsView.dart';



class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9fa),
      body: CustomScrollView(
        slivers: [
          myAppBar(
            "Home Screen",
            "Daily Agenda & AI Insight",
            "assets/images/loginIcon.png",
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 15.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer(
                    builder: (context, ref, child) {
                      final user = ref.watch(authControllerProvider);
                      return greetingCard(user.currentUser?.name ?? "Guest");
                    },
                  ),
                  SizedBox(height: 15.r),
                  Consumer(
                    builder: (context, ref, child) {
                      final aiInsight = ref.watch(userControllerProvider);
                      return aiInsightCard(aiInsight.aiInsight, context);
                    },
                  ),
                  SizedBox(height: 15.r),

                  Text(
                    "Today's Priority Tasks",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff0ff667eea),
                      fontSize: 18.r,
                      fontFamily: "Inter",
                    ),
                  ),
                  SizedBox(height: 15.r),
                  Consumer(
                    builder: (context, ref, child) {
                      final allTasks = ref.watch(taskControllerProvider);
                      return  allTasks.loading ? const CircularProgressIndicator() : ListView.builder(
                        itemCount: allTasks.currentCategoryTasks.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              TaskCard(
                                allTasks.currentCategoryTasks[index],
                                context,
                              ),
                              SizedBox(height: 5.r),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 15.r),
                  Column(
                    children: [
                      Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    HomeScreenOutlinedButton(
      "assets/images/loginIcon.png",
      "Add Task",
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const AddTaskView(),
          ),
        );
      },
    ),
    SizedBox(width: 5.r),
    HomeScreenOutlinedButton(
      "assets/images/loginIcon.png",
      "Start Focus",
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const FocusView(),
          ),
        );
      },
    ),
  ],
),
SizedBox(height: 10.r),
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    HomeScreenOutlinedButton(
      "assets/images/loginIcon.png",
      "View Map",
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ContextMapView(),
          ),
        );
      },
    ),
    SizedBox(width: 5.r),
    HomeScreenOutlinedButton(
      "assets/images/loginIcon.png",
      "Analytics",
      () {
        Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AnalyticsView(),
      ),
    );
      },
    ),
  ],
),

                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Column greetingCard(String userName) {
  final currTime = DateTime.now();

  String dayTime = "";

  if (currTime.hour >= 0 && currTime.hour <= 12) {
    dayTime = "morning";
  } else if (currTime.hour >= 12 && currTime.hour <= 18) {
    dayTime = "afternoon";
  } else {
    dayTime = "evening";
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Good $dayTime,\n$userName!",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: "Inter",
          color: const Color(0xff667eea),
          fontSize: 30.r,
        ),
      ),

      Text(
        DateFormat('EEEE, MMMM d, yyyy').format(currTime).toString(),
        style: TextStyle(
          color: const Color(0xff333333),
          fontSize: 15.5.r,
          fontWeight: FontWeight.w200,
        ),
      ),
    ],
  );
}

Flexible aiInsightCard(String insight, BuildContext context) {
  return Flexible(
    child: Card(
      elevation: 3,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [Color(0xff667eea), Color(0xff764ba2)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),

        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.r, horizontal: 20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 32.r,
                width: 96.r,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(30),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 18.r,
                        width: 18.r,
                        child: Image.asset("assets/images/loginIcon.png"),
                      ),
                      SizedBox(width: 4.r),
                      const Text(
                        "AI Insight",
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5.r),
              const Text(
                "Your best focus time is 2-4 PM today. I've scheduled your assignment work during this window.",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}