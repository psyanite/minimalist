import 'package:meta/meta.dart';
import 'package:minimalist/state/me/todo_state.dart';

@immutable
class AppState {
  final TodoState todo;

  AppState({TodoState todo})
      : todo = todo ?? TodoState.initialState();

  static AppState rehydrate(dynamic json) {
    if (json == null) return AppState();
    try {
      return AppState(
        todo: json['todo'] != null ? TodoState.rehydrate(json['todo']) : null
      );
    }
    catch (e, stack) {
      print('[ERROR] Could not deserialize json from persistor: $e, $stack');
      return AppState();
    }
  }

  // Used by persistor
  Map<String, dynamic> toJson() => { 'todo': todo.toPersist() };

  AppState copyWith({TodoState todo}) {
    return AppState(todo: todo ?? this.todo);
  }

  @override
  String toString() {
    return '''{
      todo: $todo,
    }''';
  }
}
