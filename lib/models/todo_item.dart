import 'package:minimalist/utils/enum_util.dart';

class TodoItem {
  final TodoStatus status;
  final String title;
  final String desc;
  final DateTime createdAt;

  TodoItem({
    this.status = TodoStatus.standby,
    this.title,
    this.desc,
    this.createdAt,
  });

  TodoItem copyWith({
    TodoStatus status,
    String title,
    String desc,
  }) {
    return TodoItem(
      status: status ?? this.status,
      title: title ?? this.title,
      desc: desc == '' ? null : desc == null ? this.desc : desc,
      createdAt: createdAt,
    );
  }

  @override
  String toString() {
    return '{ status: $status, title: $title, desc: $desc }';
  }

  factory TodoItem.rehydrate(Map<String, dynamic> json) {
    return TodoItem(
      status: EnumUtil.fromString(TodoStatus.values, json['status']),
      title: json['title'],
      desc: json['desc'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toPersist() {
    return <String, dynamic>{
      'status': EnumUtil.format(this.status.toString()),
      'title': this.title,
      'desc': this.desc,
      'createdAt': this.createdAt.toIso8601String()
    };
  }
}

enum TodoStatus { standby, done }
