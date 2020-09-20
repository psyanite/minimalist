import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:minimalist/models/todo_item.dart';

@immutable
class TodoState {
  final List<TodoItem> items;

  TodoState({this.items});

  TodoState.initialState() : items = List<TodoItem>.empty();

  TodoState copyWith({
    List<TodoItem> items,
  }) {
    return TodoState(
      items: items ?? this.items,
    );
  }

  factory TodoState.rehydrate(Map<String, dynamic> json) {
    var items = json['items'];
    return TodoState(
      items: items.map<TodoItem>((i) => TodoItem.rehydrate(i)).toList(),
    );
  }

  Map<String, dynamic> toPersist() {
    return <String, dynamic>{
      'items': this.items?.map((i) => i.toPersist())?.toList(),
    };
  }

  TodoState addTodo(TodoItem todo) {
    var clone = cloneTodoItems();
    clone.add(todo);
    return copyWith(items: clone);
  }

  TodoState reorderTodo(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    var clone = cloneTodoItems();
    var todo = clone.removeAt(oldIndex);
    clone.insert(newIndex, todo);
    return copyWith(items: clone);
  }

  List<TodoItem> cloneTodoItems() {
    return List<TodoItem>.from(items);
  }

  @override
  String toString() {
    return '''{
        items: ${items.map((i) => i.toString())}, 
      }''';
  }
}
