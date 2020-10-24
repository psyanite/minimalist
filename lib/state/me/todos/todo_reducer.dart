import 'package:redux/redux.dart';

import 'todo_actions.dart';
import 'todo_state.dart';

Reducer<TodoState> todoReducer = combineReducers([
  new TypedReducer<TodoState, SetCurBoard>(setCurBoard),
  new TypedReducer<TodoState, CreateNewBoard>(createNewBoard),
  new TypedReducer<TodoState, UpdateBoard>(updateBoard),
  new TypedReducer<TodoState, DeleteBoard>(deleteBoard),
  new TypedReducer<TodoState, ReorderBoard>(reorderBoard),
  // new TypedReducer<TodoState, CreateNewTodoList>(createNewTodoList),
  // new TypedReducer<TodoState, UpdateTodoList>(updateTodoList),
  // new TypedReducer<TodoState, DeleteTodoList>(deleteTodoList),
  // new TypedReducer<TodoState, ReorderList>(reorderList),
  // new TypedReducer<TodoState, AddTodo>(addTodo),
  // new TypedReducer<TodoState, DeleteTodo>(deleteTodo),
  // new TypedReducer<TodoState, ReorderTodo>(reorderTodo),
  // new TypedReducer<TodoState, UpdateTodo>(updateTodo),
  // new TypedReducer<TodoState, UpdateTodoStatus>(updateTodoStatus),
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

// TodoState createNewTodoList(TodoState state, CreateNewTodoList action) {
//   var board = action.board.createNewTodoList(action.afterId);
//   return state.updateBoard(board);
// }
//
// TodoState updateTodoList(TodoState state, UpdateTodoList action) {
//   var board = action.board.updateList(action.list);
//   return state.updateBoard(board);
// }
//
// TodoState deleteTodoList(TodoState state, DeleteTodoList action) {
//   var board = action.board.deleteList(action.list);
//   return state.updateBoard(board);
// }
//
// TodoState reorderList(TodoState state, ReorderList action) {
//   var board = action.board.reorderList(action.curIndex, action.newIndex);
//   return state.updateBoard(board);
// }
//
// TodoState addTodo(TodoState state, AddTodo action) {
//   var board = action.board.addTodo(action.listId, action.todo);
//   return state.updateBoard(board);
// }
//
// TodoState deleteTodo(TodoState state, DeleteTodo action) {
//   var board = action.board.deleteTodo(action.listId, action.todo);
//   return state.updateBoard(board);
// }
//
// TodoState reorderTodo(TodoState state, ReorderTodo action) {
//   var board = action.board.reorderTodo(action.listId, action.oldIndex, action.newIndex);
//   return state.updateBoard(board);
// }
//
// TodoState updateTodo(TodoState state, UpdateTodo action) {
//   var board = action.board.updateTodo(action.listId, action.original, action.todo);
//   return state.updateBoard(board);
// }
//
// TodoState updateTodoStatus(TodoState state, UpdateTodoStatus action) {
//   var board = action.board.updateTodoStatus(action.listId, action.todo, action.newStatus);
//   return state.updateBoard(board);
// }
