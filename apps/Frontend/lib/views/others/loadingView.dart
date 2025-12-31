import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 500.r,
              width: 500.r,
              child: Image(image: AssetImage("assets/images/splashIcon.jpeg")),
            ),

            SizedBox(
              height: 35.r,
                width: 35.r,
                child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
