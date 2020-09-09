import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:minimalist/model/todo_item.dart';

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

  @override
  String toString() {
    return '''{
        items: ${items.map((i) => i.toString())}, 
      }''';
  }
}
