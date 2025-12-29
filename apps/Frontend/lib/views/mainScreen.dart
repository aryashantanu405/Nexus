import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexus_frontend/controllers/auth/authController.dart';
import 'package:nexus_frontend/services/navigationBarProvider.dart';
import 'package:nexus_frontend/views/auth/loginView.dart';
import 'package:nexus_frontend/views/auth/registerView.dart';
import 'package:nexus_frontend/views/home/homeView.dart';
import 'package:nexus_frontend/views/profile/profileView.dart';
import 'package:nexus_frontend/views/tasks/addTask.dart';
import 'package:nexus_frontend/views/tasks/taskView.dart';

import '../controllers/task/taskController.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {

  final List<Widget> _screens = [HomeView(), AddTaskView(), TaskView(), ProfileView()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(builder: (context, ref, child) {
        final _currIndex = ref.watch(navigationControllerProvider);
        return IndexedStack(index: _currIndex, children: _screens);}, ),

      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.transparent,
          backgroundColor: Color(0xffF5F5DC),
          surfaceTintColor: Colors.transparent,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if(states.contains(WidgetState.selected))
              {
                return const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff333333),
                );
              }

            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xff373D39),
            );
          }),
          height: 70.r
        ),
        child: NavigationBar(
          selectedIndex: ref.read(authControllerProvider) == AuthStatus.authenticated ? 1 : 0,
        onDestinationSelected: (index) {
          ref.read(navigationControllerProvider.notifier).changeScreen(index);
        }, destinations: [
          NavigationDestination(icon: SizedBox(
            height: 25.r,
            width: 25.r,
            child: Image.asset("assets/images/loginIcon.png"),
          ), label: "Home"),
          NavigationDestination(icon: SizedBox(
            height: 25.r,
            width: 25.r,
            child: Image.asset("assets/images/loginIcon.png"),
          ), label: "Tasks"),
          NavigationDestination(icon: SizedBox(
            height: 25.r,
            width: 25.r,
            child: Image.asset("assets/images/loginIcon.png"),
          ), label: "Location"),
          NavigationDestination(icon: SizedBox(
            height: 25.r,
            width: 25.r,
            child: Image.asset("assets/images/loginIcon.png"),
          ), label: "Profile"),

        ]),
      ),
    );
  }
}
