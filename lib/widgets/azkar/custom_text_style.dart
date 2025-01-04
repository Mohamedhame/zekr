import 'package:flutter/material.dart';

class CustomTextStyle extends StatelessWidget {
  final String title;
  final Color background;
  final TextStyle? style;
  final double padd;

  const CustomTextStyle(
      {super.key,
      required this.title,
      required this.background,
      this.style,
      required this.padd});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(8),
        padding: EdgeInsets.symmetric(vertical: padd, horizontal: 8),
        decoration: BoxDecoration(
            color: background, borderRadius: BorderRadius.circular(12)),
        child: Text(
          title,
          style: style,
        ));
  }
}
