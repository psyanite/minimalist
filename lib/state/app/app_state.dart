import 'package:meta/meta.dart';
import 'package:minimalist/services/firestore_service.dart';
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
        todo: TodoState.rehydrate(json['todo']),
        settings: SettingsState.rehydrate(json['settings']),
      );
    } catch (e, stack) {
      print('[ERROR] Could not deserialize json from persistor: $e, $stack');
      return AppState();
    }
  }

  // Used by persistor
  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {
      'todo': todo.toPersist(),
      'settings': settings.toPersist(),
    };
    FirestoreService().saveState(result);
    return result;
  }

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
