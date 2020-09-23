import 'package:minimalist/models/todo_item.dart';

class TodoList {
  final int id;
  final String name;
  final List<TodoItem> todos;

  TodoList({
    this.id,
    this.name = "",
    this.todos = const [],
  });

  TodoList copyWith({
    String name,
    List<TodoItem> todos,
  }) {
    return TodoList(
      id: this.id,
      name: name ?? this.name,
      todos: todos ?? this.todos,
    );
  }

  @override
  String toString() {
    return '{ id: $id, name: $name, todos: ${todos.map((t) => t.toString())} }';
  }

  factory TodoList.rehydrate(Map<String, dynamic> json) {
    return TodoList(
      id: json['id'],
      name: json['name'],
      todos: List<TodoItem>.from(json['todos'].map((todo) => TodoItem.rehydrate(todo)).toList()),
    );
  }

  Map<String, dynamic> toPersist() {
    return <String, dynamic>{
      'id': this.id,
      'name': this.name,
      'todos': this.todos.map((todo) => todo.toPersist()).toList(),
    };
  }

  TodoList addTodo(TodoItem todo) {
    var clone = cloneTodoItems();
    clone.add(todo);
    return copyWith(todos: clone);
  }

  TodoList updateTodo(int index, TodoItem todo) {
    var clone = cloneTodoItems();
    clone.replaceRange(index, index, [todo]);
    return copyWith(todos: clone);
  }

  TodoList reorderTodo(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    var clone = cloneTodoItems();
    var todo = clone.removeAt(oldIndex);
    clone.insert(newIndex, todo);
    return copyWith(todos: clone);
  }

  List<TodoItem> cloneTodoItems() {
    return List<TodoItem>.from(todos);
  }

}
