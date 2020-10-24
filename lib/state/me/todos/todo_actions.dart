import 'package:minimalist/models/board.dart';

class SetCurBoard {
  final int curBoard;

  SetCurBoard(this.curBoard);
}

class CreateNewBoard {
  final String name;

  CreateNewBoard(this.name);
}

class UpdateBoard {
  final Board board;

  UpdateBoard(this.board);
}

class DeleteBoard {
  final Board board;

  DeleteBoard(this.board);
}

class ReorderBoard {
  final int oldIndex;
  final int newIndex;

  ReorderBoard(this.oldIndex, this.newIndex);
}

// class CreateNewTodoList {
//   final Board board;
//   final int afterId;
//
//   CreateNewTodoList(this.board, this.afterId);
// }
//
// class UpdateTodoList {
//   final Board board;
//   final TodoList list;
//
//   UpdateTodoList(this.board, this.list);
// }
//
// class DeleteTodoList {
//   final Board board;
//   final TodoList list;
//
//   DeleteTodoList(this.board, this.list);
// }
//
// class ReorderList {
//   final Board board;
//   final int curIndex;
//   final int newIndex;
//
//   ReorderList(this.board, this.curIndex, this.newIndex);
// }
//
// class AddTodo {
//   final Board board;
//   final int listId;
//   final TodoItem todo;
//
//   AddTodo(this.board, this.listId, this.todo);
// }
//
// class DeleteTodo {
//   final Board board;
//   final int listId;
//   final TodoItem todo;
//
//   DeleteTodo(this.board, this.listId, this.todo);
// }
//
// class ReorderTodo {
//   final Board board;
//   final int listId;
//   final int oldIndex;
//   final int newIndex;
//
//   ReorderTodo(this.board, this.listId, this.oldIndex, this.newIndex);
// }
//
// class UpdateTodo {
//   final Board board;
//   final int listId;
//   final TodoItem original;
//   final TodoItem todo;
//
//   UpdateTodo(this.board, this.listId, this.original, this.todo);
// }
//
// class UpdateTodoStatus {
//   final Board board;
//   final int listId;
//   final TodoItem todo;
//   final TodoStatus newStatus;
//
//   UpdateTodoStatus(this.board, this.listId, this.todo, this.newStatus);
// }
