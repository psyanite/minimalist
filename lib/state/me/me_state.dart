import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:minimalist/model/user.dart';

final defaultUser = User(id: 0, displayName: 'User');

@immutable
class MeState {
  final User user;

  MeState({this.user});

  MeState.initialState()
      : user = defaultUser;

  MeState copyWith({
    User user,
  }) {
    return MeState(
      user: user ?? this.user,
    );
  }

  factory MeState.rehydrate(Map<String, dynamic> json) {
    var user = json['user'];
    return MeState(
        user: user != null ? User.rehydrate(user) : defaultUser,
    );
  }

  Map<String, dynamic> toPersist() {
    return <String, dynamic>{
      'user': this.user?.toPersist(),
    };
  }

  @override
  String toString() {
    return '''{
        user: $user, 
      }''';
  }
}
