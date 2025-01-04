import 'package:flutter/material.dart';
import 'package:zekr/const/text_style.dart';

class AzkarButton extends StatelessWidget {
  const AzkarButton({
    super.key,
    required this.title,
    required this.changeColor,
    required this.textColor,
    required this.background,
  });
  final String title;
  final Function changeColor;
  final Color textColor;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        changeColor();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          title,
          style: ourStyle(color: textColor, size: 28),
        ),
      ),
    );
  }
}
