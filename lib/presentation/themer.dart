import 'package:flutter/material.dart';

class Themer {
  static final Themer _singleton = Themer._internal();
  static ThemeChoice _chosenTheme = ThemeChoice.blue;
  static Color _mainColor = Colors.blue;

  Themer._internal();

  /// Colors

  Color _materialPrimary = Colors.blue;

  materialPrimary() => _mainColor;

  static const _defaultPrimary = Colors.blue;
  Color _primary = _defaultPrimary;

  primary() => _primary;

  Color _primaryLight = Color(0xFF42A5F5);

  primaryLight() => _primaryLight;

  Color _primaryExtraLight = Color(0xFFBBDEFB);

  primaryExtraLight() => _primaryExtraLight;

  static const _defaultTextBodyColor = Color(0xDD604B41);
  Color _textBodyColor = _defaultTextBodyColor;

  textBodyColor() => _textBodyColor;

  Color _anchorColor = Color(0xFF51A4FF);

  anchorColor() => _anchorColor;

  Color _hintTextColor = Color(0xBB604B41);

  hintTextColor() => _hintTextColor;

  Color _lightTextColor = Color(0x82604B41);

  lightTextColor() => _lightTextColor;

  Color _primaryTextColor = Color(0xFF42A5F5);

  primaryTextColor() => _primaryTextColor;

  Color _paper = Color(0xFFFAFAFA);

  paper() => _paper;

  Color _separator = Color(0xFFEEEEEE);

  separator() => _separator;

  Color _separatorBlue = Color(0x16007AFF);

  separatorBlue() => _separatorBlue;

  Color _lightGrey = Color(0x44604B41);

  lightGrey() => _lightGrey;

  Color _iconGrey = Color(0x44604B41);

  iconGrey() => _iconGrey;

  Color _iconOrange = Color(0xFFBBDEFB);

  iconOrange() => _iconOrange;

  Color _splashOrange = Color(0xFFE3F2FD);

  splashOrange() => _splashOrange;

  Color _imgPlaceholderColor = Color(0x08604B41);

  imgPlaceholderColor() => _imgPlaceholderColor;

  Color _lightBlue = Color(0x6C007AFF);

  lightBlue() => _lightBlue;

  Color _blue = Color(0xFF007AFF);

  blue() => _blue;

  Color _darkBlue = Color(0xFF4A83C4);

  darkBlue() => _darkBlue;

  /// Fonts
  static const _defaultFontBase = 'PTSans';
  static const _defaultFontFancy = 'GrandHotel';

  String _fontBase = _defaultFontBase;

  fontBase() => _fontBase;

  String _fontFancy = _defaultFontFancy;

  fontFancy() => _fontFancy;

  static const _defaultFontLight = FontWeight.w100;
  FontWeight _fontLight = _defaultFontLight;

  static const _defaultFontLean = FontWeight.w400;
  FontWeight _fontLean = _defaultFontLean;

  static const _defaultFontBold = FontWeight.w600;
  FontWeight _fontBold = _defaultFontBold;

  FontWeight _fontExtraBold = FontWeight.w800;

  TextStyle _display4 = TextStyle(fontSize: 28.0);

  TextStyle _bodyStyle = TextStyle(
      color: _defaultTextBodyColor, fontSize: 14.0, fontFamily: _defaultFontBase, fontWeight: _defaultFontLight);

  TextStyle _appBarTitleStyle = TextStyle(
      color: _defaultPrimary,
      fontSize: 22.0,
      fontFamily: _defaultFontBase,
      fontWeight: _defaultFontLight,
      letterSpacing: 3.0);

  static var titleStyle = TextStyle(fontSize: 20.0, fontWeight: _defaultFontBold);

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

  ThemeData getTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: materialPrimary(),
      accentColor: materialPrimary(),
      fontFamily: fontBase(),
      cursorColor: primary(),
      textTheme: Theme.of(context)
          .textTheme
          .apply(bodyColor: textBodyColor(), displayColor: textBodyColor(), fontFamily: fontBase())
          .merge(TextTheme(bodyText2: TextStyle(fontSize: 18.0))),
    );
  }

  _setColors(ThemeChoice theme) {
    var mainColor;
    switch (theme) {
      case ThemeChoice.cyan: { mainColor = Colors.cyan; } break;
      case ThemeChoice.indigo: { mainColor = Colors.indigo; } break;
      case ThemeChoice.blue: { mainColor = Colors.blue; } break;
      case ThemeChoice.blueGrey: { mainColor = Colors.blueGrey; } break;
      case ThemeChoice.grey: { mainColor = Colors.grey; } break;
      default: { mainColor = Colors.blue; } break;
    }
  }

  factory Themer({ThemeChoice theme, FontChoice font}) {
    if (theme != null) {
      _chosenTheme = theme;
      _setColors(theme);
    }

    if (font != null) _chosenFont = font;

    return _singleton;
  }
}

enum ThemeChoice { cyan, indigo, blue, blueGrey, grey }

enum FontChoice { ptsans }
