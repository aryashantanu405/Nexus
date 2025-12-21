import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:nexus_frontend/widgets/sliverAppBar.dart';

import '../../widgets/myForm.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  final _registerFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          myAppBar("Register", "Welcome!", "assets/images/loginIcon.png"),
          SliverToBoxAdapter(child: SizedBox(height: 100.r)),
          customForm(
            ["Name", "Email", "Username", "Password"],
            "Submit",
            _registerFormKey,
            "Already have an account",
            "Login"
          ),
        ],
      ),
    );
  }
}
