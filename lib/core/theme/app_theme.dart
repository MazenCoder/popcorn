import 'package:popcorn/core/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'generateMaterialColor.dart';
import 'package:get/get.dart';


class AppTheme {

  /*
  static ThemeData customLightTheme = FlexThemeData.light(
    scheme: FlexScheme.deepBlue,
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
    blendLevel: 10,
    appBarOpacity: 0.95,
    tabBarStyle: FlexTabBarStyle.flutterDefault,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 16,
      blendOnColors: false,
      dialogBackgroundSchemeColor: SchemeColor.tertiaryContainer,
      bottomNavigationBarSelectedLabelSchemeColor: SchemeColor.primary,
      bottomNavigationBarUnselectedLabelSchemeColor: SchemeColor.onInverseSurface,
      bottomNavigationBarSelectedIconSchemeColor: SchemeColor.primary,
      bottomNavigationBarUnselectedIconSchemeColor: SchemeColor.onInverseSurface,
      bottomNavigationBarBackgroundSchemeColor: SchemeColor.inversePrimary,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    fontFamily: GoogleFonts.cairo().fontFamily,
  );

  static ThemeData customDarkTheme = FlexThemeData.dark(
    scheme: FlexScheme.deepBlue,
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
    blendLevel: 10,
    appBarOpacity: 0.90,
    tabBarStyle: FlexTabBarStyle.flutterDefault,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 16,
      dialogBackgroundSchemeColor: SchemeColor.tertiaryContainer,
      bottomNavigationBarSelectedLabelSchemeColor: SchemeColor.primary,
      bottomNavigationBarUnselectedLabelSchemeColor: SchemeColor.onInverseSurface,
      bottomNavigationBarSelectedIconSchemeColor: SchemeColor.primary,
      bottomNavigationBarUnselectedIconSchemeColor: SchemeColor.onInverseSurface,
      bottomNavigationBarBackgroundSchemeColor: SchemeColor.inversePrimary,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    fontFamily: GoogleFonts.cairo().fontFamily,
  );

  */


  //! Dark
  static ThemeData customDarkTheme = ThemeData.dark().copyWith(
    primaryColor: primaryColor,
    backgroundColor: backgroundColor,
    cardTheme: CardTheme(color: cardBackgroundColor),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundColor,
    textTheme: CustomTextTheme.textThemeDark,
    cardColor: cardBackgroundColor,
    primaryTextTheme: CustomTextTheme.textThemeDark,
    errorColor: errorColor,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              )
          )
      ),
    ),
    primaryIconTheme: const IconThemeData.fallback().copyWith(
      color: iconColor,
    ),
    iconTheme: IconThemeData(color: iconColor),
    indicatorColor: iconColor,
    buttonTheme: ButtonThemeData(
      buttonColor: primaryColor,
      textTheme: ButtonTextTheme.primary,
      disabledColor: secondaryColor,
      colorScheme: ColorScheme.dark(background: primaryColor),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: primaryColor,
      selectionColor: primaryColor,
      selectionHandleColor: primaryColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: Get.theme.textTheme.subtitle2?.copyWith(
        color: headlineColor
      ),
      focusColor: headlineColor,
      fillColor: headlineColor,
      suffixIconColor: headlineColor,
      suffixStyle: Get.theme.textTheme.subtitle2,
      hintStyle: Get.theme.textTheme.subtitle2?.copyWith(
        color: secondaryColor
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: subtextColor,
          width: 1.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: subtextColor,
          width: 1.0,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: errorColor,
          width: 1.0,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: errorColor,
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: primaryColor,
          width: 1.5,
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
    ),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith<Color?>((s) {
            if (s.contains(MaterialState.disabled)) return headlineColor;
            return headlineColor; // Enabled text color
          }),
        )
    ),
  );




  //! Light
  static ThemeData customLightTheme = ThemeData.light().copyWith(
    brightness: Brightness.light,
    textTheme: CustomTextTheme.textThemeLight,
    primaryTextTheme: CustomTextTheme.textThemeLight,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      centerTitle: true,
    ),
    backgroundColor: backgroundColor,
    scaffoldBackgroundColor: backgroundColor,
    errorColor: errorColor,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              )
          )
      ),
    ),
    primaryIconTheme: const IconThemeData.fallback().copyWith(
      color: primaryColor,
    ),
    iconTheme: IconThemeData(color: blackColor),
    indicatorColor: blackColor,
    buttonTheme: ButtonThemeData(
      focusColor: blackColor,
      buttonColor: primaryColor,
      textTheme: ButtonTextTheme.primary,
      disabledColor: secondaryColor,
      colorScheme: ColorScheme.dark(background: primaryColor),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: primaryColor,
      selectionColor: primaryColor,
      selectionHandleColor: primaryColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: Get.theme.textTheme.subtitle2?.copyWith(
        color: blackColor
      ),
      focusColor: blackColor,
      fillColor: blackColor,
      suffixIconColor: blackColor,
      suffixStyle: Get.theme.textTheme.subtitle2,
      hintStyle: Get.theme.textTheme.subtitle2?.copyWith(
        color: Colors.grey,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: secondaryColor,
          width: 1.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: secondaryColor,
          width: 1.0,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: errorColor,
          width: 1.0,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: errorColor,
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: primaryColor,
          width: 1.5,
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color?>((s) {
          if (s.contains(MaterialState.disabled)) return Colors.grey; // Disabled text color
          return primaryColor; // Enabled text color
        }),
        // foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
        // textStyle: MaterialStateProperty.all(primaryColor)
      )
    ),
  );

}



