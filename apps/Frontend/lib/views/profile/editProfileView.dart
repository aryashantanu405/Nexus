import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexus_frontend/controllers/auth/authController.dart';
import 'package:nexus_frontend/models/userModel.dart';
import 'package:nexus_frontend/widgets/sliverAppBar.dart';

class EditProfileView extends ConsumerStatefulWidget {
  const EditProfileView({super.key});

  @override
  ConsumerState<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  UserModel? myUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

     myUser = ref.read(authControllerProvider).currentUser;
    nameController.text = myUser ?.name ?? "Guest";
    usernameController.text = myUser?.username ?? "xyz";
    emailController.text = myUser?.email ?? "xyz@gmail.com";

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    usernameController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // final myUser = ref.watch(authControllerProvider.select((userstate) => userstate.currentUser));
    //
    // nameController.text = myUser ?.name ?? "Guest";
    // usernameController.text = myUser?.username ?? "xyz";
    // emailController.text = myUser?.email ?? "xyz@gmail.com";
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      body: CustomScrollView(
        slivers: [
          myAppBar(
            "Edit Profile",
            "Update your details",
            "assets/images/loginIcon.png",
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: [
                  _textField("User Name",  nameController),
                  _textField("Email",  emailController),
                  _textField("Username",  usernameController),
                  SizedBox(height: 20.r),
                  _saveButton(ref, nameController, emailController, usernameController, myUser),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


  Widget _textField(String label, TextEditingController myController) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: TextFormField(
        controller: myController,

        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: TextStyle(
            fontSize: 17.sp,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 20.h, // ✅ SPACE BETWEEN LABEL & VALUE
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _saveButton(WidgetRef ref, TextEditingController nameController, TextEditingController emailController, TextEditingController usernameController, UserModel? myUser) {
    return SizedBox(
      width: double.infinity,
      height: 48.r,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff667eea),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        onPressed: () async{
          UserModel updatedUser = UserModel(name: nameController.value.text, email: emailController.value.text, username: usernameController.value.text, password: " ");
          await ref.read(authControllerProvider.notifier).updateUser(updatedUser);
          myUser = ref.read(authControllerProvider).currentUser;
          nameController.text = myUser?.name?? "Guest";
          emailController.text = myUser?.email ?? "xyz@gmail.com";
          usernameController.text = myUser?.username ?? "xyz";

        },
        child:  Consumer(builder: (context, ref, child) {
          final authStatus = ref.watch(authControllerProvider.select((userState) => userState.authStatus));
          return authStatus == AuthStatus.loading ? CircularProgressIndicator() : const Text("Save Changes");
        } ),
      ),
    );
  }

