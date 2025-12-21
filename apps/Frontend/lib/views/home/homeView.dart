import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nexus_frontend/models/taskModel.dart';
import 'package:nexus_frontend/utils/homeScreenOutlineButton.dart';
import 'package:nexus_frontend/widgets/sliverAppBar.dart';
import 'package:nexus_frontend/widgets/taskCard.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff8f9fa),
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
                  greetingCard("Shashank"),
                  SizedBox(height: 15.r),
                  aiInsightCard("insight", context),
                  SizedBox(height: 15.r),

                  Text(
                    "Today's Priority Tasks",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0ff667eea),
                      fontSize: 18.r,
                      fontFamily: "Inter",
                    ),
                  ),
                  SizedBox(height: 15.r),

                  TaskCard(
                    TaskModel(
                      title:
                          "Complete Cyber Security Assignment",
                      priority: "high",
                    ),
                    context,
                  ),

                  SizedBox(
                    height: 5.r,
                  ),

                  TaskCard(
                    TaskModel(
                      title:
                      "Play Cricket",
                      priority: "Low",
                    ),
                    context,
                  ),

                  SizedBox(
                    height: 5.r,
                  ),

                  TaskCard(
                    TaskModel(
                      title:
                      "Play Cricket",
                      priority: "Low",
                    ),
                    context,
                  ),
                  SizedBox(
                    height: 5.r,
                  ),

                  TaskCard(
                    TaskModel(
                      title:
                      "Play Cricket",
                      priority: "Low",
                    ),
                    context,
                  ),
                  SizedBox(
                    height: 15.r,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          HomeScreenOutlinedButton("assets/images/loginIcon.png", "Add Task"),
                          SizedBox(
                            width: 5.r,
                          ),
                          HomeScreenOutlinedButton("assets/images/loginIcon.png", "Start Focus"),
                        ],
                      ),
                      SizedBox(
                        height: 10.r,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          HomeScreenOutlinedButton("assets/images/loginIcon.png", "View Map"),
                          SizedBox(
                            width: 5.r,
                          ),
                          HomeScreenOutlinedButton("assets/images/loginIcon.png", "Analytics"),
                        ],
                      )
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
          color: Color(0xff667eea),
          fontSize: 30.r,
        ),
      ),

      Text(
        DateFormat('EEEE, MMMM d, yyyy').format(currTime).toString(),
        style: TextStyle(
          color: Color(0xff333333),
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
          gradient: LinearGradient(
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
                      Text(
                        "AI Insight",
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5.r),
              Text(
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
