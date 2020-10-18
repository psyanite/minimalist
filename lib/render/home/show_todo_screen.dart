import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:minimalist/models/todo_item.dart';
import 'package:minimalist/render/components/common/components.dart';
import 'package:minimalist/render/components/dialog/confirm.dart';
import 'package:minimalist/render/presentation/themer.dart';
import 'package:minimalist/state/app/app_state.dart';
import 'package:minimalist/state/me/todos/todo_actions.dart';
import 'package:minimalist/utils/time_util.dart';
import 'package:redux/redux.dart';

class ShowTodoScreen extends StatelessWidget {
  final int listId;
  final TodoItem todo;

  const ShowTodoScreen(this.listId, this.todo, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
      converter: (Store<AppState> store) => _Props.fromStore(store),
      builder: (BuildContext context, _Props props) {
        return _Presenter(
          listId: listId,
          todo: todo,
          dispatch: props.dispatch,
        );
      },
    );
  }
}

class _Presenter extends StatefulWidget {
  final int listId;
  final TodoItem todo;
  final Function dispatch;

  const _Presenter({Key key, this.listId, this.todo, this.dispatch}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  TextEditingController _titleCtrl;
  TextEditingController _descCtrl;
  bool _showDesc;
  FocusNode _descTextFieldFocus;

  @override
  initState() {
    super.initState();
    _titleCtrl = TextEditingController.fromValue(TextEditingValue(text: widget.todo.title));
    _descCtrl = TextEditingController.fromValue(TextEditingValue(text: widget.todo.desc ?? ''));
    _descTextFieldFocus = FocusNode();
    _showDesc = widget.todo.desc != null ? true : false;
  }

  @override
  void dispose() {
    _descTextFieldFocus.dispose();
    _titleCtrl.dispose();
    _descCtrl.dispose();
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
            options(),
            button(),
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
        controller: _titleCtrl,
        style: TextStyle(fontSize: 36.0),
        onSubmitted: (text) => submit(),
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

  Widget descField() {
    return Container(
      width: 300.0,
      child: TextField(
        controller: _descCtrl,
        focusNode: _descTextFieldFocus,
        scrollPhysics: ClampingScrollPhysics(),
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

  Widget options() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'created ${TimeUtil.format(widget.todo.createdAt)}',
              style: TextStyle(color: Themer().hintTextColor()),
            ),
            _showDesc ? deleteDetailsButton() : addDetailsButton(),
          ],
        ),
        InkWell(
          onTap: showDeleteDialog,
          child: Container(
              margin: EdgeInsets.only(bottom: 30.0, left: 20.0),
              child: Icon(Icons.delete_outline, color: Themer().hintTextColor())),
        )
      ],
    );
  }

  void showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Confirm(
          title: 'Delete Todo',
          description: 'This todo will be lost forever.',
          action: 'Delete',
          onTap: () {
            widget.dispatch(DeleteTodo(widget.listId, widget.todo));
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Widget button() {
    if (_titleCtrl.text == '') {
      return Padding(
          padding: EdgeInsets.only(bottom: 20.0),
          child: BurntButton(text: 'Delete', onTap: showDeleteDialog, color: Colors.red));
    } else {
      return Padding(
          padding: EdgeInsets.only(bottom: 20.0),
          child: BurntButton(text: 'Save', onTap: submit, color: Themer().primaryTextColor()));
    }
  }

  Widget addDetailsButton() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => setState(() {
        _showDesc = !_showDesc;
        _descTextFieldFocus.requestFocus();
      }),
      child: Container(
        margin: EdgeInsets.only(top: 10.0, bottom: 30.0, right: 50.0),
        child: Text('Add details', style: TextStyle(color: Themer().anchorColor())),
      ),
    );
  }

  Widget deleteDetailsButton() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => setState(() {
        _showDesc = !_showDesc;
        _descTextFieldFocus.requestFocus();
        _descCtrl.text = '';
      }),
      child: Container(
        margin: EdgeInsets.only(top: 10.0, bottom: 30.0, right: 50.0),
        child: Text('Delete details', style: TextStyle(color: Themer().anchorColor())),
      ),
    );
  }

  void submit() {
    if (_titleCtrl.text != null) {
      var newTodoItem = widget.todo.copyWith(title: _titleCtrl.text, desc: _descCtrl.text);
      widget.dispatch(UpdateTodo(widget.listId, widget.todo, newTodoItem));
      Navigator.of(context).pop();
    }
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
