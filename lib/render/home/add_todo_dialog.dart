import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:minimalist/models/todo_item.dart';
import 'package:minimalist/render/components/common/components.dart';
import 'package:minimalist/render/presentation/themer.dart';
import 'package:minimalist/state/app/app_state.dart';
import 'package:minimalist/state/me/todos/todo_actions.dart';
import 'package:redux/redux.dart';

class AddTodoDialog extends StatelessWidget {
  final int listId;

  const AddTodoDialog(this.listId, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Function>(
      converter: (Store<AppState> store) {
        return (item) => store.dispatch(AddTodo(listId, item));
      },
      builder: (BuildContext context, Function addTodoItem) {
        return _Presenter(addTodoItem: addTodoItem);
      },
    );
  }
}

class _Presenter extends StatefulWidget {
  final Function addTodoItem;

  _Presenter({Key key, this.addTodoItem}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  String _title;
  String _desc;
  bool _showDesc = false;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalWrapper(
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
    );
  }

  Widget _titleField() {
    return Container(
      width: 300.0,
      child: TextField(
        style: TextStyle(fontSize: 18.0),
        autofocus: true,
        maxLines: null,
        keyboardType: TextInputType.multiline,
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

  Widget _descField() {
    return Container(
      width: 300.0,
      child: TextField(
        style: TextStyle(fontSize: 18.0),
        maxLines: null,
        keyboardType: TextInputType.multiline,
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

  Widget okButton() {
    var color = _title == null ? Themer().lightTextColor() : Themer().primaryTextColor();
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => submit(context),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Text('Save', style: TextStyle(fontWeight: Themer().fontBold(), color: color)),
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
        child: Text('Add details', style: TextStyle(color: Themer().anchorColor())),
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
    if (_title != null) {
      var todoItem = TodoItem(title: _title, desc: _desc);
      widget.addTodoItem(todoItem);
      Navigator.of(context).pop();
    }
  }
}
