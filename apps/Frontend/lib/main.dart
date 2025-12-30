import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexus_frontend/controllers/auth/authController.dart';
import 'package:nexus_frontend/controllers/location/locationController.dart';
import 'package:nexus_frontend/views/auth/loginView.dart';
import 'package:nexus_frontend/views/auth/registerView.dart';
import 'package:nexus_frontend/views/mainScreen.dart';
import 'package:nexus_frontend/views/others/splashView.dart';

import 'controllers/task/taskController.dart';

final rootScffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // final service = FlutterBackgroundService();
  //
  // await service.configure(iosConfiguration: IosConfiguration(
  //   onForeground: androidTrackingService, onBackground: (_) async => false,
  // ), androidConfiguration: AndroidConfiguration(onStart: androidTrackingService, isForegroundMode: true,
  // autoStart: false, initialNotificationTitle: "Live Tracking", initialNotificationContent: "Updating location"));
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    debugPrint('BUILD: authStatus = ${authState.authStatus}');

    // Listen is only for side-effects; Riverpod 3.x allows this inside build()
    ref.listen<UserState>(authControllerProvider, (previous, next) {
      debugPrint(
        'LISTEN: auth changed from ${previous?.authStatus} -> ${next.authStatus}',
      );

      // LOGIN: start tasks and start background service (async safely)
      if (previous?.authStatus != AuthStatus.authenticated &&
          next.authStatus == AuthStatus.authenticated) {
        debugPrint(
          'LISTEN: detected login -> fetching tasks and starting tracking service',
        );
        ref.read(taskControllerProvider.notifier).getAllTasks();
        ref.read(locationControllerProvider.notifier).getCurrentLocation();
        String loginMessage = "Login Successful";
        String registerMessage = "Register Successful";
        rootScffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text(
              previous?.authStatus == AuthStatus.notRegistered
                  ? registerMessage
                  : loginMessage,
            ),
          ),
        );

        // Use microtask to avoid awaiting inside listener
        Future.microtask(() async {
          try {
            // await FlutterBackgroundService().startService();
            //debugPrint('Background service start requested');
          } catch (e) {
            //debugPrint('Failed to start background service: $e');
          }
        });
      }

      // LOGOUT: stop service and clean up
      // if (next.authStatus == AuthStatus.unauthenticated) {
      //   debugPrint('LISTEN: detected logout -> invalidating and stopping service');
      //   ref.invalidate(taskControllerProvider);
      //   Future.microtask(() {
      //     FlutterBackgroundService().invoke('stopService');
      //   });
      // }
    });

    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          scaffoldMessengerKey: rootScffoldMessengerKey,
          debugShowCheckedModeBanner: false,
          home: switch (authState.authStatus) {
            AuthStatus.loading => const SplashView(),
            AuthStatus.authenticated => const MainScreen(),
            AuthStatus.unauthenticated => const LoginView(),
            AuthStatus.unknown => const LoginView(),
            AuthStatus.notRegistered => const RegisterView(),
          },
        );
      },
    );
  }
}
