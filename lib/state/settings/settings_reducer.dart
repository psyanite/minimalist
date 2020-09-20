import 'package:minimalist/render/presentation/themer.dart';
import 'package:minimalist/state/settings/settings_actions.dart';
import 'package:minimalist/state/settings/settings_state.dart';
import 'package:redux/redux.dart';

Reducer<SettingsState> settingsReducer = combineReducers([
  new TypedReducer<SettingsState, SetThemeChoice>(setThemeChoice),
  new TypedReducer<SettingsState, SetFontChoice>(setFontChoice),
  new TypedReducer<SettingsState, SetContentAlign>(setContentAlign),
]);

SettingsState setThemeChoice(SettingsState state, SetThemeChoice action) {
  Themer().setChosenTheme(action.choice);
  return state.copyWith(themeChoice: action.choice);
}

SettingsState setFontChoice(SettingsState state, SetFontChoice action) {
  Themer().setChosenFont(action.choice);
  return state.copyWith(fontChoice: action.choice);
}

SettingsState setContentAlign(SettingsState state, SetContentAlign action) {
  Themer().setContentAlign(action.align);
  return state.copyWith(contentAlign: action.align);
}
