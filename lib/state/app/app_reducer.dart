import 'package:minimalist/state/app/app_state.dart';
import 'file:///E:/Magic/minimalist/lib/state/me/todos/todo_reducer.dart';
import 'package:minimalist/state/settings/settings_reducer.dart';

AppState appReducer(AppState state, action) {

  return AppState(
    todo: todoReducer(state.todo, action),
    settings: settingsReducer(state.settings, action),
  );

}
