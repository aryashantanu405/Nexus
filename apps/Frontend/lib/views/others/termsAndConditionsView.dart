import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexus_frontend/widgets/sliverAppBar.dart';

class TermsAndConditionsView extends StatelessWidget {
  const TermsAndConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      body: CustomScrollView(
        slivers: [
          myAppBar(
            "Terms & Conditions",
            "Please read carefully",
            "assets/images/loginIcon.png",
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("1. Acceptance of Terms"),
                  _sectionText(
                    "By using this application, you agree to comply with and be "
                    "bound by these Terms & Conditions.",
                  ),

                  _sectionTitle("2. User Responsibilities"),
                  _sectionText(
                    "You are responsible for maintaining the confidentiality "
                    "of your account and all activities under it.",
                  ),

                  _sectionTitle("3. Data Usage"),
                  _sectionText(
                    "We may collect usage data to improve app experience. "
                    "Your data will never be sold to third parties.",
                  ),

                  _sectionTitle("4. Prohibited Activities"),
                  _sectionText(
                    "Misuse, reverse engineering, or exploiting the app "
                    "is strictly prohibited.",
                  ),

                  _sectionTitle("5. Changes to Terms"),
                  _sectionText(
                    "We reserve the right to update these terms at any time. "
                    "Continued usage implies acceptance.",
                  ),

                  SizedBox(height: 20.h),

                  Text(
                    "Last updated: Sept 2025",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, bottom: 6.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xff667eea),
        ),
      ),
    );
  }

  Widget _sectionText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        height: 1.5,
        color: Colors.black87,
      ),
    );
  }
}
