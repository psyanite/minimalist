import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:minimalist/models/todo_item.dart';
import 'package:minimalist/render/presentation/themer.dart';
import 'package:minimalist/state/app/app_state.dart';
import 'package:minimalist/state/me/todos/todo_actions.dart';
import 'package:redux/redux.dart';

class ShowTodoDialog extends StatelessWidget {
  final int listId;
  final int index;
  final TodoItem todo;

  const ShowTodoDialog(this.listId, this.index, this.todo, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
      converter: (Store<AppState> store) => _Props.fromStore(store),
      builder: (BuildContext context, _Props props) {
        return _Presenter(
          listId: listId,
          index: index,
          todo: todo,
          dispatch: props.dispatch,
        );
      },
    );
  }
}

class _Presenter extends StatefulWidget {
  final int listId;
  final int index;
  final TodoItem todo;
  final Function dispatch;

  const _Presenter({Key key, this.listId, this.index, this.todo, this.dispatch}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  bool _showDesc = false;
  TextEditingController _titleCtrl = TextEditingController();
  TextEditingController _descCtrl = TextEditingController();

  @override
  initState() {
    super.initState();
    if (widget.todo.title != null) _titleCtrl = TextEditingController.fromValue(TextEditingValue(text: widget.todo.title));
    if (widget.todo.desc != null) _descCtrl = TextEditingController.fromValue(TextEditingValue(text: widget.todo.desc));
  }

  @override
  dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets,
      duration: Duration(milliseconds: 100),
      curve: Curves.ease,
      child: Container(
        padding: EdgeInsets.only(top: 20.0, bottom: 30.0),
        width: 100.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(children: <Widget>[
                _titleField(),
                if (_showDesc) _descField(),
              ]),
            ),
            Container(height: 10.0),
            buttons(),
          ],
        ),
      ),
    );
  }

  Widget _titleField() {
    return Container(
      width: 300.0,
      child: TextField(
        controller: _titleCtrl,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          hintText: 'New todo',
          hintStyle: TextStyle(color: Themer().hintTextColor()),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }

  Widget _descField() {
    return Container(
      width: 300.0,
      child: TextField(
        controller: _descCtrl,
        style: TextStyle(fontSize: 18.0),
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          hintText: 'Add details',
          hintStyle: TextStyle(color: Themer().hintTextColor()),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }

  Widget okButton() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => submit(context),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Text('Save',
            style: TextStyle(
                fontWeight: Themer().fontBold(),
                color: Themer().primaryTextColor())),
      ),
    );
  }

  Widget showDescButton() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => setState(() => _showDesc = !_showDesc),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Text('Add details',
            style: TextStyle(color: Themer().anchorColor())),
      ),
    );
  }

  Widget buttons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        _showDesc ? Container() : showDescButton(),
        okButton(),
      ]),
    );
  }

  void submit(BuildContext context) {
    var newTodo = widget.todo.copyWith(
      title: _titleCtrl.text,
      desc: _descCtrl.text,
    );
    widget.dispatch(UpdateTodo(widget.listId, widget.index, newTodo));
    Navigator.of(context).pop();
  }
}

class _Props {
  final Function dispatch;

  _Props({
    this.dispatch,
  });

  static fromStore(Store<AppState> store) {
    return _Props(
      dispatch: (action) => store.dispatch(action),
    );
  }
}
