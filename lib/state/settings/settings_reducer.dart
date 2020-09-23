import 'package:minimalist/state/settings/settings_actions.dart';
import 'package:minimalist/state/settings/settings_state.dart';
import 'package:redux/redux.dart';

Reducer<SettingsState> settingsReducer = combineReducers([
  new TypedReducer<SettingsState, SetThemeChoice>(setThemeChoice),
  new TypedReducer<SettingsState, SetFontChoice>(setFontChoice),
  new TypedReducer<SettingsState, SetContentAlign>(setContentAlign),
  new TypedReducer<SettingsState, SetVerticalContentAlign>(setVerticalContentAlign),
]);

SettingsState setThemeChoice(SettingsState state, SetThemeChoice action) {
  return state.copyWith(themeChoice: action.choice);
}

SettingsState setFontChoice(SettingsState state, SetFontChoice action) {
  return state.copyWith(fontChoice: action.choice);
}

SettingsState setContentAlign(SettingsState state, SetContentAlign action) {
  return state.copyWith(contentAlign: action.align);
}

SettingsState setVerticalContentAlign(SettingsState state, SetVerticalContentAlign action) {
  return state.copyWith(verticalContentAlign: action.align);
}
