import 'package:redux/redux.dart';

import '../../../model/todo_item.dart';
import 'todo_actions.dart';
import 'todo_state.dart';

Reducer<TodoState> todoReducer = combineReducers([
  new TypedReducer<TodoState, AddTodoItem>(addTodoItem),
]);

TodoState addTodoItem(TodoState state, AddTodoItem action) {
  List<TodoItem> items = state.items;
  items.add(action.item);
  return state.copyWith(items: items);
}
