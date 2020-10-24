import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:minimalist/models/board.dart';
import 'package:minimalist/models/todo_list.dart';
import 'package:minimalist/render/components/dialog/bottom_modal.dart';
import 'package:minimalist/render/components/dialog/confirm.dart';
import 'package:minimalist/render/components/dialog/multi_select_dialog.dart';
import 'package:minimalist/render/home/set_list_name_screen.dart';
import 'package:minimalist/render/presentation/themer.dart';
import 'package:minimalist/render/screens/settings_screen.dart';
import 'package:minimalist/state/app/app_state.dart';
import 'package:minimalist/state/me/todos/todo_actions.dart';
import 'package:redux/redux.dart';

class CustomiseListDialog extends StatelessWidget {
  final Board board;
  final TodoList todoList;

  const CustomiseListDialog(this.board, this.todoList, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
      converter: (Store<AppState> store) => _Props.fromStore(store, todoList.id),
      builder: (BuildContext context, _Props props) {
        return _Presenter(
          board: board,
          todoList: todoList,
          dispatch: props.dispatch,
        );
      },
    );
  }
}

class _Presenter extends StatefulWidget {
  final Board board;
  final TodoList todoList;
  final Function dispatch;

  const _Presenter({Key key, this.board, this.todoList, this.dispatch}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {

  @override
  Widget build(BuildContext context) {
    var options = [
      BottomModalOption(MultiSelectDialogOption(title: 'Set list name', onTap: setListName)),
      BottomModalOption(MultiSelectDialogOption(title: 'Set accent color', onTap: setColor)),
      BottomModalOption(MultiSelectDialogOption(title: widget.todoList.showCounter ? 'Hide counter' : 'Show counter', onTap: toggleCounter)),
    ];

    return BottomModal(options);
  }

  void setListName() {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => SetListNameScreen(widget.board, widget.todoList)));
  }

  void toggleCounter() {
    var showCounter = widget.todoList.showCounter;
    var verb = showCounter ? 'Hide' : 'Show';
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Confirm(
          title: '$verb counter',
          description: '$verb the counter for the number of done items in the top right hand corner.',
          action: verb,
          onTap: () {
            widget.dispatch(UpdateBoard(widget.board.updateList(widget.todoList.copyWith(showCounter: !showCounter))));
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void setColor() {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var dispatch = (TodoListColor value) {
          widget.dispatch(UpdateBoard(widget.board.updateList(widget.todoList.copyWith(color: value))));
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
              Text('Accent color', style: TextStyle(fontSize: 22.0, fontWeight: Themer().fontBold())),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                width: 200.0,
                child: Text('Set the accent color of this list.',
                    textAlign: TextAlign.center, style: TextStyle(color: Themer().hintTextColor(), fontSize: 20.0)),
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

  _Props({
    this.dispatch,
  });

  static fromStore(Store<AppState> store, int listId) {
    return _Props(
      dispatch: (action) => store.dispatch(action),
    );
  }
}
