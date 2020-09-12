import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:minimalist/components/dialog/add_todo_dialog.dart';
import 'package:minimalist/model/todo_item.dart';
import 'package:minimalist/screens/about_screen.dart';
import 'package:minimalist/screens/settings_screen.dart';
import 'package:minimalist/state/app/app_state.dart';
import 'package:redux/redux.dart';


class HomeScreen extends StatelessWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
      converter: (Store<AppState> store) => _Props.fromStore(store),
      builder: (BuildContext context, _Props props) {
        return _Presenter(todos: props.todoItems);
      },
    );
  }
}

class _Presenter extends StatefulWidget {
  final List<TodoItem> todos;

  _Presenter({Key key, this.todos}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: _drawer(context),
      body: CustomScrollView(slivers: <Widget>[]),
      floatingActionButton: _addButton(),
    );
  }

  Widget _addButton() {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AddTodoDialog();
          },
        );
      },
      child: Icon(Icons.add),
      backgroundColor: Colors.grey[30],
    );
  }

  Widget _drawer(BuildContext context) {
    return Drawer(
      child: Center(
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          Container(height: 500),
          ListTile(
            title: Text('Customise', style: TextStyle(fontSize: 18.0)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen()));
            },
          ),
          ListTile(
            title: Text('About', style: TextStyle(fontSize: 18.0)),
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

  _Props({
    this.todoItems,
  });

  static fromStore(Store<AppState> store) {
    return _Props(
      todoItems: store.state.todo.items,
    );
  }
}
