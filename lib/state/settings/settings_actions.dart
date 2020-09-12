import 'package:minimalist/presentation/themer.dart';
import 'package:minimalist/state/settings/settings_state.dart';

class SetThemeChoice {
  final ThemeChoice choice;

  SetThemeChoice(this.choice);
}

class SetFontChoice {
  final FontChoice choice;

  SetFontChoice(this.choice);
}

class SetContentAlign {
  final ContentAlign align;

  SetContentAlign(this.align);
}
