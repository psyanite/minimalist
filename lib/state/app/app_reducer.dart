import 'package:minimalist/state/app/app_state.dart';
import 'package:minimalist/state/me/todo_reducer.dart';

AppState appReducer(AppState state, action) {

  return AppState(
    todo: todoReducer(state.todo, action),
  );

}
