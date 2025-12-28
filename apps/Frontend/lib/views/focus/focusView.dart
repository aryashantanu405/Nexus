import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexus_frontend/widgets/sliverAppBar.dart';

class FocusView extends StatelessWidget {
  const FocusView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      body: CustomScrollView(
        slivers: [
          /// ✅ SAME APP BAR AS ADD TASK
          myAppBar(
            "Focus Mode",
            "Deep Work & Productivity",
            "assets/images/loginIcon.png",
          ),

          /// BODY
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: [
                  _focusTimerCard(),
                  SizedBox(height: 16.r),
                  _focusStats(),
                  SizedBox(height: 16.r),
                  _distractionCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _focusTimerCard() {
    return _gradientCard(
      title: "Working on",
      subtitle: "Cyber Security Assignment",
      child: Column(
        children: [
          SizedBox(height: 12.r),
          Text(
            "25:00",
            style: TextStyle(
              fontSize: 42.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.r),
          const Text(
            "Focus Session • Break in 25 min",
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(height: 16.r),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _actionButton("Pause"),
              _actionButton("Stop"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _focusStats() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _Stat("4", "Sessions"),
            _Stat("100m", "Focus Time"),
            _Stat("78%", "Productivity"),
          ],
        ),
      ),
    );
  }

  Widget _distractionCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "⚠ Distractions (2 today)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ListTile(
              title: Text("WhatsApp"),
              subtitle: Text("Opened during focus"),
              trailing: Text("2:15 PM"),
            ),
            ListTile(
              title: Text("Instagram"),
              subtitle: Text("15 min scrolling"),
              trailing: Text("3:45 PM"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gradientCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xff667eea), Color(0xff764ba2)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white70),
          ),
          SizedBox(height: 12.r),
          child,
        ],
      ),
    );
  }

  Widget _actionButton(String text) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xff667eea),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(text),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;

  const _Stat(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Text(label),
      ],
    );
  }
}
