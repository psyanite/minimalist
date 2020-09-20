import 'package:minimalist/models/todo_item.dart';

class AddTodo {
  final TodoItem todo;

  AddTodo(this.todo);
}

class ReorderTodo {
  final int oldIndex;
  final int newIndex;

  ReorderTodo(this.oldIndex, this.newIndex);
}
