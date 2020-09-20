import 'package:flutter/material.dart';

class Burnt {
  /// Colors
  static const materialPrimary = Colors.blue;
  static const primary = Colors.blue;
  static const primaryLight = Color(0xFF42A5F5);
  static const primaryExtraLight = Color(0xFFBBDEFB);
  static const textBodyColor = Color(0xDD604B41);
  static const anchorColor = Color(0xFF51A4FF);
  static const hintTextColor = Color(0xBB604B41);
  static const lightTextColor = Color(0x82604B41);
  static const primaryTextColor = Color(0xFF42A5F5);
  static const paper = Color(0xFFFAFAFA);
  static const separator = Color(0xFFEEEEEE);
  static const separatorBlue = Color(0x16007AFF);
  static const lightGrey = Color(0x44604B41);
  static const iconGrey = Color(0x44604B41);
  static const iconOrange = Color(0xFFBBDEFB);
  static const splashOrange = Color(0xFFE3F2FD);
  static const imgPlaceholderColor = Color(0x08604B41);
  static const lightBlue = Color(0x6C007AFF);
  static const blue = Color(0xFF007AFF);
  static const darkBlue = Color(0xFF4A83C4);

  /// Fonts
  static const fontBase = 'PTSans';
  static const fontFancy = 'GrandHotel';
  static const fontLight = FontWeight.w100;
  static const fontLean = FontWeight.w400;
  static const fontBold = FontWeight.w600;
  static const fontExtraBold = FontWeight.w800;
  static var display4 = TextStyle(fontSize: 28.0);
  static var bodyStyle =
      TextStyle(color: textBodyColor, fontSize: 14.0, fontFamily: Burnt.fontBase, fontWeight: Burnt.fontLight);
  static var appBarTitleStyle = TextStyle(
      color: Burnt.primary,
      fontSize: 22.0,
      fontFamily: Burnt.fontBase,
      fontWeight: Burnt.fontLight,
      letterSpacing: 3.0);
  static var titleStyle = TextStyle(fontSize: 20.0, fontWeight: Burnt.fontBold);

  /// Gradients
  static const burntGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0, 0.5, 1.0],
    colors: [Color(0xFFFFC86B), Color(0xFFFFAB40), Color(0xFFC45D35)],
  );
  static const buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0, 0.3],
    colors: [Color(0xFFFFC86B), Color(0xFFFFB655)],
  );

  static ThemeData getTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Burnt.materialPrimary,
      accentColor: Burnt.materialPrimary,
      fontFamily: Burnt.fontBase,
      cursorColor: Burnt.primary,
      textTheme: Theme.of(context)
          .textTheme
          .apply(
            bodyColor: Burnt.textBodyColor,
            displayColor: Burnt.textBodyColor,
            fontFamily: Burnt.fontBase,
          )
          .merge(TextTheme(
          bodyText2: TextStyle(fontSize: 22.0),
      )),
    );
  }
}
