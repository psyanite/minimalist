import 'package:meta/meta.dart';
import 'package:minimalist/state/me/todos/todo_state.dart';
import 'package:minimalist/state/settings/settings_state.dart';

@immutable
class AppState {
  final TodoState todo;
  final SettingsState settings;

  AppState({TodoState todo, SettingsState settings})
      : todo = todo ?? TodoState.initialState(),
       settings = settings ?? SettingsState.initialState();

  static AppState rehydrate(dynamic json) {
    if (json == null) return AppState();
    try {
      return AppState(
        todo: json['todo'] != null ? TodoState.rehydrate(json['todo']) : TodoState.initialState(),
        settings: json['settings'] != null ? SettingsState.rehydrate(json['settings']) : SettingsState.initialState(),
      );
    }
    catch (e, stack) {
      print('[ERROR] Could not deserialize json from persistor: $e, $stack');
      return AppState();
    }
  }

  // Used by persistor
  Map<String, dynamic> toJson() => {
    'todo': todo.toPersist(),
    'settings': settings.toPersist(),
  };

  AppState copyWith({TodoState todo, SettingsState settings}) {
    return AppState(
        todo: todo ?? this.todo,
        settings: settings ?? this.settings,
    );
  }

  @override
  String toString() {
    return '''{
      todo: $todo,
      settings: $settings,
    }''';
  }
}
