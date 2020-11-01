import 'dart:collection';

import 'package:minimalist/models/todo_item.dart';
import 'package:minimalist/models/todo_list.dart';

final TodoList batmanList =
  TodoList(id: 0, name: 'todo', todos: [
    TodoItem(title: 'shop for a new cape', createdAt: DateTime.now()),
    TodoItem(title: 'get pedicure', createdAt: DateTime.now()),
    TodoItem(title: 'service the batmobile', createdAt: DateTime.now()),
    TodoItem(title: 'call robin', createdAt: DateTime.now()),
    TodoItem(title: 'make reservation', createdAt: DateTime.now()),
    TodoItem(title: 'buy flowers', createdAt: DateTime.now()),
  ]);

class Board {
  final int id;
  final String name;
  final int nextListId;
  final LinkedHashMap<int, TodoList> lists;

  Board({
    this.id,
    this.name,
    this.nextListId,
    this.lists,
  });

  Board.initialState()
      : id = 0,
        name = "My Collection",
        nextListId = 1,
        lists = LinkedHashMap.from({0: batmanList});

  Board copyWith({
    String name,
    int nextListId,
    LinkedHashMap<int, TodoList> lists,
  }) {
    return Board(
      id: this.id,
      name: name ?? this.name,
      nextListId: nextListId ?? this.nextListId,
      lists: lists ?? this.lists,
    );
  }

  @override
  String toString() {
    return '{ id: $id, name: $name, lists: $lists }';
  }

  factory Board.rehydrate(Map<String, dynamic> json) {
    List<TodoList> lists = List<TodoList>.from(json['lists'].map((i) => TodoList.rehydrate(i)));
    return Board(
      id: json['id'],
      name: json['name'],
      nextListId: json['nextListId'],
      lists: LinkedHashMap<int, TodoList>.fromEntries(lists.map((list) => MapEntry(list.id, list))),
    );
  }

  Map<String, dynamic> toPersist() {
    return <String, dynamic>{
      'id': this.id,
      'name': this.name,
      'nextListId': this.nextListId,
      'lists': this.lists.values.map((list) => list.toPersist()).toList(),
    };
  }

  Board createNewTodoList(int afterId) {
    var clone = cloneLists().values.toList();
    var newList = TodoList(id: nextListId);
    var newIndex = lists.keys.toList().indexOf(afterId) + 1;
    if (newIndex == lists.length) {
      clone.add(newList);
    } else {
      clone.insert(newIndex, newList);
    }
    return copyWith(nextListId: nextListId + 1, lists: toMap(clone));
  }

  Board updateList(TodoList list) {
    var clone = cloneLists();
    clone[list.id] = list;
    return copyWith(lists: clone);
  }

  Board deleteList(TodoList list) {
    var clone = cloneLists();
    clone.remove(list.id);
    if (clone.length == 0) {
      clone.addAll({nextListId: TodoList(id: nextListId, name: 'todos')});
      return copyWith(nextListId: nextListId + 1, lists: clone);
    }
    return copyWith(lists: clone);
  }

  Board reorderList(int curIndex, int newIndex) {
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

  // Board addTodo(int listId, TodoItem todo) {
  //   var clone = cloneLists();
  //   clone[listId] = clone[listId].addTodo(todo);
  //   return copyWith(lists: clone);
  // }
  //
  // Board deleteTodo(int listId, TodoItem todo) {
  //   var clone = cloneLists();
  //   clone[listId] = clone[listId].deleteTodo(todo);
  //   return copyWith(lists: clone);
  // }
  //
  // Board updateTodo(int listId, TodoItem original, TodoItem todo) {
  //   var clone = cloneLists();
  //   clone[listId] = clone[listId].updateTodo(original, todo);
  //   return copyWith(lists: clone);
  // }
  //
  // Board updateTodoStatus(int listId, TodoItem todo, TodoStatus newStatus) {
  //   var clone = cloneLists();
  //   clone[listId] = clone[listId].updateTodoStatus(todo, newStatus);
  //   return copyWith(lists: clone);
  // }
  //
  // Board reorderTodo(int listId, int oldIndex, int newIndex) {
  //   if (newIndex > oldIndex) newIndex -= 1;
  //   var clone = cloneLists();
  //   clone[listId] = clone[listId].reorderTodo(oldIndex, newIndex);
  //   return copyWith(lists: clone);
  // }

  LinkedHashMap<int, TodoList> cloneLists() {
    return LinkedHashMap<int, TodoList>.from(lists);
  }

}
