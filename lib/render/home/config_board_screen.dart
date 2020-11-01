import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:minimalist/models/board.dart';
import 'package:minimalist/render/components/common/components.dart';
import 'package:minimalist/render/components/dialog/confirm.dart';
import 'package:minimalist/render/presentation/themer.dart';
import 'package:minimalist/state/app/app_state.dart';
import 'package:minimalist/state/me/todos/todo_actions.dart';
import 'package:redux/redux.dart';

class ConfigBoardScreen extends StatelessWidget {
  final Board board;

  const ConfigBoardScreen(this.board, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
      converter: (Store<AppState> store) => _Props.fromStore(store),
      builder: (BuildContext context, _Props props) {
        return _Presenter(
          board: board,
          boardSize: props.boardSize,
          dispatch: props.dispatch,
        );
      },
    );
  }
}

class _Presenter extends StatefulWidget {
  final Board board;
  final int boardSize;
  final Function dispatch;

  const _Presenter({Key key, this.board, this.boardSize, this.dispatch}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  TextEditingController _nameCtrl;
  String _name;

  @override
  initState() {
    super.initState();
    _nameCtrl = TextEditingController.fromValue(TextEditingValue(text: widget.board.name));
    _name = widget.board.name;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
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
            nameField(),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            deleteButton(),
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

  Widget nameField() {
    return Container(
      width: 300.0,
      child: TextField(
        autofocus: true,
        controller: _nameCtrl,
        style: TextStyle(fontSize: 36.0),
        onChanged: (text) => setState(() => _name = text),
        onSubmitted: (text) => submit(),
        maxLines: null,
        decoration: InputDecoration(
          hintText: 'New collection',
          hintStyle: TextStyle(color: Themer().hintTextColor()),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }

  void showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Confirm(
          title: 'Delete Collection',
          description: 'This collection will be lost forever.',
          action: 'Delete',
          onTap: () {
            widget.dispatch(DeleteBoard(widget.board));
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Widget deleteButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: showDeleteDialog,
          child: Container(
              margin: EdgeInsets.only(top: 30.0, bottom: 30.0, left: 20.0),
              child: Icon(Icons.delete_outline, color: Themer().hintTextColor())),
        ),
      ],
    );
  }

  Widget button() {
    var color = _name == '' ? Themer().lightGrey() : Themer().primaryTextColor();
    return Padding(
        padding: EdgeInsets.only(bottom: 20.0),
        child: BurntButton(text: 'Save', onTap: submit, color: color));
  }

  void submit() {
    if (_name != '') {
      widget.dispatch(UpdateBoard(widget.board.copyWith(name: _name)));
      Navigator.of(context).pop();
    }
  }
}

class _Props {
  final int boardSize;
  final Function dispatch;

  _Props({
    this.boardSize,
    this.dispatch,
  });

  static fromStore(Store<AppState> store) {
    return _Props(
      boardSize: store.state.todo.boards.length,
      dispatch: (action) => store.dispatch(action),
    );
  }
}
