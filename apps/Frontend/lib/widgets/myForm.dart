import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexus_frontend/services/providers/textFieldProviders.dart';
import 'package:nexus_frontend/utils/image_link.dart';
import 'package:nexus_frontend/widgets/gradientButton.dart';

SliverToBoxAdapter customForm(
  List<String> fields,
  String buttonName1,
  GlobalKey<FormState> formKey,
  String instruction,
  String buttonName2,
) {
  return SliverToBoxAdapter(
    child: Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.r),
        child: Card(
          elevation: .2,
          color: Color(0xffFDFEFD),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  ...fields.map((label) {
                    return Column(
                      children: [
                        label == "Password"
                            ? passwordField(label)
                            : TextFormField(
                              decoration: InputDecoration(
                                prefixIcon: customPrefixIcon(
                                  ImageLink.imageLink[label.toLowerCase()] ??
                                      "",
                                ),
                                hintText: label,
                                hintStyle: TextStyle(fontSize: 14.r),
                                border: UnderlineInputBorder(
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
                  }),

                  SizedBox(height: 5.r),

                  SizedBox(
                    width: 180.r,
                    child: GradientButton(
                      onPressed: () {
                        formKey.currentState?.validate();
                      },
                      height: 35.r,
                      child: Text(
                        buttonName1,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 5.r),

                  moreInstructionWidget(instruction, buttonName2),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Row moreInstructionWidget(String instruction, String buttonName) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text("$instruction? "),
      TextButton(
        onPressed: () {},
        style: ButtonStyle(
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          ),
        ),
        child: Text(buttonName),
      ),
    ],
  );
}

Consumer passwordField(String label) {
  return Consumer(
    builder: (context, ref, child) {
      final currentState = ref.watch(passwordProvider);
      return TextFormField(
        obscureText: currentState,
        decoration: InputDecoration(
          prefixIcon: customPrefixIcon(ImageLink.imageLink["password"] ?? ""),
          hintText: label,
          hintStyle: TextStyle(fontSize: 14.r),
          border: UnderlineInputBorder(
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
