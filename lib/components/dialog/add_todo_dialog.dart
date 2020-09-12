import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:minimalist/components/dialog/dialog.dart';
import 'package:minimalist/model/todo_item.dart';
import 'package:minimalist/presentation/themer.dart';
import 'package:minimalist/state/app/app_state.dart';
import 'file:///E:/Magic/minimalist/lib/state/me/todos/todo_actions.dart';
import 'package:redux/redux.dart';

class AddTodoDialog extends StatelessWidget {
  AddTodoDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Function>(
      converter: (Store<AppState> store) {
        return (item) {
          return store.dispatch(AddTodoItem(item));
        };
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

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var content = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(height: 10.0),
        Column(children: <Widget>[
          _titleField(),
          _descField(),
        ]),
        Container(height: 10.0),
        _okButton(context),
      ],
    );

    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      content: Container(
        width: 100,
        child: content,
      ),
    );
  }

  Widget _titleField() {
    return Container(
      width: 300.0,
      padding: EdgeInsets.only(bottom: 30.0),
      child: TextField(
        maxLines: null,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.multiline,
        onChanged: (text) => setState(() => _title = text),
        decoration: InputDecoration(
          hintText: 'Description',
          hintStyle: TextStyle(color: Themer().hintTextColor()),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Themer().lightGrey())),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Themer().primaryLight(), width: 1.0)),
        ),
      ),
    );
  }

  Widget _descField() {
    return Container(
      width: 300.0,
      padding: EdgeInsets.only(bottom: 30.0),
      child: TextField(
        maxLines: null,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.multiline,
        onChanged: (text) => setState(() => _desc = text),
        decoration: InputDecoration(
          hintText: 'Description',
          hintStyle: TextStyle(color: Themer().hintTextColor()),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Themer().lightGrey())),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Themer().primaryLight(), width: 1.0)),
        ),
      ),
    );
  }

  Widget _okButton(context) {
    return InkWell(
      onTap: submit,
      child: Container(
        foregroundDecoration: BoxDecoration(
          color: Colors.grey[100],
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  void submit() {
    var todoItem = TodoItem(title: _title, desc: _desc);
    widget.addTodoItem(todoItem);
  }

}

class Confirm extends StatelessWidget {
  final String title;
  final String description;
  final String action;
  final Function onTap;

  Confirm({Key key, this.title, this.description, this.action, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var content = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(height: 10.0),
        Column(children: <Widget>[
          Text(title, style: TextStyle(fontSize: 18.0, fontWeight: Themer().fontBold())),
          if (description != null) _description(),
        ]),
        Container(height: 10.0),
        _options(context),
      ],
    );
    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      content: Container(
        width: 100,
        child: content,
      ),
    );
  }

  Widget _description() {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      width: 200.0,
      child: Text(description, textAlign: TextAlign.center, style: TextStyle(color: Color(0xAA604B41), fontSize: 14.0)),
    );
  }

  Widget _options(context) {
    var options = <DialogOption>[
      DialogOption(
          display: action,
          onTap: onTap,
          style: TextStyle(color: Themer().anchorColor(), fontSize: 16.0, fontWeight: Themer().fontBold())),
      DialogOption(
          display: 'Cancel',
          onTap: () => Navigator.of(context, rootNavigator: true).pop(true),
          style: TextStyle(fontSize: 16.0)),
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.from(options.map((o) {
        return Column(children: <Widget>[Divider(color: Color(0x16007AFF)), _option(o)]);
      })),
    );
  }

  Widget _option(DialogOption option) {
    return InkWell(
      onTap: option.onTap,
      child: Container(
        height: 40.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[Text(option.display, style: option.style)],
        ),
      ),
    );
  }
}
