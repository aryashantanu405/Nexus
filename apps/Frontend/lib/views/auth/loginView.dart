import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexus_frontend/widgets/myForm.dart';
import 'package:nexus_frontend/widgets/sliverAppBar.dart';

final hello = Provider<String>((ref) {
  return "Hello";
});

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _loginFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          myAppBar("Login", "Welcome Back!", "assets/images/loginIcon.png"),
          SliverToBoxAdapter(child: SizedBox(height: 130.r)),
          customForm(
            ["Email", "Password"],
            "Login",
            _loginFormKey,
            "Don't have an account",
            "Register",

          ),
        ],
      ),
    );
  }
}
