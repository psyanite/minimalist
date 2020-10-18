import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:minimalist/render/presentation/themer.dart';
import 'package:minimalist/utils/enum_util.dart';

@immutable
class SettingsState {
  final DarkModeChoice darkModeChoice;
  final FontChoice fontChoice;
  final VerticalContentAlign verticalContentAlign;
  final bool autoDeleteDoneItems;
  final bool moveDoneItemsToTheBottom;

  SettingsState({
    this.darkModeChoice,
    this.fontChoice,
    this.verticalContentAlign,
    this.autoDeleteDoneItems,
    this.moveDoneItemsToTheBottom,
  });

  SettingsState.initialState()
      : darkModeChoice = DarkModeChoice.auto,
        fontChoice = FontChoice.ptSans,
        verticalContentAlign = VerticalContentAlign.top,
        autoDeleteDoneItems = false,
        moveDoneItemsToTheBottom = false;

  SettingsState copyWith({
    DarkModeChoice darkModeChoice,
    ThemeChoice themeChoice,
    FontChoice fontChoice,
    ContentAlign contentAlign,
    VerticalContentAlign verticalContentAlign,
    bool autoDeleteDoneItems,
    bool moveDoneItemsToTheBottom,
  }) {
    return SettingsState(
      darkModeChoice: darkModeChoice ?? this.darkModeChoice,
      fontChoice: fontChoice ?? this.fontChoice,
      verticalContentAlign: verticalContentAlign ?? this.verticalContentAlign,
      autoDeleteDoneItems: autoDeleteDoneItems ?? this.autoDeleteDoneItems,
      moveDoneItemsToTheBottom: moveDoneItemsToTheBottom ?? this.moveDoneItemsToTheBottom,
    );
  }

  factory SettingsState.rehydrate(Map<String, dynamic> json) {
    return SettingsState(
      darkModeChoice: EnumUtil.fromString(DarkModeChoice.values, json['darkModeChoice']),
      fontChoice: EnumUtil.fromString(FontChoice.values, json['fontChoice']),
      verticalContentAlign: EnumUtil.fromString(VerticalContentAlign.values, json['verticalContentAlign']),
      autoDeleteDoneItems: json['autoDeleteDoneItems'],
      moveDoneItemsToTheBottom: json['moveDoneItemsToTheBottom'],
    );
  }

  Map<String, dynamic> toPersist() {
    return <String, dynamic>{
      'darkModeChoice': EnumUtil.format(this.darkModeChoice.toString()),
      'fontChoice': EnumUtil.format(this.fontChoice.toString()),
      'verticalContentAlign': EnumUtil.format(this.verticalContentAlign.toString()),
      'autoDeleteDoneItems': autoDeleteDoneItems,
      'moveDoneItemsToTheBottom': moveDoneItemsToTheBottom,
    };
  }

  @override
  String toString() {
    return '''{...}''';
  }
}

enum ContentAlign { left, center, right }
enum VerticalContentAlign { top, center, bottom }
