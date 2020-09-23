import 'package:minimalist/models/todo_item.dart';

class CreateNewTodoList {
  final int afterId;

  CreateNewTodoList(this.afterId);
}

class DeleteTodoList {
  final int listId;

  DeleteTodoList(this.listId);
}

class SetTodoListName {
  final int listId;
  final String name;

  SetTodoListName(this.listId, this.name);
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

class ReorderTodo {
  final int listId;
  final int oldIndex;
  final int newIndex;

  ReorderTodo(this.listId, this.oldIndex, this.newIndex);
}

class UpdateTodo {
  final int listId;
  final int index;
  final TodoItem todo;

  UpdateTodo(this.listId, this.index, this.todo);
}
