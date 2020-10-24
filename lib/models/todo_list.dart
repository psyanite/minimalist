import 'package:flutter/material.dart';
import 'package:minimalist/models/todo_item.dart';
import 'package:minimalist/render/presentation/themer.dart';
import 'package:minimalist/utils/enum_util.dart';

class TodoList {
  final int id;
  final String name;
  final TodoListColor color;
  final int completedCount;
  final bool showCounter;
  final List<TodoItem> todos;

  TodoList({
    this.id,
    this.name = "todo",
    this.color = TodoListColor.blue,
    this.completedCount = 0,
    this.showCounter = true,
    this.todos = const [],
  });

  TodoList copyWith({
    String name,
    TodoListColor color,
    int completedCount,
    bool showCounter,
    List<TodoItem> todos,
  }) {
    return TodoList(
      id: this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      completedCount: completedCount ?? this.completedCount,
      showCounter: showCounter ?? this.showCounter,
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
      color: EnumUtil.fromString(TodoListColor.values, json['color']),
      completedCount: json['completedCount'] ?? 0,
      showCounter: json['showCounter'] ?? true,
      todos: List<TodoItem>.from(json['todos'].map((todo) => TodoItem.rehydrate(todo)).toList()),
    );
  }

  Map<String, dynamic> toPersist() {
    return <String, dynamic>{
      'id': this.id,
      'name': this.name,
      'color': EnumUtil.format(this.color.toString()),
      'completedCount': this.completedCount,
      'showCounter': this.showCounter,
      'todos': this.todos.map((todo) => todo.toPersist()).toList(),
    };
  }

  TodoList addTodo(TodoItem todo) {
    var clone = cloneTodoItems();
    clone.add(todo);
    return copyWith(todos: clone);
  }

  TodoList deleteTodo(TodoItem todo) {
    var clone = cloneTodoItems();
    clone.remove(todo);
    return copyWith(todos: clone);
  }

  TodoList updateTodo(TodoItem original, TodoItem todo) {
    var clone = cloneTodoItems();
    var index = clone.indexOf(original);
    clone.replaceRange(index, index + 1, [todo]);
    return copyWith(todos: clone);
  }

  TodoList updateTodoStatus(TodoItem todo, TodoStatus newStatus) {
    var clone = cloneTodoItems();
    var updatedTodo = todo.copyWith(status: newStatus);
    var index = clone.indexOf(todo);

    if (Themer().autoDeleteDoneItems()) {
      clone.removeAt(index);

    } else if (Themer().moveDoneItemsToTheBottom()) {
      if (newStatus == TodoStatus.done) {
        clone.removeAt(index);
        clone.add(updatedTodo);
      } else {
        clone.replaceRange(index, index + 1, [updatedTodo]);
      }

    } else {
      clone.replaceRange(index, index + 1, [updatedTodo]);
    }

    var newCount = newStatus == TodoStatus.done ? completedCount + 1 : completedCount - 1;
    return copyWith(todos: clone, completedCount: newCount);
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

enum TodoListColor { purple, red, amber, lightGreen, cyan, lightBlue, indigo, blue, grey }

Color mapTodoListColor(TodoListColor color) {
  var c;
  switch (color) {
    case TodoListColor.purple:
      c = Colors.purple;
      break;
    case TodoListColor.red:
      c = Colors.red;
      break;
    case TodoListColor.amber:
      c = Colors.amber;
      break;
    case TodoListColor.lightGreen:
      c = Colors.lightGreen;
      break;
    case TodoListColor.cyan:
      c = Colors.cyan;
      break;
    case TodoListColor.lightBlue:
      c = Colors.lightBlue;
      break;
    case TodoListColor.blue:
      c = Colors.blue;
      break;
    case TodoListColor.indigo:
      c = Colors.indigo;
      break;
    case TodoListColor.grey:
    default:
      c = Colors.grey;
      break;
  }
  return c;
}
