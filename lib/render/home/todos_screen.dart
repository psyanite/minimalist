import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:minimalist/models/todo_item.dart';
import 'package:minimalist/models/todo_list.dart';
import 'package:minimalist/render/components/common/reorderable_listy.dart';
import 'package:minimalist/render/components/common/ring_button.dart';
import 'package:minimalist/render/home/add_todo_screen.dart';
import 'package:minimalist/render/presentation/themer.dart';
import 'package:minimalist/render/screens/about_screen.dart';
import 'package:minimalist/render/screens/theme_screen.dart';
import 'package:minimalist/state/app/app_state.dart';
import 'package:minimalist/state/me/todos/todo_actions.dart';
import 'package:minimalist/state/settings/settings_state.dart';
import 'package:redux/redux.dart';

import 'more_dialog.dart';

class TodosScreen extends StatelessWidget {
  final int todoListId;

  const TodosScreen(this.todoListId, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
      converter: (Store<AppState> store) => _Props.fromStore(store, todoListId),
      builder: (BuildContext context, _Props props) {
        return _Presenter(
          listId: props.todoList.id,
          todoList: props.todoList,
          dispatch: props.dispatch,
        );
      },
    );
  }
}

class _Presenter extends StatefulWidget {
  final int listId;
  final TodoList todoList;
  final Function dispatch;

  _Presenter({Key key, this.listId, this.todoList, this.dispatch}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: _drawer(context),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(height: 50.0),
              _title(),
              Container(height: 20.0),
              Flexible(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: _todos(),
              )),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _bottom(),
    );
  }

  Widget _title() {
    return Container(height: 30.0, child: Text(widget.todoList.name, style: Themer().listNameTitleStyle()));
  }

  Widget _bottom() {
    return Container(
      height: 100.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          moreButton(),
          addButton(),
          settingsButton(),
        ],
      ),
    );
  }

  Widget moreButton() {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (builder) {
              return MoreDialog(widget.listId, widget.todoList);
            });
      },
      child: Container(
        height: 100.0,
        child: Center(
          child: Container(
            margin: EdgeInsets.only(left: 50.0, right: 10.0),
            width: 15.0,
            height: 15.0,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0), color: Themer().ringColor()),
          ),
        ),
      ),
    );
  }

  Widget addButton() {
    return RingButton(onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (_) => AddTodoScreen(widget.listId)));
    });
  }

  Widget settingsButton() {
    return Builder(builder: (context) {
      return InkWell(
        onTap: () => Scaffold.of(context).openEndDrawer(),
        child: Container(
          height: 100.0,
          child: Center(
            child: Container(
              margin: EdgeInsets.only(left: 10.0, right: 50.0),
              width: 15.0,
              height: 15.0,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0), color: Themer().ringColor()),
            ),
          ),
        ),
      );
    });
  }

  Widget _todos() {
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

    var children = widget.todoList.todos.map((todo) => Container(key: ValueKey(todo), child: TodoCard(todo)));
    return ReorderableListyView(
      children: List<Widget>.from(children),
      columnMainAxisAlignment: columnAlign,
      onReorder: (int oldIndex, int newIndex) {
        widget.dispatch(ReorderTodo(widget.listId, oldIndex, newIndex));
      },
    );
  }

  Widget _drawer(BuildContext context) {
    return Drawer(
      child: Center(
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          Container(height: 500),
          ListTile(
            title: Text('Theme', style: TextStyle(fontSize: 22.0)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => ThemeScreen()));
            },
          ),
          ListTile(
            title: Text('About', style: TextStyle(fontSize: 22.0)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => AboutScreen()));
            },
          ),
        ]),
      ),
    );
  }
}

class _Props {
  final TodoList todoList;
  final Function dispatch;

  _Props({
    this.todoList,
    this.dispatch,
  });

  static fromStore(Store<AppState> store, int todoListId) {
    return _Props(
      todoList: store.state.todo.lists[todoListId],
      dispatch: (action) => store.dispatch(action),
    );
  }
}

class TodoCard extends StatelessWidget {
  final TodoItem todo;

  const TodoCard(this.todo, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textColor = todo.status == TodoStatus.standby ? Themer().textBodyColor() : Themer().hintTextColor();
    return InkWell(
      onTap: () => _showBottomSheet(todo, context),
      child: Padding(
        padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            _circle(),
            Expanded(
              child: Container(
                child: Text(todo.title, style: TextStyle(fontSize: 22.0, color: textColor)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circle() {
    if (todo.status == TodoStatus.standby) {
      return Container(
        margin: EdgeInsets.only(right: 30.0, top: 3.0),
        height: 18.0,
        width: 18.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          border: Border.all(color: Themer().primary(), width: 2.0),
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(right: 30.0),
        height: 18.0,
        width: 18.0,
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50.0)), color: Themer().primary()),
      );
    }
  }

  _showBottomSheet(TodoItem todo, BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => _todoBottomSheet(todo, context),
    );
  }

  Widget _todoBottomSheet(TodoItem todo, BuildContext context) {
    return Container(
      child: Text(todo.title),
    );
  }
}
