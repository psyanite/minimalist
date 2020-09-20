import 'package:redux/redux.dart';

import 'todo_actions.dart';
import 'todo_state.dart';

Reducer<TodoState> todoReducer = combineReducers([
  new TypedReducer<TodoState, AddTodo>(addTodo),
  new TypedReducer<TodoState, ReorderTodo>(reorderTodo),
]);

TodoState addTodo(TodoState state, AddTodo action) {
  return state.addTodo(action.todo);
}

TodoState reorderTodo(TodoState state, ReorderTodo action) {
  return state.reorderTodo(action.oldIndex, action.newIndex);
}
