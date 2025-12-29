import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexus_frontend/widgets/sliverAppBar.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      body: CustomScrollView(
        slivers: [
          myAppBar(
            "Notifications",
            "Manage notification preferences",
            "assets/images/loginIcon.png",
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: const Column(
                children: [
                  _ToggleTile(
                    title: "Allow Notifications",
                    subtitle: "Enable all app notifications",
                  ),
                  _ToggleTile(
                    title: "Email Notifications",
                    subtitle: "Receive updates via email",
                  ),
                  _ToggleTile(
                    title: "Sound Alerts",
                    subtitle: "Play sound for alerts",
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

class _ToggleTile extends StatefulWidget {
  final String title;
  final String subtitle;

  const _ToggleTile({
    required this.title,
    required this.subtitle,
  });

  @override
  State<_ToggleTile> createState() => _ToggleTileState();
}

class _ToggleTileState extends State<_ToggleTile> {
  bool value = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: SwitchListTile(
        value: value,
        onChanged: (v) => setState(() => value = v),
        inactiveThumbColor: const Color(0xff667eea),
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(widget.subtitle),
      ),
    );
  }
}
