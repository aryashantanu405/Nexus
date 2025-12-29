import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:nexus_frontend/widgets/sliverAppBar.dart';
import 'package:nexus_frontend/views/profile/editProfileView.dart';
import 'package:nexus_frontend/views/settings/settingsView.dart';
import 'package:nexus_frontend/views/others/notificationView.dart';
import 'package:nexus_frontend/views/others/helpCenterView.dart';
import 'package:nexus_frontend/views/others/aboutAppView.dart';

import 'package:nexus_frontend/controllers/auth/authController.dart';
import 'package:nexus_frontend/services/navigationBarProvider.dart';

import '../../models/userModel.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myUser = ref.watch(authControllerProvider.select((userState) => userState.currentUser));
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      body: CustomScrollView(
        slivers: [
          myAppBar(
            "Profile",
            "Manage your account",
            "assets/images/loginIcon.png",
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: [
                  _profileHeader(context, myUser, ref),
                  SizedBox(height: 20.r),

                  /// 🔔 Notifications
                  _profileOption(
                    icon: Icons.notifications,
                    title: "Notifications",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationView(),
                        ),
                      );
                    },
                  ),

                  /// ⚙️ Settings
                  _profileOption(
                    icon: Icons.settings,
                    title: "Settings",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SettingsView(),
                        ),
                      );
                    },
                  ),

                  /// ❓ Help Center
                  _profileOption(
                    icon: Icons.help_outline,
                    title: "Help Center",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HelpCenterView(),
                        ),
                      );
                    },
                  ),

                  /// ℹ️ About App
                  _profileOption(
                    icon: Icons.info_outline,
                    title: "About App",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AboutAppView(),
                        ),
                      );
                    },
                  ),

                  /// 🚪 Logout (NO route replacement – keeps navbar logic intact)
                  _profileOption(
                    icon: Icons.logout,
                    title: "Logout",
                    isDestructive: true,
                    onTap: () {
                      ref.read(authControllerProvider.notifier).logout();
                      ref
                          .read(navigationControllerProvider.notifier)
                          .changeScreen(0); // back to Login tab
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

  Widget _profileHeader(BuildContext context, UserModel? user, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xff667eea), Color(0xff764ba2)],
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage("assets/images/loginIcon.png"),
          ),
          SizedBox(width: 16.r),
           Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? "Guest",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "VIP Member",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>  EditProfileView(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _profileOption({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 10.r),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? Colors.red : const Color(0xff667eea),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? Colors.red : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
