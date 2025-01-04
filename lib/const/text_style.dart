import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zekr/const/const.dart';

Color text = textColor;
TextStyle ourStyle(
    {double? size = 14,
    Color color = const Color(0xffffffff),
    FontWeight fontWeight = FontWeight.normal}) {
  return GoogleFonts.amiri(
      color: color, fontSize: size, fontWeight: fontWeight);
}
