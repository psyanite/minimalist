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
        lists = LinkedHashMap.from({
          0: TodoList(id: 0, name: 'todo', todos: [
            TodoItem(title: 'shop for a new cape', createdAt: DateTime.now()),
            TodoItem(title: 'get pedicure', createdAt: DateTime.now()),
            TodoItem(title: 'service the batmobile', createdAt: DateTime.now()),
            TodoItem(title: 'call robin', createdAt: DateTime.now()),
            TodoItem(title: 'make reservation', createdAt: DateTime.now()),
            TodoItem(title: 'buy flowers', createdAt: DateTime.now()),
          ])
        });

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

  TodoState updateList(TodoList list) {
    var clone = cloneLists();
    clone[list.id] = list;
    return copyWith(lists: clone);
  }

  TodoState createNewTodoList(int afterId) {
    var clone = cloneLists().values.toList();
    var newList = TodoList(id: nextListId, name: 'todo');
    var newIndex = lists.keys.toList().indexOf(afterId) + 1;
    if (newIndex == lists.length) {
      clone.add(newList);
    } else {
      clone.insert(newIndex, newList);
    }
    return copyWith(nextListId: nextListId + 1, lists: toMap(clone));
  }

  TodoState deleteTodoList(int listId) {
    var clone = cloneLists();
    clone.removeWhere((id, todoList) => listId == id);
    if (clone.length == 0) {
      lists[0] = TodoList(id: 0);
    }
    return copyWith(lists: clone);
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

  TodoState deleteTodo(int listId, TodoItem todo) {
    var clone = cloneLists();
    clone[listId] = clone[listId].deleteTodo(todo);
    return copyWith(lists: clone);
  }

  TodoState updateTodo(int listId, TodoItem original, TodoItem todo) {
    var clone = cloneLists();
    clone[listId] = clone[listId].updateTodo(original, todo);
    return copyWith(lists: clone);
  }

  TodoState updateTodoStatus(int listId, TodoItem todo, TodoStatus newStatus) {
    var clone = cloneLists();
    clone[listId] = clone[listId].updateTodoStatus(todo, newStatus);
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
