import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:minimalist/presentation/themer.dart';
import 'package:minimalist/utils/enum_util.dart';

@immutable
class SettingsState {
  final ThemeChoice themeChoice;
  final FontChoice fontChoice;
  final ContentAlign contentAlign;

  SettingsState({this.themeChoice, this.fontChoice, this.contentAlign});

  SettingsState.initialState() :
        themeChoice = ThemeChoice.blue,
        fontChoice = FontChoice.ptSans,
        contentAlign = ContentAlign.left;

  SettingsState copyWith({
    ThemeChoice themeChoice,
    FontChoice fontChoice,
    ContentAlign contentAlign,
  }) {
    return SettingsState(
      themeChoice: themeChoice ?? this.themeChoice,
      fontChoice: fontChoice ?? this.fontChoice,
      contentAlign: contentAlign ?? this.contentAlign,
    );
  }

  factory SettingsState.rehydrate(Map<String, dynamic> json) {
    return SettingsState(
        themeChoice: EnumUtil.fromString(ThemeChoice.values, json['themeChoice']),
        fontChoice: EnumUtil.fromString(FontChoice.values, json['fontChoice']),
        contentAlign: EnumUtil.fromString(ContentAlign.values, json['contentAlign']),
    );
  }

  Map<String, dynamic> toPersist() {
    return <String, dynamic>{
      'themeChoice': EnumUtil.format(this.themeChoice.toString()),
      'fontChoice': EnumUtil.format(this.fontChoice.toString()),
      'contentAlign': EnumUtil.format(this.contentAlign.toString()),
    };
  }

  @override
  String toString() {
    return '''{...}''';
  }
}

enum ContentAlign { left, right, center }
