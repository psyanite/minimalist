import 'package:minimalist/render/components/common/main_navigator.dart';

class Navi {
  static final Navi _singleton = Navi._internal();
  static MainNavigatorState _mainNav;

  Navi._internal();

  MainNavigatorState getMainNav() => _mainNav;

  factory Navi({MainNavigatorState mainNav}) {
    if (mainNav != null && _mainNav != mainNav) {
      _mainNav = mainNav;
    }
    return _singleton;
  }
}
