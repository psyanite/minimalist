  import 'package:minimalist/models/todo_item.dart';
import 'package:minimalist/models/todo_list.dart';

class CreateNewTodoList {
  final int afterId;

  CreateNewTodoList(this.afterId);
}

class UpdateTodoList {
  final TodoList list;

  UpdateTodoList(this.list);
}

class DeleteTodoList {
  final int listId;

  DeleteTodoList(this.listId);
}

class ReorderList {
  final int curIndex;
  final int newIndex;

  ReorderList(this.curIndex, this.newIndex);
}

class AddTodo {
  final int listId;
  final TodoItem todo;

  AddTodo(this.listId, this.todo);
}

class DeleteTodo {
  final int listId;
  final TodoItem todo;

  DeleteTodo(this.listId, this.todo);
}

class ReorderTodo {
  final int listId;
  final int oldIndex;
  final int newIndex;

  ReorderTodo(this.listId, this.oldIndex, this.newIndex);
}

class UpdateTodo {
  final int listId;
  final TodoItem original;
  final TodoItem todo;

  UpdateTodo(this.listId, this.original, this.todo);
}

class UpdateTodoStatus {
  final int listId;
  final TodoItem todo;
  final TodoStatus newStatus;

  UpdateTodoStatus(this.listId, this.todo, this.newStatus);

}