import 'package:flutter/material.dart';

SliverAppBar myAppBar(String heading, String subheading, String imagePath) {
  return SliverAppBar(
    pinned: true,
    toolbarHeight: 80,
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff667eea), Color(0xff764ba2)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50,
                  width: 50,
                  child: Image.asset(imagePath)),
              Text(heading, style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 1,
                fontFamily: 'Inter'
              ),)
            ],
          ),

          Text(subheading, style: TextStyle(color: Colors.white, fontFamily: "Inter", letterSpacing: .3),)
        ],
      ),
    ),
  );
}
