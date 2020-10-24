import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:minimalist/models/board.dart';
import 'package:minimalist/models/todo_item.dart';
import 'package:minimalist/models/todo_list.dart';
import 'package:minimalist/render/components/common/components.dart';
import 'package:minimalist/render/presentation/themer.dart';
import 'package:minimalist/state/app/app_state.dart';
import 'package:minimalist/state/me/todos/todo_actions.dart';
import 'package:redux/redux.dart';

class AddTodoScreen extends StatelessWidget {
  final Board board;
  final TodoList list;
  final Function onSubmit;

  const AddTodoScreen(this.board, this.list, this.onSubmit, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Function>(
      converter: (Store<AppState> store) {
        return (a) => store.dispatch(a);
      },
      builder: (BuildContext context, Function dispatch) {
        return _Presenter(board: board, list: list, dispatch: dispatch, onSubmit: onSubmit);
      },
    );
  }
}

class _Presenter extends StatefulWidget {
  final Board board;
  final TodoList list;
  final Function dispatch;
  final Function onSubmit;

  _Presenter({Key key, this.board, this.list, this.dispatch, this.onSubmit}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  String _title;
  String _desc;
  bool _showDesc = false;
  FocusNode _descTextFieldFocus;

  @override
  initState() {
    super.initState();
    _descTextFieldFocus = FocusNode();
  }

  @override
  void dispose() {
    _descTextFieldFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var children = [
      Header(),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleField(),
            if (_showDesc) descField(),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_showDesc) addDetailsButton(),
            saveButton(),
          ],
        ),
      )
    ];
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraint) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: children,
            ),
          ),
        );
      }),
    );
  }

  Widget titleField() {
    return Container(
      width: 300.0,
      child: TextField(
        style: TextStyle(fontSize: 36.0),
        maxLines: null,
        autofocus: true,
        onSubmitted: (text) => submit(),
        onChanged: (text) => setState(() => _title = text),
        decoration: InputDecoration(
          hintText: 'New todo',
          hintStyle: TextStyle(color: Themer().hintTextColor()),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }

  Widget descField() {
    return Container(
      width: 300.0,
      child: TextField(
        focusNode: _descTextFieldFocus,
        scrollPhysics: ClampingScrollPhysics(),
        style: TextStyle(fontSize: 18.0),
        keyboardType: TextInputType.multiline,
        maxLines: null,
        onChanged: (text) => setState(() => _desc = text),
        decoration: InputDecoration(
          hintText: 'Add details',
          hintStyle: TextStyle(color: Themer().hintTextColor()),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }

  Widget saveButton() {
    var color = _title == null ? Themer().lightGrey() : Themer().primaryTextColor();
    return Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: BurntButton(text: 'Save', onTap: submit, color: color),
    );
  }

  Widget addDetailsButton() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () =>
          setState(() {
            _showDesc = !_showDesc;
            _descTextFieldFocus.requestFocus();
          }),
      child: Container(
        margin: EdgeInsets.only(top: 10.0, bottom: 30.0, right: 50.0),
        child: Text('Add details', style: TextStyle(color: Themer().anchorColor())),
      ),
    );
  }

  void submit() {
    if (_title != null) {
      var todo = TodoItem(title: _title, desc: _desc, createdAt: DateTime.now());
      widget.dispatch(UpdateBoard(widget.board.updateList(widget.list.addTodo(todo))));
      Navigator.of(context).pop();
      widget.onSubmit();
    }
  }
}
