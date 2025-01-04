import 'package:flutter/material.dart';

BoxDecoration styleDecoration({double l = 0, double r = 0}) {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xff303151).withOpacity(0.6),
        const Color(0xff303151).withOpacity(0.9),
      ],
    ),
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(l), topRight: Radius.circular(r)),
  );
}
