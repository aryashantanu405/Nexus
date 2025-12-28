import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nexus_frontend/services/navigationBarProvider.dart';
import 'package:nexus_frontend/views/auth/loginView.dart';
import 'package:nexus_frontend/views/home/homeView.dart';
import 'package:nexus_frontend/views/tasks/taskView.dart';
import 'package:nexus_frontend/views/memory/memoryView.dart';
import 'package:nexus_frontend/views/profile/profileView.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currIndex = ref.watch(navigationControllerProvider);

    const List<Widget> screens = [
      LoginView(),   // index 0 ❌ NO NAV BAR
      HomeView(),    // index 1
      TaskView(),    // index 2
      MemoryView(),  // index 3
      ProfileView(), // index 4
    ];

    return Scaffold(
      body: IndexedStack(
        index: currIndex,
        children: screens,
      ),

      /// ✅ SHOW NAV BAR ONLY AFTER LOGIN
      bottomNavigationBar: currIndex == 0
          ? null
          : NavigationBar(
              selectedIndex: currIndex - 1, // 🔥 IMPORTANT
              onDestinationSelected: (index) {
                // index: 0..3 → screens: 1..4
                ref
                    .read(navigationControllerProvider.notifier)
                    .changeScreen(index + 1);
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home),
                  label: "Home",
                ),
                NavigationDestination(
                  icon: Icon(Icons.task),
                  label: "Tasks",
                ),
                NavigationDestination(
                  icon: Icon(Icons.memory),
                  label: "Memory",
                ),
                NavigationDestination(
                  icon: Icon(Icons.person),
                  label: "Profile",
                ),
              ],
            ),
    );
  }
}
