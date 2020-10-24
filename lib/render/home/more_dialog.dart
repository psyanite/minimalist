import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:minimalist/models/board.dart';
import 'package:minimalist/models/todo_item.dart';
import 'package:minimalist/models/todo_list.dart';
import 'package:minimalist/render/components/dialog/bottom_modal.dart';
import 'package:minimalist/render/components/dialog/confirm.dart';
import 'package:minimalist/render/components/dialog/dialog.dart';
import 'package:minimalist/render/components/dialog/multi_select_dialog.dart';
import 'package:minimalist/render/home/customise_list_dialog.dart';
import 'package:minimalist/services/navi.dart';
import 'package:minimalist/state/app/app_state.dart';
import 'package:minimalist/state/me/todos/todo_actions.dart';
import 'package:redux/redux.dart';

class MoreDialog extends StatelessWidget {
  final Board board;
  final TodoList todoList;

  const MoreDialog(this.board, this.todoList, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
      converter: (Store<AppState> store) => _Props.fromStore(store, board, todoList.id),
      builder: (BuildContext context, _Props props) {
        return _Presenter(
          board: board,
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
  final Board board;
  final TodoList todoList;
  final int curIndex;
  final List<int> positionOptions;
  final Function dispatch;

  const _Presenter({Key key, this.board, this.todoList, this.curIndex, this.positionOptions, this.dispatch}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  bool _addListLoading = false;

  @override
  Widget build(BuildContext context) {
    var options = [
      _addListLoading ? loadingIcon() : BottomModalOption(MultiSelectDialogOption(title: 'Add new list', onTap: addList)),
      BottomModalOption(MultiSelectDialogOption(title: 'Customise list', onTap: showCustomiseListDialog)),
      BottomModalOption(MultiSelectDialogOption(title: 'Delete done items', onTap: deleteDoneItems)),
      BottomModalOption(MultiSelectDialogOption(title: 'Move list', onTap: moveList)),
      BottomModalOption(MultiSelectDialogOption(title: 'Delete list', onTap: deleteList)),
    ];

    return BottomModal(options);
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

  void showCustomiseListDialog() {
    Navigator.pop(context);
    showModalBottomSheet(context: context, builder: (context) {
      return CustomiseListDialog(widget.board, widget.todoList);
    });
  }

  void addList() {
    var update = widget.board.createNewTodoList(widget.todoList.id);
    widget.dispatch(UpdateBoard(update));

    setState(() => _addListLoading = true);
    Timer(Duration(milliseconds: 100), () {
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
              widget.dispatch(UpdateBoard(widget.board.reorderList(widget.curIndex, index)));
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

  void deleteDoneItems() {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Confirm(
          title: 'Delete Done Items',
          description: 'Done items in the list will lost forever.',
          action: 'Delete',
          onTap: () {
            var clone = widget.todoList.cloneTodoItems();
            clone.removeWhere((todo) => todo.status == TodoStatus.done);
            var updatedList = widget.todoList.copyWith(todos: clone);
            widget.dispatch(UpdateBoard(widget.board.updateList(updatedList)));
            Navigator.pop(context);
          },
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
            widget.dispatch(UpdateBoard(widget.board.deleteList(widget.todoList)));
            if (widget.curIndex == 0) {
              Navi().getMainNav().jumpToPage(widget.curIndex);
            } else if (widget.curIndex > 0) {
              Navi().getMainNav().jumpToPage(widget.curIndex - 1);
            }
            Navigator.pop(context);
          },
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

  static fromStore(Store<AppState> store, Board board, int listId) {
    var list = store.state.todo.boards[board.id].lists.keys;
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
