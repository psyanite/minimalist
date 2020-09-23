import 'package:flutter/material.dart';
import 'package:minimalist/state/settings/settings_state.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class Themer {
  static final Themer _singleton = Themer._internal();

  static ThemeChoice _chosenTheme = ThemeChoice.blue;
  static Color _mainColor = Colors.blue;

  static FontChoice _chosenFont = FontChoice.ptSans;
  static String _mainFont = 'ptsans';

  static ContentAlign _chosenContentAlign = ContentAlign.center;
  static VerticalContentAlign _chosenVerticalContentAlign = VerticalContentAlign.top;

  Themer._internal();

  // Setup

  init(ThemeChoice theme, FontChoice font, ContentAlign contentAlign) {
    _chosenTheme = theme;
    _chosenFont = font;
    _chosenContentAlign = contentAlign;
    _refresh();
  }

  setChosenTheme(ThemeChoice theme) {
    _chosenTheme = theme;
    _refresh();
  }

  setChosenFont(FontChoice font) {
    _chosenFont = font;
    _refresh();
  }

  setContentAlign(ContentAlign contentAlign) {
    _chosenContentAlign = contentAlign;
  }
  contentAlign() => _chosenContentAlign;

  setVerticalContentAlign(VerticalContentAlign contentAlign) {
    _chosenVerticalContentAlign = contentAlign;
  }
  verticalContentAlign() => _chosenVerticalContentAlign;


  /// Colors
  Color _white = Colors.white;
  white() => Color(0xFFFFFF);

  Color _materialPrimary = Colors.blue;
  materialPrimary() => _mainColor;

  static const _defaultPrimary = Colors.blue;
  Color _primary = _defaultPrimary;
  primary() => _primary;

  Color _primaryLight = Color(0xFF42A5F5);
  primaryLight() => _primaryLight;

  Color _primaryExtraLight = Color(0xFFBBDEFB);
  primaryExtraLight() => _primaryExtraLight;

  static const _defaultTextBodyColor = Color(0xDD646464);
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

  Color _splashPrimary = Color(0xFFE3F2FD);
  splashPrimary() => _splashPrimary;

  Color _imgPlaceholderColor = Color(0x08604B41);
  imgPlaceholderColor() => _imgPlaceholderColor;

  Color _lightBlue = Color(0x6C007AFF);
  lightBlue() => _lightBlue;

  Color _blue = Color(0xFF007AFF);
  blue() => _blue;

  Color _darkBlue = Color(0xFF4A83C4);
  darkBlue() => _darkBlue;

  Color _ringColor = Colors.grey[200];
  ringColor() => _ringColor;


  /// Fonts
  static const _defaultFontBase = 'PTSans';
  static const _defaultFontFancy = 'GrandHotel';

  String _fontBase = _defaultFontBase;
  fontBase() => _fontBase;

  String _fontFancy = _defaultFontFancy;
  fontFancy() => _fontFancy;

  static const _defaultFontLight = FontWeight.w100;
  FontWeight _fontLight = _defaultFontLight;
  fontLight() => _fontLight;

  static const _defaultFontLean = FontWeight.w400;
  FontWeight _fontLean = _defaultFontLean;
  fontLean() => _fontLean;

  static const _defaultFontBold = FontWeight.w600;
  FontWeight _fontBold = _defaultFontBold;
  fontBold() => _fontBold;

  FontWeight _fontExtraBold = FontWeight.w800;
  fontExtraBold() => _fontExtraBold;

  TextStyle _display4 = TextStyle(fontSize: 28.0);

  TextStyle _bodyStyle = TextStyle(
      color: _defaultTextBodyColor, fontSize: 14.0, fontFamily: _defaultFontBase, fontWeight: _defaultFontLight);

  TextStyle _appBarTitleStyle = TextStyle(
      color: _defaultPrimary,
      fontSize: 22.0,
      fontFamily: _defaultFontBase,
      fontWeight: _defaultFontLight,
      letterSpacing: 3.0);
  appBarTitleStyle() => _appBarTitleStyle;

  TextStyle _listNameTitleStyle = TextStyle(fontSize: 28.0, fontWeight: _defaultFontBold);
  listNameTitleStyle() => _listNameTitleStyle;

  /// Gradients
  static const _burntGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0, 0.5, 1.0],
    colors: [Color(0xFFFFC86B), Color(0xFFFFAB40), Color(0xFFC45D35)],
  );
  burntGradient() => _burntGradient;

  static const _buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0, 0.3],
    colors: [Color(0xFFFFC86B), Color(0xFFFFB655)],
  );
  buttonGradient() => _buttonGradient;

  ThemeData getThemeData() {
    final defaultTheme = ThemeData(brightness: Brightness.light);
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: materialPrimary(),
      accentColor: materialPrimary(),
      fontFamily: fontBase(),
      cursorColor: primary(),
      textTheme: defaultTheme.textTheme
          .apply(bodyColor: textBodyColor(), displayColor: textBodyColor(), fontFamily: fontBase())
          .merge(TextTheme(bodyText2: TextStyle(fontSize: 18.0))),
    );
  }

  void updateTheme(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    final themeData = getThemeData();
    themeNotifier.setTheme(themeData);
  }

  _refresh() {
    _updateColors();
    _updateTextStyles();
  }

  _updateColors() {
    var mainColor;
    switch (_chosenTheme) {
      case ThemeChoice.cyan: { mainColor = Colors.cyan; } break;
      case ThemeChoice.indigo: { mainColor = Colors.indigo; } break;
      case ThemeChoice.blue: { mainColor = Colors.blue; } break;
      case ThemeChoice.blueGrey: { mainColor = Colors.blueGrey; } break;
      case ThemeChoice.grey: { mainColor = Colors.grey; } break;
      default: { mainColor = Colors.blue; } break;
    }

    _materialPrimary = mainColor;
    _primary = mainColor;

    /// TODO: Add more colors
  }

  _updateTextStyles() {
    switch (_chosenFont) {
      case FontChoice.ptSans: { _mainFont = 'PTSans'; } break;
      case FontChoice.productSans: { _mainFont = 'ProductSans'; } break;
      default: { _mainFont = 'PTSans'; } break;
    }

    var isPtSans = _chosenFont == FontChoice.ptSans;

    _fontBase = _mainFont;

    _textBodyColor = isPtSans
      ? _defaultTextBodyColor : Color(0xCC646464);

    _bodyStyle = TextStyle(color: textBodyColor(), fontSize: 14.0, fontFamily: _fontBase, fontWeight: _fontLight);

    _appBarTitleStyle = isPtSans
      ? TextStyle(
      color: _primary,
      fontSize: 22.0,
      fontFamily: _fontBase,
      fontWeight: _fontLight,
      letterSpacing: 3.0)
    : TextStyle(
      color: _primary,
      fontSize: 22.0,
      fontFamily: _fontBase,
      fontWeight: FontWeight.w300,
      letterSpacing: 3.0);
  }

  factory Themer() {
    return _singleton;
  }
}

enum ThemeChoice { cyan, indigo, blue, blueGrey, grey }

enum FontChoice { ptSans, productSans }
