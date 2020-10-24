import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:minimalist/models/board.dart';
import 'package:minimalist/models/todo_list.dart';


@immutable
class TodoState {
  final int curBoard;
  final int nextBoardId;
  final LinkedHashMap<int, Board> boards;

  TodoState({this.curBoard, this.nextBoardId, this.boards});

  TodoState.initialState()
      : curBoard = 0,
        nextBoardId = 1,
        boards = LinkedHashMap.from({0: Board.initialState()});

  TodoState copyWith({
    int curBoard,
    int nextBoardId,
    LinkedHashMap<int, Board> boards,
  }) {
    return TodoState(
      curBoard: curBoard ?? this.curBoard,
      nextBoardId: nextBoardId ?? this.nextBoardId,
      boards: boards ?? this.boards,
    );
  }

  factory TodoState.rehydrate(Map<String, dynamic> json) {
    List<Board> boards = List<Board>.from(json['boards'].map((i) => Board.rehydrate(i)));
    return TodoState(
      curBoard: json['curBoard'],
      nextBoardId: json['nextBoardId'],
      boards: LinkedHashMap<int, Board>.fromEntries(boards.map((list) => MapEntry(list.id, list))),
    );
  }

  Map<String, dynamic> toPersist() {
    return <String, dynamic>{
      'curBoard': this.curBoard,
      'nextBoardId': this.nextBoardId,
      'boards': this.boards.values.map((list) => list.toPersist()).toList(),
    };
  }

  TodoState createNewBoard(String name) {
    var newBoard = Board(id: nextBoardId, name: name, nextListId: 1, lists: LinkedHashMap.from({0: TodoList(id: 0, name: "todos")}));
    var clone = cloneBoards();
    clone[nextBoardId] = newBoard;
    return copyWith(nextBoardId: nextBoardId + 1, boards: clone);
  }

  TodoState deleteBoard(Board board) {
    var clone = cloneBoards();
    clone.remove(board.id);
    if (clone.length == 0) {
      return TodoState.initialState();
    } else {
      return copyWith(boards: clone);
    }
  }

  TodoState updateBoard(Board board) {
    var clone = cloneBoards();
    clone[board.id] = board;
    return copyWith(boards: clone);
  }

  TodoState reorderBoard(int curIndex, int newIndex) {
    var clone = cloneBoards();
    var update = reorderBoardy(clone, curIndex, newIndex);
    return copyWith(boards: update);
  }

  LinkedHashMap<int, Board> reorderBoardy(
      LinkedHashMap<int, Board> hashMap, int curIndex, int newIndex) {
    var lists = hashMap.values.toList();
    var list = lists.elementAt(curIndex);
    lists.removeAt(curIndex);
    lists.insert(newIndex, list);
    return toMap(lists);
  }

  LinkedHashMap<int, Board> toMap(List<Board> boards) {
    return LinkedHashMap<int, Board>.fromEntries(
        boards.map((list) => MapEntry(list.id, list)));
  }

  LinkedHashMap<int, Board> cloneBoards() {
    return LinkedHashMap<int, Board>.from(boards);
  }

  @override
  String toString() {
    var boards = this.boards.map((id, board) => MapEntry(id, '$id: ${board.toString()}')).values;
    return '''{
        boards: ${boards.join("\n")}, 
      }''';
  }
}
