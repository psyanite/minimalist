import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:minimalist/models/todo_item.dart';
import 'package:minimalist/models/todo_list.dart';
import 'package:minimalist/render/components/common/reorderable_listy.dart';
import 'package:minimalist/render/components/common/ring_button.dart';
import 'package:minimalist/render/home/add_todo_dialog.dart';
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
                Flexible(child: _todos()),
              ],
            ),
        ),
      ),
      bottomNavigationBar: _bottom(),
    );
  }

  Widget _title() {
    return Container(child: Text(widget.todoList.name, style: Themer().listNameTitleStyle()));
  }

  Widget _bottom() {
    return Container(
      margin: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 35.0, top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _moreButton(),
          _addButton(),
          _settingsButton(),
        ],
      ),
    );
  }

  Widget _moreButton() {
    return RingButton(
      size: 30.0,
      ringWidth: 20.0,
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (builder) {
              return MoreDialog(widget.listId, widget.todoList);
            });
      },
    );
  }

  Widget _addButton() {
    return RingButton(onTap: () {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return AddTodoDialog(widget.listId);
        },
      );
    });
  }

  Widget _settingsButton() {
    return Builder(builder: (context) {
      return RingButton(
        size: 30.0,
        ringWidth: 20.0,
        onTap: () => Scaffold.of(context).openEndDrawer(),
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

    var children = widget.todoList.todos.map((todo) => _todo(todo));
    return ReorderableListyView(
      children: List<Widget>.from(children),
      columnMainAxisAlignment: columnAlign,
      onReorder: (int oldIndex, int newIndex) {
        widget.dispatch(ReorderTodo(widget.listId, oldIndex, newIndex));
      },
    );
  }

  Widget _todo(TodoItem todo) {
    var textAlign;
    switch (Themer().contentAlign()) {
      case ContentAlign.left:
        textAlign = TextAlign.left;
        break;
      case ContentAlign.center:
        textAlign = TextAlign.left;
        break;
      case ContentAlign.right:
      default:
        textAlign = TextAlign.right;
        break;
    }

    return InkWell(
      key: ValueKey(todo),
      onTap: () => _showBottomSheet(todo),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 12.0, left: 30.0, right: 30.0, bottom: 12.0),
              child: Text(todo.title, style: TextStyle(fontSize: 22.0), textAlign: textAlign),
            ),
          ),
        ],
      ),
    );
  }

  _showBottomSheet(TodoItem todo) {
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
