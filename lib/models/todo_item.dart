import 'package:minimalist/utils/enum_util.dart';

class TodoItem {
  final TodoStatus status;
  final String title;
  final String desc;

  TodoItem({
    this.status = TodoStatus.standby,
    this.title,
    this.desc,
  });

  @override
  String toString() {
    return '{ status: $status, title: $title, desc: $desc}';
  }

  factory TodoItem.rehydrate(Map<String, dynamic> json) {
    return TodoItem(
      status: EnumUtil.fromString(TodoStatus.values, json['status']),
      title: json['title'],
      desc: json['desc'],
    );
  }

  Map<String, dynamic> toPersist() {
    return <String, dynamic>{
      'status': EnumUtil.format(this.status.toString()),
      'title': this.title,
      'desc': this.desc,
    };
  }
}

enum TodoStatus { standby, done }
