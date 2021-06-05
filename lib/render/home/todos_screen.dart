import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:minimalist/models/board.dart';
import 'package:minimalist/models/todo_item.dart';
import 'package:minimalist/models/todo_list.dart';
import 'package:minimalist/render/components/common/clap.dart';
import 'package:minimalist/render/components/common/reorderable_listy.dart';
import 'package:minimalist/render/components/dialog/bottom_modal.dart';
import 'package:minimalist/render/components/dialog/multi_select_dialog.dart';
import 'package:minimalist/render/home/add_todo_screen.dart';
import 'package:minimalist/render/home/boards_screen.dart';
import 'package:minimalist/render/home/more_dialog.dart';
import 'package:minimalist/render/home/set_list_name_screen.dart';
import 'package:minimalist/render/home/show_todo_screen.dart';
import 'package:minimalist/render/presentation/themer.dart';
import 'package:minimalist/render/screens/settings_screen.dart';
import 'package:minimalist/state/app/app_state.dart';
import 'package:minimalist/state/me/todos/todo_actions.dart';
import 'package:minimalist/state/settings/settings_state.dart';
import 'package:minimalist/utils/general_utils.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';

class TodosScreen extends StatelessWidget {
  final Board board;
  final int todoListId;

  const TodosScreen(this.board, this.todoListId, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
      converter: (Store<AppState> store) => _Props.fromStore(store, board, todoListId),
      builder: (BuildContext context, _Props props) {
        return _Presenter(
          board: board,
          todoList: props.todoList,
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

  _Presenter({Key key, this.board, this.todoList, this.dispatch}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  ScrollController _scrollie = ScrollController();

  @override
  dispose() {
    _scrollie.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(height: 50.0),
              title(),
              Container(height: 20.0),
              Flexible(child: todos()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottom(),
    );
  }

  Widget title() {
    return InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SetListNameScreen(widget.board, widget.todoList))),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(left: 30.0),
              height: 30.0,
              child: Text(widget.todoList.name, style: Themer().listNameTitleStyle()),
            ),
            if (widget.todoList.showCounter)
              Padding(
                padding: EdgeInsets.only(right: 30.0),
                child: Clap(widget.todoList.completedCount, mapTodoListColor(widget.todoList.color)),
              ),
          ],
        ));
  }

  Widget bottom() {
    return Container(
      height: 120.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          settingsButton(),
          addButton(),
          moreButton(),
        ],
      ),
    );
  }

  Widget moreButton() {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return MoreDialog(widget.board, widget.todoList);
            });
      },
      child: Container(
        height: 120.0,
        child: Center(
          child: Container(
            margin: EdgeInsets.only(right: 50.0, left: 20.0),
            width: 10.0,
            height: 10.0,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Themer().ringColor()),
          ),
        ),
      ),
    );
  }

  Widget addButton() {
    return InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Container(
          height: 120,
          padding: EdgeInsets.only(top: 35.0, bottom: 35.0),
          child: Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                border: Border.all(color: Themer().ringColor(), width: 3.0),
              ),
              child: Container()),
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => AddTodoScreen(widget.board, widget.todoList, scrollToTheBottom)));
        });
  }

  void scrollToTheBottom() {
    Timer(
      Duration(milliseconds: 250),
      () => _scrollie.animateTo(
        _scrollie.position.maxScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      ),
    );
  }

  Widget settingsButton() {
    return Builder(builder: (context) {
      return InkWell(
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return settingsMenu();
              });
        },
        child: Container(
          height: 120.0,
          child: Center(
            child: Container(
              margin: EdgeInsets.only(right: 20.0, left: 50.0),
              width: 10.0,
              height: 10.0,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Themer().ringColor()),
            ),
          ),
        ),
      );
    });
  }

  Widget todos() {
    var columnAlign;
    switch (Themer().verticalContentAlign()) {
      case VerticalContentAlign.top:
        columnAlign = MainAxisAlignment.start;
        break;
      case VerticalContentAlign.center:
        columnAlign = MainAxisAlignment.center;
        break;
      case VerticalContentAlign.bottom:
        columnAlign = MainAxisAlignment.end;
        break;
    }

    var children = widget.todoList.todos.map((todo) => Container(
        key: ValueKey(todo),
        child: TodoCard(
          widget.board,
          widget.todoList,
          todo,
          widget.dispatch,
        )));

    return ReorderableListyView(
      scrollController: _scrollie,
      children: List<Widget>.from(children),
      columnMainAxisAlignment: columnAlign,
      onReorder: (int oldIndex, int newIndex) {
        widget.dispatch(UpdateBoard(widget.board.updateList(widget.todoList.reorderTodo(oldIndex, newIndex))));
      },
    );
  }

  Widget settingsMenu() {
    var options = [
      BottomModalOption(MultiSelectDialogOption(
          title: 'View Collections',
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => BoardsScreen()));
          })),
      BottomModalOption(MultiSelectDialogOption(
          title: 'Settings',
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen()));
          })),
      BottomModalOption(MultiSelectDialogOption(
          title: 'Contact Us',
          onTap: () async {
            Navigator.pop(context);
            var deviceInfo = await Utils.getDeviceInfo();
            launch(Utils.buildEmail('', '(insert-your-query-here)\n\n\nDiagnostics:\n\n$deviceInfo\n\n'));
          })),
    ];

    return BottomModal(options);
  }
}

class _Props {
  final TodoList todoList;
  final Function dispatch;

  _Props({
    this.todoList,
    this.dispatch,
  });

  static fromStore(Store<AppState> store, Board board, int todoListId) {
    return _Props(
      todoList: store.state.todo.boards[board.id].lists[todoListId],
      dispatch: (action) => store.dispatch(action),
    );
  }
}

class TodoCard extends StatelessWidget {
  final Board board;
  final TodoList todoList;
  final TodoItem todo;
  final Function dispatch;

  const TodoCard(this.board, this.todoList, this.todo, this.dispatch, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textColor = todo.status == TodoStatus.standby ? Themer().textBodyColor() : Themer().hintTextColor();
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => ShowTodoScreen(board, todoList, todo)));
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          circle(),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 12.0, bottom: 12.0, right: 50.0),
              child: Text(todo.title, style: TextStyle(fontSize: 22.0, color: textColor)),
            ),
          ),
        ],
      ),
    );
  }

  Widget circle() {
    Color color = mapTodoListColor(todoList.color);
    return InkWell(
      onTap: () {
        var newStatus = todo.status == TodoStatus.standby ? TodoStatus.done : TodoStatus.standby;
        dispatch(UpdateBoard(board.updateList(todoList.updateTodoStatus(todo, newStatus))));
      },
      child: Container(
        padding: EdgeInsets.only(top: 12.0, bottom: 12.0, left: 40.0, right: 30.0),
        child: todo.status == TodoStatus.standby
            ? Container(
                height: 18.0,
                width: 18.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  border: Border.all(color: color, width: 2.0),
                ))
            : Container(height: 18.0, width: 18.0, decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50.0)), color: color)),
      ),
    );
  }
}
