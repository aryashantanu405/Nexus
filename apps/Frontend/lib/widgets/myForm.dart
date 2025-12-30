import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexus_frontend/controllers/auth/authController.dart';
import 'package:nexus_frontend/services/providers/textFieldProviders.dart';
import 'package:nexus_frontend/utils/image_link.dart';
import 'package:nexus_frontend/views/auth/loginView.dart';
import 'package:nexus_frontend/views/auth/registerView.dart';
import 'package:nexus_frontend/widgets/gradientButton.dart';

SliverToBoxAdapter customForm(
  List<String> fields,
  String buttonName1,
  GlobalKey<FormState> formKey,
  String instruction,
  String buttonName2,
  BuildContext context,
  Function() onPress,
  List<TextEditingController> textEditingControllers,
    AuthStatus authState,
    WidgetRef ref
) {
  return SliverToBoxAdapter(
    child: Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.r),
        child: Card(
          elevation: .2.r,
          color: const Color(0xffFDFEFD),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: fields.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          fields[index] == "Password"
                              ? passwordField(fields[index], textEditingControllers[index])
                              : TextFormField(
                            controller: textEditingControllers[index],
                                decoration: InputDecoration(
                                  prefixIcon: customPrefixIcon(
                                    ImageLink.imageLink[fields[index]
                                            .toLowerCase()] ??
                                        "",
                                  ),
                                  hintText: fields[index],
                                  hintStyle: TextStyle(fontSize: 14.r),
                                  border: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xff667EEA),
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "This field can't be empty";
                                  }
                                  return null;
                                },
                              ),

                          SizedBox(height: 20.r),
                        ],
                      );
                    },
                  ),

                  SizedBox(height: 5.r),

                  SizedBox(
                    width: 180.r,
                    child: GradientButton(
                      onPressed: () {
                        formKey.currentState?.validate();
                        onPress();
                      },
                      height: 35.r,
                      child: authState == AuthStatus.loading ? const CircularProgressIndicator():  Text(
                        buttonName1,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 5.r),

                  moreInstructionWidget(instruction, buttonName2, context, ref),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Row moreInstructionWidget(String instruction, String buttonName, BuildContext context, WidgetRef ref) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text("$instruction? "),
      TextButton(
        onPressed: () {
          if(buttonName == "Register")
            {
              ref.read(authControllerProvider.notifier).goToRegisterScreen();
            }
          else{
            ref.read(authControllerProvider.notifier).goToLoginScreen();
          }
        },
        style: const ButtonStyle(
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          ),
        ),
        child: Text(buttonName),
      ),
    ],
  );
}

Consumer passwordField(String label, TextEditingController passwordController) {
  return Consumer(
    builder: (context, ref, child) {
      final currentState = ref.watch(passwordProvider);
      return TextFormField(
        obscureText: currentState,
        controller: passwordController,
        decoration: InputDecoration(
          prefixIcon: customPrefixIcon(ImageLink.imageLink["password"] ?? ""),
          hintText: label,
          hintStyle: TextStyle(fontSize: 14.r),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xff667EEA)),
          ),
          suffixIcon: IconButton(
            onPressed: () {
              ref
                  .read(passwordProvider.notifier)
                  .changePasswordState(!currentState);
            },
            icon:
                currentState
                    ? customPrefixIcon(
                      ImageLink.imageLink["hidepassword"] ?? "",
                    )
                    : customPrefixIcon(
                      ImageLink.imageLink["showpassword"] ?? "",
                    ),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "This field can't be empty";
          }
          return null;
        },
      );
    },
  );
}

SizedBox customPrefixIcon(String imagePath) {
  return SizedBox(
    height: 30.r,
    width: 30.r,
    child: Image(image: AssetImage(imagePath)),
  );
}
