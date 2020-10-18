import 'package:minimalist/render/presentation/themer.dart';
import 'package:minimalist/state/settings/settings_state.dart';

class SetDarkModeChoice {
  final DarkModeChoice v;

  SetDarkModeChoice(this.v);
}

class SetThemeChoice {
  final ThemeChoice v;

  SetThemeChoice(this.v);
}

class SetFontChoice {
  final FontChoice v;

  SetFontChoice(this.v);
}

class SetContentAlign {
  final ContentAlign v;

  SetContentAlign(this.v);
}

class SetVerticalContentAlign {
  final VerticalContentAlign v;

  SetVerticalContentAlign(this.v);
}

class SetAutoDeleteDoneItems {
  final bool v;

  SetAutoDeleteDoneItems(this.v);
}

class SetMoveDoneItemsToTheBottom {
  final bool v;

  SetMoveDoneItemsToTheBottom(this.v);
}
