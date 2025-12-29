import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      body: CustomScrollView(
        slivers: [
          _header(),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: [
                  _section("🔔 Notifications", [
                    _toggle("Enable Notifications"),
                    _info("Quiet Hours", "10 PM – 8 AM"),
                  ]),
                  _section("🤖 AI Features", [
                    _toggle("Smart Scheduling"),
                    _info("Suggestion Frequency", "Moderate"),
                  ]),
                  _section("💪 Wellness", [
                    _info("Sleep Goal", "8 hours"),
                    _toggle("Break Reminders"),
                    _info("Focus Duration", "25 min"),
                  ]),
                  _section("🎨 Appearance", [
                    _themeSelector(),
                  ]),
                  _section("🔒 Privacy", [
                    _toggle("Location Tracking"),
                    _toggle("Screen Time Tracking"),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _header() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 110.h,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff667eea), Color(0xff764ba2)],
          ),
        ),
        child: const Center(
          child: Text(
            "⚙️ Settings\nPreferences & Configuration",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            SizedBox(height: 12.h),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _toggle(String label) {
    return SwitchListTile(
      value: true,
      onChanged: (_) {},
      title: Text(label),
      inactiveThumbColor: const Color(0xff667eea),
    );
  }

  Widget _info(String label, String value) {
    return ListTile(
      title: Text(label),
      trailing: Text(value, style: const TextStyle(color: Colors.grey)),
    );
  }

  Widget _themeSelector() {
    return Row(
      children: [
        _themeDot(const Color(0xff667eea)),
        _themeDot(Colors.cyan),
        _themeDot(Colors.green),
      ],
    );
  }

  Widget _themeDot(Color color) {
    return Container(
      margin: EdgeInsets.only(right: 10.w),
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
