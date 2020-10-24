import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:minimalist/models/board.dart';
import 'package:minimalist/models/todo_list.dart';
import 'package:minimalist/render/components/common/components.dart';
import 'package:minimalist/render/presentation/themer.dart';
import 'package:minimalist/state/app/app_state.dart';
import 'package:minimalist/state/me/todos/todo_actions.dart';
import 'package:redux/redux.dart';

class SetListNameScreen extends StatelessWidget {
  final Board board;
  final TodoList todoList;

  const SetListNameScreen(this.board, this.todoList, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Function>(
      converter: (Store<AppState> store) {
        return (name) => store.dispatch(UpdateBoard(board.updateList(todoList.copyWith(name: name))));
      },
      builder: (BuildContext context, Function setListName) {
        return _Presenter(setListName: setListName);
      },
    );
  }
}

class _Presenter extends StatefulWidget {
  final Function setListName;

  _Presenter({Key key, this.setListName}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  String _name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Header(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  nameField(),
                ]),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 50.0, left: 30.0, right: 30.0),
            child: okButton(),
          )
        ],
      ),
    );
  }


  Widget nameField() {
    return Container(
      width: 300.0,
      child: TextField(
        style: TextStyle(fontSize: 36.0),
        autofocus: true,
        onSubmitted: (text) => submit(),
        onChanged: (text) => setState(() => _name = text),
        decoration: InputDecoration(
          hintText: 'New list',
          hintStyle: TextStyle(color: Themer().hintTextColor()),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }

  Widget okButton() {
    return BurntButton(text: 'Save', onTap: submit, color: Themer().primaryTextColor());
  }

  void submit() {
    widget.setListName(_name ?? '');
    Navigator.of(context).pop();
  }
}
