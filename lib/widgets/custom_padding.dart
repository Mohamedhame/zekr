import 'package:flutter/material.dart';

class CustomPadding extends StatelessWidget {
  final String title;
  final TextStyle style;
  const CustomPadding({super.key, required this.title, required this.style});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Text(
        textAlign: TextAlign.center,
        title,
        style: style,
      ),
    );
  }
}
