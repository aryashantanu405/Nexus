import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

SizedBox HomeScreenOutlinedButton(String imagePath, String buttonName) {
  return SizedBox(
    height: 50.r,
    child: OutlinedButton(
      onPressed: () {},
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll(Size(50.r, 50.r)),
        maximumSize: WidgetStatePropertyAll(Size(140.r, 140.r)),
        side: WidgetStatePropertyAll(BorderSide(width: 2,color: Color(0xff667eea))),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
      child: Center(
        child: Row(
          children: [
            Image(image: AssetImage(imagePath), height: 15.r, width: 15.r),
            SizedBox(width: 3.r,),
            Text(buttonName, style: TextStyle(color: Color(0xff667eea))),
          ],
        ),
      ),
    ),
  );
}
