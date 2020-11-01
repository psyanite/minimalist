import 'package:minimalist/render/presentation/themer.dart';
import 'package:minimalist/state/app/app_state.dart';
import 'package:minimalist/state/me/todos/todo_reducer.dart';
import 'package:minimalist/state/settings/settings_reducer.dart';

class RefreshAppState {
  final AppState appstate;

  RefreshAppState(this.appstate);
}


AppState appReducer(AppState state, dynamic action) {
  if (action is RefreshAppState) {
    Themer().init(action.appstate.settings);
    return action.appstate;
  }

  return AppState(
    todo: todoReducer(state.todo, action),
    settings: settingsReducer(state.settings, action),
  );
}
