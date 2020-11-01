import 'package:redux/redux.dart';

import 'todo_actions.dart';
import 'todo_state.dart';

Reducer<TodoState> todoReducer = combineReducers([
  new TypedReducer<TodoState, SetCurBoard>(setCurBoard),
  new TypedReducer<TodoState, CreateNewBoard>(createNewBoard),
  new TypedReducer<TodoState, UpdateBoard>(updateBoard),
  new TypedReducer<TodoState, DeleteBoard>(deleteBoard),
  new TypedReducer<TodoState, ReorderBoard>(reorderBoard),
]);

TodoState setCurBoard(TodoState state, SetCurBoard action) {
  return state.copyWith(curBoard: action.curBoard);
}

TodoState createNewBoard(TodoState state, CreateNewBoard action) {
  return state.createNewBoard(action.name);
}

TodoState updateBoard(TodoState state, UpdateBoard action) {
  return state.updateBoard(action.board);
}

TodoState deleteBoard(TodoState state, DeleteBoard action) {
  return state.deleteBoard(action.board);
}

TodoState reorderBoard(TodoState state, ReorderBoard action) {
  return state.reorderBoard(action.oldIndex, action.newIndex);
}
