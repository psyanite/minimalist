import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minimalist/state/settings/settings_state.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class Themer {
  static final Themer _singleton = Themer._internal();

  Themer._internal();

  init(SettingsState settings) {
    _chosenFont = settings.fontChoice;
    _chosenVerticalContentAlign = settings.verticalContentAlign;
    _autoDeleteDoneItems = settings.autoDeleteDoneItems;
    _moveDoneItemsToTheBottom = settings.moveDoneItemsToTheBottom;
    _darkModeChoice = settings.darkModeChoice;
    _refresh();
  }

  static ThemeChoice _chosenTheme = ThemeChoice.blue;
  static Color _mainColor = Colors.blue;
  setChosenTheme(ThemeChoice v) {
    _chosenTheme = v;
    _refresh();
  }

  static FontChoice _chosenFont = FontChoice.ptSans;
  static String _mainFont = 'ptsans';
  setChosenFont(FontChoice v) {
    _chosenFont = v;
    _refresh();
  }

  static ContentAlign _chosenContentAlign = ContentAlign.center;
  setContentAlign(ContentAlign v) {
    _chosenContentAlign = v;
  }
  contentAlign() => _chosenContentAlign;

  static VerticalContentAlign _chosenVerticalContentAlign = VerticalContentAlign.top;
  setVerticalContentAlign(VerticalContentAlign v) {
    _chosenVerticalContentAlign = v;
  }
  verticalContentAlign() => _chosenVerticalContentAlign;

  static bool _autoDeleteDoneItems = false;
  setAutoDeleteDoneItems(bool v) {
    _autoDeleteDoneItems = v;
  }
  autoDeleteDoneItems() => _autoDeleteDoneItems;

  static bool _moveDoneItemsToTheBottom = false;
  setMoveDoneItemsToTheBottom(bool v) {
    _moveDoneItemsToTheBottom = v;
  }
  moveDoneItemsToTheBottom() => _moveDoneItemsToTheBottom;

  static DarkModeChoice _darkModeChoice = DarkModeChoice.auto;
  setDarkModeChoice(DarkModeChoice v) {
    _darkModeChoice = v;
  }
  darkModeChoice() => _darkModeChoice;

  /// Colors
  Color _white = Colors.white;
  white() => _white;

  materialPrimary() => _mainColor;

  static const _defaultPrimary = Colors.blue;
  Color _primary = _defaultPrimary;
  primary() => _primary;

  Color _primaryLight = Color(0xFF42A5F5);
  primaryLight() => _primaryLight;

  Color _primaryExtraLight = Color(0xFFBBDEFB);
  primaryExtraLight() => _primaryExtraLight;

  static const _defaultLightTextBodyColor = Color(0xFF292929);
  static const _defaultDarkTextBodyColor = Colors.white70;
  Color _textBodyColor = _defaultLightTextBodyColor;

  textBodyColor() => _textBodyColor;

  Color _anchorColor = Color(0xFF51A4FF);
  anchorColor() => _anchorColor;

  Color _hintTextColor = Color(0xBB5A5A5A);
  hintTextColor() => _hintTextColor;

  Color _lightTextColor = Color(0x825A5A5A);
  lightTextColor() => _lightTextColor;

  Color _primaryTextColor = Color(0xFF42A5F5);
  primaryTextColor() => _primaryTextColor;

  Color _paper = Color(0xFFFAFAFA);
  paper() => _paper;

  Color _separator = Color(0xFFEEEEEE);
  separator() => _separator;

  Color _separatorBlue = Color(0x16007AFF);
  separatorBlue() => _separatorBlue;

  Color _lightGreyLight = Color(0x44606060);
  Color _lightGreyDark = Color(0x44FFFFFF);
  Color _lightGrey = Color(0x44606060);
  lightGrey() => _lightGrey;

  Color _iconGrey = Color(0x44606060);
  iconGrey() => _iconGrey;

  Color _iconOrange = Color(0xFFBBDEFB);
  iconOrange() => _iconOrange;

  Color _splashPrimary = Color(0xFFE3F2FD);
  splashPrimary() => _splashPrimary;

  Color _imgPlaceholderColor = Color(0x08606060);
  imgPlaceholderColor() => _imgPlaceholderColor;

  Color _ringColor = Color(0x44606060);
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

  TextStyle _appBarTitleStyle =
      TextStyle(color: _defaultPrimary, fontSize: 30.0, fontFamily: _defaultFontBase, fontWeight: _defaultFontLight, letterSpacing: 3.0);

  appBarTitleStyle() => _appBarTitleStyle;

  TextStyle _listNameTitleStyle = TextStyle(fontSize: 30.0, letterSpacing: 1.0);

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

  ThemeData getThemeData(Brightness brightness) {
    final defaultTheme = ThemeData(brightness: brightness);

    if (brightness == Brightness.dark) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
      _textBodyColor = _defaultDarkTextBodyColor;
      _lightGrey = _lightGreyDark;
      return ThemeData(
        brightness: brightness,
        canvasColor: Colors.black,
        primarySwatch: materialPrimary(),
        accentColor: materialPrimary(),
        fontFamily: fontBase(),
        cursorColor: primary(),
        textTheme: defaultTheme.textTheme
            .apply(bodyColor: textBodyColor(), displayColor: textBodyColor(), fontFamily: fontBase())
            .merge(TextTheme(bodyText2: TextStyle(fontSize: 22.0))),
        dialogBackgroundColor: Color(0xFF000000),
      );
    }

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xFFEEEEEE),
      systemNavigationBarDividerColor: null,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    _textBodyColor = _defaultLightTextBodyColor;
    _lightGrey = _lightGreyLight;
    return ThemeData(
      brightness: brightness,
      primarySwatch: materialPrimary(),
      accentColor: materialPrimary(),
      fontFamily: fontBase(),
      cursorColor: primary(),
      textTheme: defaultTheme.textTheme
          .apply(bodyColor: textBodyColor(), displayColor: textBodyColor(), fontFamily: fontBase())
          .merge(TextTheme(bodyText2: TextStyle(fontSize: 22.0))),
    );
  }

  Brightness _brightness;
  brightness() => _brightness;

  void setTheme(BuildContext context, Brightness brightness) {
    _brightness = brightness;
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    var themeData = getThemeData(brightness);
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

    _mainColor = mainColor;
    _primary = mainColor;
  }

  _updateTextStyles() {
    switch (_chosenFont) {
      case FontChoice.ptSans: { _mainFont = 'PTSans'; } break;
      case FontChoice.productSans: { _mainFont = 'ProductSans'; } break;
      default: { _mainFont = 'PTSans'; } break;
    }

    var isPtSans = _chosenFont == FontChoice.ptSans;

    _fontBase = _mainFont;

    _textBodyColor = isPtSans ? _defaultLightTextBodyColor : _defaultLightTextBodyColor;

    _appBarTitleStyle = isPtSans
        ? TextStyle(color: _primary, fontSize: 28.0, fontFamily: _fontBase, fontWeight: _fontLight, letterSpacing: 3.0)
        : TextStyle(color: _primary, fontSize: 28.0, fontFamily: _fontBase, fontWeight: FontWeight.w300, letterSpacing: 3.0);
  }

  factory Themer() {
    return _singleton;
  }
}

enum DarkModeChoice { auto, always, never }
enum ThemeChoice { cyan, indigo, blue, blueGrey, grey }
enum FontChoice { ptSans, productSans }
