import 'package:minimalist/model/todo_item.dart';
import 'package:minimalist/state/me/todo_actions.dart';
import 'package:minimalist/state/me/todo_state.dart';
import 'package:redux/redux.dart';

Reducer<TodoState> todoReducer = combineReducers([
  new TypedReducer<TodoState, AddTodoItem>(addTodoItem),
]);

TodoState addTodoItem(state, AddTodoItem action) {
  List<TodoItem> items = state.items;
//  var item = action.item;
//  if (item.type == SearchHistoryItemType.cuisine) {
//    history.removeWhere((i) => i.cuisineName == item.cuisineName);
//  } else {
//    history.removeWhere((i) => i.store != null && i.store.name == item.store.name);
//  }
//  history.insert(0, action.item);
//  if (history.length > 15) history = history.sublist(0, 15);
  return state.copyWith(items: items);
}
