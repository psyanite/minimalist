import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:minimalist/models/todo_list.dart';
import 'package:minimalist/render/components/dialog/confirm.dart';
import 'package:minimalist/render/components/dialog/dialog.dart';
import 'package:minimalist/render/components/dialog/multi_select_dialog.dart';
import 'package:minimalist/render/home/set_list_name_screen.dart';
import 'package:minimalist/render/presentation/themer.dart';
import 'package:minimalist/render/screens/theme_screen.dart';
import 'package:minimalist/services/navi.dart';
import 'package:minimalist/state/app/app_state.dart';
import 'package:minimalist/state/me/todos/todo_actions.dart';
import 'package:redux/redux.dart';

class MoreDialog extends StatelessWidget {
  final TodoList todoList;

  const MoreDialog(this.todoList, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
      converter: (Store<AppState> store) => _Props.fromStore(store, todoList.id),
      builder: (BuildContext context, _Props props) {
        return _Presenter(
          todoList: todoList,
          curIndex: props.curIndex,
          positionOptions: props.positionOptions,
          dispatch: props.dispatch,
        );
      },
    );
  }
}

class _Presenter extends StatefulWidget {
  final TodoList todoList;
  final int curIndex;
  final List<int> positionOptions;
  final Function dispatch;

  const _Presenter({Key key, this.todoList, this.curIndex, this.positionOptions, this.dispatch})
      : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  bool _addListLoading = false;

  @override
  Widget build(BuildContext context) {
    var options = [
      _addListLoading ? loadingIcon() : option(MultiSelectDialogOption(title: 'Add list', onTap: addList)),
      option(MultiSelectDialogOption(title: 'Set list name', onTap: setListName)),
      option(MultiSelectDialogOption(title: 'Set accent color', onTap: setColor)),
      option(MultiSelectDialogOption(title: 'Move list', onTap: moveList)),
      option(MultiSelectDialogOption(title: 'Delete list', onTap: deleteList)),
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 5.0),
          Container(
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) => options[index],
              separatorBuilder: (context, index) => Divider(height: 1.0, color: Themer().separatorBlue()),
              itemCount: options.length,
            ),
          ),
          Container(height: 20.0),
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              child: Text('Cancel', style: TextStyle(color: Themer().hintTextColor())),
              padding: EdgeInsets.only(bottom: 10.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget loadingIcon() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      height: 40.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [SizedBox(height: 20.0, width: 20.0, child: CircularProgressIndicator())],
      ),
    );
  }

  void setListName() {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => SetListNameScreen(widget.todoList.id)));
  }

  void addList() {
    widget.dispatch(CreateNewTodoList(widget.todoList.id));
    setState(() => _addListLoading = true);
    Timer(Duration(milliseconds: 500), () {
      Navigator.pop(context);
      Navi().getMainNav().jumpToPage(widget.curIndex + 1);
    });
  }

  void moveList() {
    Navigator.pop(context);
    var desc = widget.positionOptions.isEmpty
        ? 'Oops, add another list first before trying to move this list.'
        : 'You\'re currently on page ${widget.curIndex + 1},\nmove list to';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var dialogOptions = List<DialogOption>.from(widget.positionOptions.map((index) => DialogOption(
            display: 'Page ${index + 1}',
            onTap: () {
              widget.dispatch(ReorderList(widget.curIndex, index));
              Navigator.pop(context);
              Navi().getMainNav().jumpToPage(index);
            })));
        return BurntDialog(
          title: 'Move List',
          description: desc,
          options: dialogOptions,
        );
      },
    );
  }

  void deleteList() {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Confirm(
          title: 'Delete List',
          description: 'This list will be lost forever.',
          action: 'Delete',
          onTap: () {
            widget.curIndex == 0
                ? Navi().getMainNav().jumpToPage(widget.curIndex)
                : Navi().getMainNav().jumpToPage(widget.curIndex - 1);
            widget.dispatch(DeleteTodoList(widget.todoList.id));
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Widget option(MultiSelectDialogOption option) {
    return Builder(builder: (context) {
      return InkWell(
        splashColor: Themer().splashPrimary(),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          height: 40.0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(option.title, style: TextStyle(color: Themer().anchorColor())),
            ],
          ),
        ),
        onTap: () => option.onTap(),
      );
    });
  }

  void setColor() {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var dispatch = (TodoListColor value) {
          widget.dispatch(SetTodoListColor(widget.todoList.id, value));
          Navigator.pop(context);
        };
        var options = [
          SettingOption(TodoListColor.purple, 'Color Scheme', 'Changes accent colors', 'Purple', dispatch, color: Colors.purple),
          SettingOption(TodoListColor.red, 'Color Scheme', 'Changes accent colors', 'Red', dispatch, color: Colors.red),
          SettingOption(TodoListColor.amber, 'Color Scheme', 'Changes accent colors', 'Amber', dispatch, color: Colors.amber),
          SettingOption(TodoListColor.lightGreen, 'Color Scheme', 'Changes accent colors', 'Green', dispatch, color: Colors.lightGreen),
          SettingOption(TodoListColor.cyan, 'Color Scheme', 'Changes accent colors', 'Cyan', dispatch, color: Colors.cyan),
          SettingOption(TodoListColor.lightBlue, 'Color Scheme', 'Changes accent colors', 'Sky Blue', dispatch, color: Colors.lightBlue),
          SettingOption(TodoListColor.blue, 'Color Scheme', 'Changes accent colors', 'Blue', dispatch, color: Colors.blue),
          SettingOption(TodoListColor.indigo, 'Color Scheme', 'Changes accent colors', 'Indigo', dispatch, color: Colors.indigo),
          SettingOption(TodoListColor.grey, 'Color Scheme', 'Changes accent colors', 'Grey', dispatch, color: Colors.grey),
        ];

        var children = options.map((option) {
          return InkWell(
            onTap: () => option.dispatch(option.value),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100.0,
                  height: 50.0,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      if (option.color != null)
                        Container(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Container(
                            height: 20.0,
                            width: 20.0,
                            decoration: BoxDecoration(color: option.color, borderRadius: BorderRadius.circular(20.0)),
                          ),
                        ),
                      Text(option.name, style: TextStyle(color: Themer().anchorColor(), fontSize: 20.0)),
                    ],
                  ),
                ),
              ],
            ),
          );
        });

        var content = Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(height: 10.0),
            Column(children: <Widget>[
              Text('Accent color', style: TextStyle(fontSize: 18.0, fontWeight: Themer().fontBold())),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                width: 200.0,
                child: Text('Set the accent color of this list.',
                    textAlign: TextAlign.center, style: TextStyle(color: Color(0xAA604B41), fontSize: 14.0)),
              ),
            ]),
            Container(height: 10.0),
            ...children,
            Container(height: 10.0),
          ],
        );

        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          content: Container(
            width: 100,
            child: content,
          ),
        );
      },
    );
  }
}

class _Props {
  final Function dispatch;
  final int curIndex;
  final List<int> positionOptions;

  _Props({
    this.dispatch,
    this.curIndex,
    this.positionOptions,
  });

  static fromStore(Store<AppState> store, int listId) {
    var list = store.state.todo.lists.keys;
    var curIndex = list.toList().indexOf(listId);
    var positionOptions = Iterable<int>.generate(list.length).toList();
    positionOptions.remove(curIndex);
    return _Props(
      dispatch: (action) => store.dispatch(action),
      curIndex: curIndex,
      positionOptions: positionOptions,
    );
  }
}
