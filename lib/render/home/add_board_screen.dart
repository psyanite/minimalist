import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:minimalist/render/components/common/components.dart';
import 'package:minimalist/render/presentation/themer.dart';
import 'package:minimalist/state/app/app_state.dart';
import 'package:minimalist/state/me/todos/todo_actions.dart';
import 'package:redux/redux.dart';

class AddBoardScreen extends StatelessWidget {

  const AddBoardScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
      converter: (Store<AppState> store) => _Props.fromStore(store),
      builder: (BuildContext context, _Props props) {
        return _Presenter(
          dispatch: props.dispatch,
        );
      },
    );
  }
}

class _Presenter extends StatefulWidget {
  final Function dispatch;

  const _Presenter({Key key, this.dispatch}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  TextEditingController _nameCtrl = TextEditingController();
  String _name;

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

  Widget button() {
    var color = _name == '' ? Themer().lightGrey() : Themer().primaryTextColor();
    return Padding(
        padding: EdgeInsets.only(bottom: 20.0),
        child: BurntButton(text: 'Save', onTap: submit, color: color));
  }

  void submit() {
    if (_name != '') {
      widget.dispatch(CreateNewBoard(_name));
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
