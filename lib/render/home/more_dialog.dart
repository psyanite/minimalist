import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:minimalist/models/todo_list.dart';
import 'package:minimalist/render/components/dialog/confirm.dart';
import 'package:minimalist/render/components/dialog/multi_select_dialog.dart';
import 'package:minimalist/render/home/set_list_name_dialog.dart';
import 'package:minimalist/render/presentation/themer.dart';
import 'package:minimalist/services/navi.dart';
import 'package:minimalist/state/app/app_state.dart';
import 'package:minimalist/state/me/todos/todo_actions.dart';
import 'package:redux/redux.dart';

class MoreDialog extends StatelessWidget {
  final int listId;
  final TodoList todoList;

  const MoreDialog(this.listId, this.todoList, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
      converter: (Store<AppState> store) => _Props.fromStore(store, listId),
      builder: (BuildContext context, _Props props) {
        return _Presenter(
          listId: listId,
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
  final int listId;
  final TodoList todoList;
  final int curIndex;
  final List<int> positionOptions;
  final Function dispatch;

  const _Presenter({Key key, this.listId, this.todoList, this.curIndex, this.positionOptions, this.dispatch})
      : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  bool _addListLoading = false;

  @override
  Widget build(BuildContext context) {
    var options = [
      _addListLoading ? _loadingIcon() : _option(MultiSelectDialogOption(title: 'Add list', onTap: _addList)),
      _option(MultiSelectDialogOption(title: 'Set list name', onTap: _setListName)),
      _option(MultiSelectDialogOption(title: 'Move list', onTap: _moveList)),
      _option(MultiSelectDialogOption(title: 'Delete list', onTap: _deleteList))
    ];
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 5.0),
          Container(
            child: ListView.separated(
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

  Widget _loadingIcon() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      height: 40.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20.0, width: 20.0, child: CircularProgressIndicator())
        ],
      ),
    );
  }

  void _setListName() {
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SetListNameDialog(widget.listId);
      },
    );
  }

  void _addList() {
    widget.dispatch(CreateNewTodoList(widget.listId));
    setState(() => _addListLoading = true);
    Timer(Duration(milliseconds: 500), () {
      Navigator.pop(context);
      Navi().getMainNav().jumpToPage(widget.curIndex + 1);
    });
  }

  void _moveList() {
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SetListNameDialog(widget.listId);
      },
    );
  }

  void _deleteList() {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Confirm(
          title: 'Delete List',
          description: 'This list will be lost forever.',
          action: 'Delete',
          onTap: () {
            widget.dispatch(DeleteTodoList(widget.listId));
            Navigator.pop(context);
            Navi().getMainNav().jumpToPage(widget.curIndex - 1);
          },
        );
      },
    );
  }

  Widget _option(MultiSelectDialogOption option) {
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
