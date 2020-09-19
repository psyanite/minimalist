import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:minimalist/components/common/ring_button.dart';
import 'package:minimalist/components/dialog/add_todo_dialog.dart';
import 'package:minimalist/model/todo_item.dart';
import 'package:minimalist/presentation/themer.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: _drawer(context),
      body: SafeArea(child: CustomScrollView(slivers: _todos())),
      floatingActionButton: _addButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _addButton() {
    return Container(
      margin: EdgeInsets.only(bottom: 35.0),
      child: RingButton(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return AddTodoDialog();
            },
          );
        }
      ),
    );
  }

  List<Widget> _todos() {
    return List<Widget>.from(widget.todos.map((todo) => _todo(todo)));
  }

  Widget _todo(TodoItem todo) {
    return SliverToBoxAdapter(
      child: InkWell(
        onTap: () => _showBottomSheet(todo),
        child: Container(child: Text(todo.title)),
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
