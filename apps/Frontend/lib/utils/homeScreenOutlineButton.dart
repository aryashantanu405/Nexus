import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

SizedBox HomeScreenOutlinedButton(
  String imagePath,
  String buttonName,
  VoidCallback onPressed,
) {
  return SizedBox(
    height: 50.r,
    width: 160.r, // ✅ GIVE ENOUGH WIDTH
    child: OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(
          width: 2,
          color: Color(0xff667eea),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // ✅ PREVENT OVERFLOW
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: 16.r,
            width: 16.r,
          ),
          SizedBox(width: 6.r),

          /// ✅ TEXT WILL NEVER OVERFLOW NOW
          Flexible(
            child: Text(
              buttonName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xff667eea),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
