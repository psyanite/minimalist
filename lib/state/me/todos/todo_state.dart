import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:minimalist/models/todo_item.dart';
import 'package:minimalist/models/todo_list.dart';

@immutable
class TodoState {
  final int nextListId;
  final LinkedHashMap<int, TodoList> lists;

  TodoState({this.nextListId, this.lists});

  TodoState.initialState()
      : nextListId = 1,
        lists = LinkedHashMap.from({0: TodoList(id: 0)});

  TodoState copyWith({
    int nextListId,
    LinkedHashMap<int, TodoList> lists,
  }) {
    return TodoState(
      nextListId: nextListId ?? this.nextListId,
      lists: lists ?? this.lists,
    );
  }

  factory TodoState.rehydrate(Map<String, dynamic> json) {
    List<TodoList> lists = List<TodoList>.from(json['lists'].map((i) => TodoList.rehydrate(i)));
    // return TodoState.initialState();
    return TodoState(
      nextListId: json['nextListId'],
      lists: LinkedHashMap<int, TodoList>.fromEntries(lists.map((list) => MapEntry(list.id, list))),
    );
  }

  Map<String, dynamic> toPersist() {
    return <String, dynamic>{
      'nextListId': this.nextListId,
      'lists': this.lists.values.map((list) => list.toPersist()).toList(),
    };
  }

  TodoState updateList(int listId, TodoList list) {
    var clone = cloneLists();
    clone[listId] = list;
    return copyWith(lists: clone);
  }

  TodoState createNewTodoList(int afterId) {
    var clone = cloneLists().values.toList();
    var newList = TodoList(id: nextListId);
    var newIndex = lists.keys.toList().indexOf(afterId) + 1;
    clone.insert(newIndex, newList);
    return copyWith(lists: toMap(clone));
  }

  TodoState deleteTodoList(int listId) {
    var clone = cloneLists();
    clone.removeWhere((id, todoList) => listId == id);
    if (clone.length == 0) {
      lists[0] = TodoList(id: 0);
    }
    return copyWith(lists: clone);
  }

  TodoState setTodoListName(int listId, String name) {
    var updatedList = lists[listId].copyWith(name: name);
    return updateList(listId, updatedList);
  }

  TodoState reorderList(int curIndex, int newIndex) {
    var clone = cloneLists();
    var update = reorderListy(clone, curIndex, newIndex);
    return copyWith(lists: update);
  }

  LinkedHashMap<int, TodoList> reorderListy(LinkedHashMap<int, TodoList> hashMap, int curIndex, int newIndex) {
    var lists = hashMap.values.toList();
    var list = lists.elementAt(curIndex);
    lists.removeAt(curIndex);
    lists.insert(newIndex, list);
    return toMap(lists);
  }

  LinkedHashMap<int, TodoList> toMap(List<TodoList> lists) {
    return LinkedHashMap<int, TodoList>.fromEntries(lists.map((list) => MapEntry(list.id, list)));
  }

  TodoState addTodo(int listId, TodoItem todo) {
    var clone = cloneLists();
    clone[listId] = clone[listId].addTodo(todo);
    return copyWith(lists: clone);
  }

  TodoState updateTodo(int listId, int index, TodoItem todo) {
    var clone = cloneLists();
    clone[listId] = clone[listId].updateTodo(index, todo);
    return copyWith(lists: clone);
  }

  TodoState reorderTodo(int listId, int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    var clone = cloneLists();
    clone[listId] = clone[listId].reorderTodo(oldIndex, newIndex);
    return copyWith(lists: clone);
  }

  LinkedHashMap<int, TodoList> cloneLists() {
    return LinkedHashMap<int, TodoList>.from(lists);
  }

  @override
  String toString() {
    var lists = this.lists.map((id, list) => MapEntry(id, '$id: ${list.toString()}')).values;
    return '''{
        lists: ${lists.join("\n")}, 
      }''';
  }
}
