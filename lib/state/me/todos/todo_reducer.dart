import 'package:redux/redux.dart';

import 'todo_actions.dart';
import 'todo_state.dart';

Reducer<TodoState> todoReducer = combineReducers([
  new TypedReducer<TodoState, CreateNewTodoList>(createNewTodoList),
  new TypedReducer<TodoState, DeleteTodoList>(deleteTodoList),
  new TypedReducer<TodoState, SetTodoListName>(setTodoListName),
  new TypedReducer<TodoState, ReorderList>(reorderList),
  new TypedReducer<TodoState, AddTodo>(addTodo),
  new TypedReducer<TodoState, ReorderTodo>(reorderTodo),
  new TypedReducer<TodoState, UpdateTodo>(updateTodo),
]);

TodoState createNewTodoList(TodoState state, CreateNewTodoList action) {
  return state.createNewTodoList(action.afterId);
}

TodoState deleteTodoList(TodoState state, DeleteTodoList action) {
  return state.deleteTodoList(action.listId);
}

TodoState setTodoListName(TodoState state, SetTodoListName action) {
  return state.setTodoListName(action.listId, action.name);
}

TodoState reorderList(TodoState state, ReorderList action) {
  return state.reorderList(action.curIndex, action.newIndex);
}

TodoState addTodo(TodoState state, AddTodo action) {
  return state.addTodo(action.listId, action.todo);
}

TodoState reorderTodo(TodoState state, ReorderTodo action) {
  return state.reorderTodo(action.listId, action.oldIndex, action.newIndex);
}

TodoState updateTodo(TodoState state, UpdateTodo action) {
  return state.updateTodo(action.listId, action.index, action.todo);
}
