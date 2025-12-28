import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MemoryView extends StatelessWidget {
  const MemoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      body: CustomScrollView(
        slivers: [
          _gradientHeader(
            title: "🧠 Memory",
            subtitle: "Reflections & Social Reminders",
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: [
                  _sectionTitle("Upcoming Reminders"),
                  _reminderCard(
                    icon: "🎂",
                    title: "Mom's Birthday",
                    subtitle: "November 20, 2025",
                    trailing: "In 11 days",
                  ),
                  _reminderCard(
                    icon: "📞",
                    title: "Call Parents",
                    subtitle: "You haven’t called in 2 weeks",
                    trailing: "Overdue",
                    danger: true,
                  ),

                  SizedBox(height: 20.h),
                  _sectionTitle("Weekly Summary"),
                  _summaryGrid(),

                  SizedBox(height: 20.h),
                  _insightCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /* ------------------ Widgets ------------------ */

  SliverAppBar _gradientHeader({
    required String title,
    required String subtitle,
  }) {
    return SliverAppBar(
      expandedHeight: 120.h,
      pinned: true,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff667eea), Color(0xff764ba2)],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 50.h),
          child: Column(
            children: [
              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              Text(subtitle,
                  style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xff667eea),
          ),
        ),
      ),
    );
  }

  Widget _reminderCard({
    required String icon,
    required String title,
    required String subtitle,
    required String trailing,
    bool danger = false,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Text(icon, style: const TextStyle(fontSize: 22)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Text(
          trailing,
          style: TextStyle(
            color: danger ? Colors.red : Colors.grey,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _summaryGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        _summaryTile("15", "Tasks Completed"),
        _summaryTile("75%", "Success Rate"),
        _summaryTile("14h", "Focus Time"),
        _summaryTile("76%", "Productivity"),
      ],
    );
  }

  Widget _insightCard() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xff667eea), Color(0xff764ba2)],
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("✨ This Week's Insights",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("• Best focus time: 2–4 PM",
              style: TextStyle(color: Colors.white)),
          Text("• All high-priority tasks completed",
              style: TextStyle(color: Colors.white)),
          Text("• Try taking more breaks next week",
              style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

/* -------- summary tile -------- */

class _summaryTile extends StatelessWidget {
  final String value;
  final String label;

  const _summaryTile(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20)),
            Text(label,
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
