import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:minimalist/render/components/common/reorderable_listy.dart';
import 'package:minimalist/render/components/common/ring_button.dart';
import 'package:minimalist/render/home/add_todo_dialog.dart';
import 'package:minimalist/models/todo_item.dart';
import 'package:minimalist/render/presentation/themer.dart';
import 'package:minimalist/render/screens/about_screen.dart';
import 'package:minimalist/render/screens/settings_screen.dart';
import 'package:minimalist/state/app/app_state.dart';
import 'package:minimalist/state/me/todos/todo_actions.dart';
import 'package:minimalist/state/settings/settings_state.dart';
import 'package:redux/redux.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
      converter: (Store<AppState> store) => _Props.fromStore(store),
      builder: (BuildContext context, _Props props) {
        return _Presenter(
          todos: props.todoItems,
          dispatch: props.dispatch,
        );
      },
    );
  }
}

class _Presenter extends StatefulWidget {
  final List<TodoItem> todos;
  final Function dispatch;

  _Presenter({Key key, this.todos, this.dispatch}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: _drawer(context),
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            Expanded(child: Center(child: _todos())),
          ],
        ),
      ),
      bottomNavigationBar: _addButton(),
    );
  }

  Widget _header() {
    return Container(height: 50.0);
  }

  Widget _addButton() {
    return Container(
      margin: EdgeInsets.only(bottom: 35.0, top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RingButton(onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return AddTodoDialog();
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _todos() {
    var children = widget.todos.map((todo) => _todo(todo));
    // var children = widget.todos.asMap().map((index, todo) => MapEntry(index, _todo(index, todo))).values.toList();
    return ReorderableListyView(
      children: List<Widget>.from(children),
      onReorder: (int oldIndex, int newIndex) {

        widget.dispatch(ReorderTodo(oldIndex, newIndex));
      },
    );
  }

  Widget _todo(TodoItem todo) {
    switch (Themer().contentAlign()) {
      case ContentAlign.left:
        return InkWell(
          key: ValueKey(todo),
          onTap: () => _showBottomSheet(todo),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                padding: EdgeInsets.only(top: 12.0, left: 30.0, right: 30.0, bottom: 12.0),
                child: Text(todo.title, style: TextStyle(fontSize: 22.0)),
              ),
            ],
          ),
        );
        break;
      case ContentAlign.center:
      default:
        return InkWell(
          key: ValueKey(todo),
          onTap: () => _showBottomSheet(todo),
          child: Container(
            padding: EdgeInsets.only(top: 12.0, left: 30.0, right: 30.0, bottom: 12.0),
            child: Text(todo.title, style: TextStyle(fontSize: 22.0)),
          ),
        );
        break;
    }
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
            title: Text('Customise', style: TextStyle(fontSize: 22.0)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen()));
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
  final List<TodoItem> todoItems;
  final Function dispatch;

  _Props({
    this.todoItems,
    this.dispatch,
  });

  static fromStore(Store<AppState> store) {
    return _Props(
      todoItems: store.state.todo.items,
      dispatch: (action) => store.dispatch(action),
    );
  }
}
