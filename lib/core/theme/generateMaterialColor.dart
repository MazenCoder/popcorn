import 'package:flutter/material.dart';
import 'dart:math';


MaterialColor generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: tintColor(color, 0.9),
    100: tintColor(color, 0.8),
    200: tintColor(color, 0.6),
    300: tintColor(color, 0.4),
    400: tintColor(color, 0.2),
    500: color,
    600: shadeColor(color, 0.1),
    700: shadeColor(color, 0.2),
    800: shadeColor(color, 0.3),
    900: shadeColor(color, 0.4),
  });
}

int tintValue(int value, double factor) =>
    max(0, min((value + ((255 - value) * factor)).round(), 255));

Color tintColor(Color color, double factor) => Color.fromRGBO(
    tintValue(color.red, factor),
    tintValue(color.green, factor),
    tintValue(color.blue, factor),
    1);

int shadeValue(int value, double factor) =>
    max(0, min(value - (value * factor).round(), 255));

Color shadeColor(Color color, double factor) => Color.fromRGBO(
    shadeValue(color.red, factor),
    shadeValue(color.green, factor),
    shadeValue(color.blue, factor),
    1);


// const kOrangeColor = Color(0xfff98414);
// const kDarkBlueColor = Color(0xFF085CA3);
// const kBlackColor = Color(0xff000000);
const kTextLightColor = Color(0xFF959595);


//! Dark Color
final primaryColor = generateMaterialColor(const Color(0xFF7f5af0));
final secondaryColor = generateMaterialColor(const Color(0xFF72757e));
final backgroundColor = generateMaterialColor(const Color(0xFF242629));
final cardBackgroundColor = generateMaterialColor(const Color(0xFF16161a));
final blackColor = generateMaterialColor(const Color(0xFF000000));
final headlineColor = generateMaterialColor(const Color(0xFFfffffe));
final subtextColor = generateMaterialColor(const Color(0xFF94a1b2));
final buttonTextColor = generateMaterialColor(const Color(0xFFfffffe));
final iconColor = generateMaterialColor(const Color(0xFFfffffe));
final errorColor = generateMaterialColor(const Color(0xFFE57373));


// final colorDark = generateMaterialColor(const Color(0xFF07080f));
// final colorLight = generateMaterialColor(const Color(0xFF595a5f));


// final primaryColor = generateMaterialColor(const Color(0xFF223A5E));
// final primaryContainerColor = generateMaterialColor(const Color(0xFF97BAEA));
//
// final tertiaryColor = generateMaterialColor(const Color(0xFF208399));
// final tertiaryContainerColor = generateMaterialColor(const Color(0xFFCCF3FF));
//
// final errorColor = generateMaterialColor(const Color(0xFFB00020));
// final errorContainerColor = generateMaterialColor(const Color(0xFFFCD8DF));
//
//
// final backgroundColor = generateMaterialColor(const Color(0xFF242629));
// final backgroundLite = generateMaterialColor(const Color(0xFFfffffe));
// final cardBackgroundColor = generateMaterialColor(const Color(0xFF16161a));
// final headlineColor = generateMaterialColor(const Color(0xFFfffffe));
// final cardHeadingColor = generateMaterialColor(const Color(0xFFfffffe));
// final subHeadlineColor = generateMaterialColor(const Color(0xFF94a1b2));
// final cardParagraphColor = generateMaterialColor(const Color(0xFF94a1b2));

/*
//! Icons
final strokeColor = generateMaterialColor(const Color(0xFF010101));
final mainColor = generateMaterialColor(const Color(0xFFfffffe));
final highlightColor = generateMaterialColor(const Color(0xFF7f5af0));
// final tertiaryColor = generateMaterialColor(const Color(0xFF2cb67d));
final secondaryColor = generateMaterialColor(const Color(0xFF72757e));

 */

// Text Style
const titleTextStyle = TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold);
const headingTextStyle = TextStyle(fontSize: 22, fontWeight: FontWeight.w600);
const subTextStyle = TextStyle(fontSize: 16, color: kTextLightColor);