import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexus_frontend/controllers/auth/authController.dart';
import 'package:nexus_frontend/controllers/user/userController.dart';
import 'package:nexus_frontend/models/userModel.dart';


import 'package:nexus_frontend/widgets/sliverAppBar.dart';

import '../../widgets/myForm.dart';
import '../mainScreen.dart';

class RegisterView extends ConsumerStatefulWidget {
   const RegisterView({super.key});




  @override
  ConsumerState<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  final _registerFormKey = GlobalKey<FormState>();

  TextEditingController emailController =  TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authStatus = ref.watch(authControllerProvider);
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
            "Login",
              context,
              ()async{

              UserModel newUser = UserModel(name: nameController.text, email: emailController.text, username: usernameController.text, password: passwordController.text);
              await ref.read(authControllerProvider.notifier).registerUser(newUser);



              },
            [nameController, emailController, usernameController, passwordController],
            authStatus.authStatus, ref

          ),
        ],
      ),
    );
  }
}


