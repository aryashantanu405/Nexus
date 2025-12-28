import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexus_frontend/widgets/sliverAppBar.dart';

class HelpCenterView extends StatelessWidget {
  const HelpCenterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      body: CustomScrollView(
        slivers: [
          myAppBar(
            "Help Center",
            "Frequently asked questions",
            "assets/images/loginIcon.png",
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: const Column(
                children: [
                  _HelpCard(
                    question: "How to add a task?",
                    answer:
                        "Go to Home → Add Task → Fill details → Save.",
                  ),
                  _HelpCard(
                    question: "How does Focus Mode work?",
                    answer:
                        "Focus Mode blocks distractions and tracks deep work time.",
                  ),
                  _HelpCard(
                    question: "How to edit profile?",
                    answer:
                        "Open Profile → Edit button → Update details.",
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

class _HelpCard extends StatelessWidget {
  final String question;
  final String answer;

  const _HelpCard({
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff667eea),
              ),
            ),
            SizedBox(height: 8.h),
            Text(answer),
          ],
        ),
      ),
    );
  }
}
