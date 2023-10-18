import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:popcorn/core/theme/generateMaterialColor.dart';

// Custom Text Styles Class For Both Dark and Light Theme
class CustomTextTheme {

  static const _textColorLight = Color(0xff0f0e17);
  static const _textColorDark = Color(0xffffffff);

  static TextTheme get textThemeLight {
    return _textTheme(textColor: _textColorLight);
  }

  static TextTheme get textThemeDark {
    return _textTheme(textColor: _textColorDark);
  }

  // Private Method For Text Theme so that we can change the vale for Both Dark And Light Theme
  static TextTheme _textTheme({required Color textColor}) {
    const FontWeight light = FontWeight.w300;
    const FontWeight medium = FontWeight.w500;
    const FontWeight regular = FontWeight.w400;

    return TextTheme(
      headline1: GoogleFonts.cairo(
        fontSize: 96,
        color: textColor,
        fontWeight: light,
        letterSpacing: -1.5,
      ),
      headline2: GoogleFonts.cairo(
        color: textColor,
        fontSize: 60,
        fontWeight: light,
        letterSpacing: -0.5,
      ),
      headline3: GoogleFonts.cairo(
        color: textColor,
        fontSize: 48,
        fontWeight: regular,
        letterSpacing: 0.0,
      ),
      headline4: GoogleFonts.cairo(
        color: textColor,
        fontSize: 34,
        fontWeight: regular,
        letterSpacing: 0.25,
      ),
      headline5: GoogleFonts.cairo(
        color: textColor,
        fontSize: 24,
        fontWeight: regular,
        letterSpacing: 0.0,
      ),
      headline6: GoogleFonts.cairo(
        color: textColor,
        fontSize: 20,
        fontWeight: medium,
        letterSpacing: 0.15,
      ),
      bodyText1: GoogleFonts.cairo(
        color: textColor,
        fontSize: 16,
        fontWeight: regular,
        letterSpacing: 0.5,
      ),
      bodyText2: GoogleFonts.cairo(
        color: textColor,
        fontSize: 14,
        fontWeight: regular,
        letterSpacing: 0.25,
      ),
      subtitle1: GoogleFonts.cairo(
        color: textColor,
        fontSize: 15,
        fontWeight: regular,
        letterSpacing: 0.5,
      ),
      subtitle2: GoogleFonts.cairo(
        color: textColor,
        fontSize: 14,
        fontWeight: regular,
        letterSpacing: 0.5,
      ),
      button: GoogleFonts.cairo(
        color: textColor,
        fontSize: 14,
        fontWeight: medium,
        letterSpacing: 1.25,
      ),
      caption: GoogleFonts.cairo(
        color: textColor,
        fontSize: 12,
        fontWeight: regular,
        letterSpacing: 0.4,
      ),
      overline: GoogleFonts.cairo(
        color: textColor,
        fontSize: 10,
        fontWeight: regular,
        letterSpacing: 1.5,
      ),
    );
  }
}
