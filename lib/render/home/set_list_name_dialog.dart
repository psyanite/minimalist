import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:minimalist/render/components/common/components.dart';
import 'package:minimalist/render/presentation/themer.dart';
import 'package:minimalist/state/app/app_state.dart';
import 'package:minimalist/state/me/todos/todo_actions.dart';
import 'package:redux/redux.dart';

class SetListNameDialog extends StatelessWidget {
  final int listId;

  const SetListNameDialog(this.listId, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Function>(
      converter: (Store<AppState> store) {
        return (name) => store.dispatch(SetTodoListName(listId, name));
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
            _nameField(),
          ]),
        ),
        Container(height: 10.0),
        buttons(),
      ],
    );
  }

  Widget _nameField() {
    return Container(
      width: 300.0,
      child: TextField(
        style: TextStyle(fontSize: 18.0),
        autofocus: true,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        onChanged: (text) => setState(() => _name = text),
        decoration: InputDecoration(
          hintText: 'New name',
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
        child: Text('Save', style: TextStyle(fontWeight: Themer().fontBold(), color: Themer().primaryTextColor())),
      ),
    );
  }

  Widget buttons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.end,  children: [
        okButton(),
      ]),
    );
  }

  void submit(BuildContext context) {
    widget.setListName(_name ?? '');
    Navigator.of(context).pop();
  }
}
