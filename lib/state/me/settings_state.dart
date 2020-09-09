import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:minimalist/utils/enum_util.dart';

@immutable
class SettingsState {
  final TodoListAlign todoListAlign;

  SettingsState({this.todoListAlign});

  SettingsState.initialState() :
        todoListAlign = TodoListAlign.left;

  SettingsState copyWith({
    TodoListAlign todoListAlign,
  }) {
    return SettingsState(
      todoListAlign: todoListAlign ?? this.todoListAlign,
    );
  }

  factory SettingsState.rehydrate(Map<String, dynamic> json) {
    return SettingsState(
      todoListAlign: EnumUtil.fromString(TodoListAlign.values, json['todoListAlign']),
    );
  }

  Map<String, dynamic> toPersist() {
    return <String, dynamic>{
      'todoListAlign': EnumUtil.format(this.todoListAlign.toString()),
    };
  }

  @override
  String toString() {
    return '''{
        todoListAlign: ${todoListAlign.toString}, 
      }''';
  }
}

enum TodoListAlign { left, center, right }
