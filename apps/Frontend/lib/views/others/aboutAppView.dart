import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexus_frontend/widgets/sliverAppBar.dart';
import 'package:nexus_frontend/views/others/termsAndConditionsView.dart';

class AboutAppView extends StatelessWidget {
  const AboutAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      body: CustomScrollView(
        slivers: [
          myAppBar(
            "About App",
            "Know more about Nexus",
            "assets/images/loginIcon.png",
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: [
                  _infoCard(
                    title: "Nexus",
                    content:
                        "Nexus is a productivity assistant designed to help you "
                        "manage tasks, improve focus, and optimize daily work.",
                  ),

                  _infoCard(
                    title: "Version",
                    content: "v1.0.0",
                  ),

                  _infoCard(
                    title: "Developer",
                    content: "Nexus Team",
                  ),

                  /// ✅ TERMS & CONDITIONS CARD
                  _clickableCard(
                    context: context,
                    title: "Terms & Conditions",
                    subtitle: "Read our policies and usage terms",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TermsAndConditionsView(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// NORMAL INFO CARD
  Widget _infoCard({
    required String title,
    required String content,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff667eea),
              ),
            ),
            SizedBox(height: 8.h),
            Text(content),
          ],
        ),
      ),
    );
  }

  /// CLICKABLE CARD (FOR T&C)
  Widget _clickableCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff667eea),
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
