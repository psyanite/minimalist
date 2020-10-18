import 'package:minimalist/state/settings/settings_actions.dart';
import 'package:minimalist/state/settings/settings_state.dart';
import 'package:redux/redux.dart';

Reducer<SettingsState> settingsReducer = combineReducers([
  new TypedReducer<SettingsState, SetDarkModeChoice>(setDarkModeChoice),
  new TypedReducer<SettingsState, SetThemeChoice>(setThemeChoice),
  new TypedReducer<SettingsState, SetFontChoice>(setFontChoice),
  new TypedReducer<SettingsState, SetContentAlign>(setContentAlign),
  new TypedReducer<SettingsState, SetVerticalContentAlign>(setVerticalContentAlign),
  new TypedReducer<SettingsState, SetAutoDeleteDoneItems>(setAutoDeleteDoneItems),
  new TypedReducer<SettingsState, SetMoveDoneItemsToTheBottom>(setMoveDoneItemsToTheBottom),
]);

SettingsState setDarkModeChoice(SettingsState state, SetDarkModeChoice action) {
  return state.copyWith(darkModeChoice: action.v);
}

SettingsState setThemeChoice(SettingsState state, SetThemeChoice action) {
  return state.copyWith(themeChoice: action.v);
}

SettingsState setFontChoice(SettingsState state, SetFontChoice action) {
  return state.copyWith(fontChoice: action.v);
}

SettingsState setContentAlign(SettingsState state, SetContentAlign action) {
  return state.copyWith(contentAlign: action.v);
}

SettingsState setVerticalContentAlign(SettingsState state, SetVerticalContentAlign action) {
  return state.copyWith(verticalContentAlign: action.v);
}

SettingsState setAutoDeleteDoneItems(SettingsState state, SetAutoDeleteDoneItems action) {
  return state.copyWith(autoDeleteDoneItems: action.v);
}

SettingsState setMoveDoneItemsToTheBottom(SettingsState state, SetMoveDoneItemsToTheBottom action) {
  return state.copyWith(moveDoneItemsToTheBottom: action.v);
}
