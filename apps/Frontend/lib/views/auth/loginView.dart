import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:nexus_frontend/controllers/auth/authController.dart';
import 'package:nexus_frontend/widgets/myForm.dart';
import 'package:nexus_frontend/widgets/sliverAppBar.dart';
import 'package:nexus_frontend/views/others/termsAndConditionsView.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _loginFormKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      body: CustomScrollView(
        slivers: [
          myAppBar(
            "Login",
            "Welcome Back!",
            "assets/images/loginIcon.png",
          ),

          SliverToBoxAdapter(child: SizedBox(height: 100.h)),

          /// LOGIN FORM
          customForm(
            ["Email", "Password"],
            "Login",
            _loginFormKey,
            "Don't have an account",
            "Register",
            context,
            () async {
              await ref
                  .read(authControllerProvider.notifier)
                  .login(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );
            },
            [emailController, passwordController],
            authState.authStatus,
            ref,
          ),

          /// TERMS & CONDITIONS
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: 24.h, top: 16.h),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TermsAndConditionsView(),
                      ),
                    );
                  },
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "By continuing, you agree to our\n",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12.sp,
                      ),
                      children: const [
                        TextSpan(
                          text: "Terms & Conditions",
                          style: TextStyle(
                            color: Color(0xff667eea),
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
