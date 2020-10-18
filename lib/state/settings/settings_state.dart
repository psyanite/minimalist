import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:minimalist/render/presentation/themer.dart';
import 'package:minimalist/utils/enum_util.dart';

@immutable
class SettingsState {
  final FontChoice fontChoice;
  final VerticalContentAlign verticalContentAlign;

  SettingsState({this.fontChoice, this.verticalContentAlign});

  SettingsState.initialState()
      : fontChoice = FontChoice.ptSans,
        verticalContentAlign = VerticalContentAlign.top;

  SettingsState copyWith({
    ThemeChoice themeChoice,
    FontChoice fontChoice,
    ContentAlign contentAlign,
    VerticalContentAlign verticalContentAlign,
  }) {
    return SettingsState(
      fontChoice: fontChoice ?? this.fontChoice,
      verticalContentAlign: verticalContentAlign ?? this.verticalContentAlign,
    );
  }

  factory SettingsState.rehydrate(Map<String, dynamic> json) {
    return SettingsState(
      fontChoice: EnumUtil.fromString(FontChoice.values, json['fontChoice']),
      verticalContentAlign: EnumUtil.fromString(VerticalContentAlign.values, json['verticalContentAlign']),
    );
  }

  Map<String, dynamic> toPersist() {
    return <String, dynamic>{
      'fontChoice': EnumUtil.format(this.fontChoice.toString()),
      'verticalContentAlign': EnumUtil.format(this.verticalContentAlign.toString()),
    };
  }

  @override
  String toString() {
    return '''{...}''';
  }
}

enum ContentAlign { left, center, right }
enum VerticalContentAlign { top, center, bottom }
