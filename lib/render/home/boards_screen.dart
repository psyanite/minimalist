import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:minimalist/models/board.dart';
import 'package:minimalist/render/components/common/main_navigator.dart';
import 'package:minimalist/render/components/common/reorderable_listy.dart';
import 'package:minimalist/render/home/add_board_screen.dart';
import 'package:minimalist/render/home/config_board_screen.dart';
import 'package:minimalist/render/presentation/themer.dart';
import 'package:minimalist/state/app/app_state.dart';
import 'package:minimalist/state/me/todos/todo_actions.dart';
import 'package:redux/redux.dart';

class BoardsScreen extends StatelessWidget {

  const BoardsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
      converter: (Store<AppState> store) => _Props.fromStore(store),
      builder: (BuildContext context, _Props props) {
        return _Presenter(
          boards: props.boards,
          dispatch: props.dispatch,
        );
      },
    );
  }
}

class _Presenter extends StatefulWidget {
  final List<Board> boards;
  final Function dispatch;

  _Presenter({Key key, this.boards, this.dispatch}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  ScrollController _scrollie = ScrollController();

  @override
  dispose() {
    _scrollie.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(height: 50.0),
              title(),
              Container(height: 20.0),
              Flexible(child: boards()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottom(),
    );
  }

  Widget title() {
    return Container(
      height: 30.0,
      child: Text('Collections', style: Themer().listNameTitleStyle()),
    );
  }

  Widget boards() {
    var children = widget.boards
        .map((board) => Container(key: ValueKey(board), child: boardCard(board)));

    return ReorderableListyView(
      scrollController: _scrollie,
      children: List<Widget>.from(children),
      columnMainAxisAlignment: MainAxisAlignment.center,
      onReorder: (int oldIndex, int newIndex) {
        widget.dispatch(ReorderBoard(oldIndex, newIndex));
      },
    );
  }

  Widget boardCard(Board board) {
    return InkWell(
      onTap: () {
        widget.dispatch(SetCurBoard(board.id));
        Navigator.push(context, MaterialPageRoute(builder: (_) => MainNavigator(board.id)));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(top: 12.0, bottom: 12.0, left: 70.0),
            child: Text(board.name, textAlign: TextAlign.center, style: TextStyle(fontSize: 25.0, color: Themer().textBodyColor())),
          ),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ConfigBoardScreen(board)));
            },
            child: Container(
                margin: EdgeInsets.only(top: 30.0, bottom: 20.0, left: 20.0, right: 70.0),
                child: Icon(Icons.more_vert, color: Themer().hintTextColor())),
          )
        ],
      ),
    );
  }

  Widget bottom() {
    return Container(
      height: 120.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          addButton(),
          Container(),
        ],
      ),
    );
  }

  Widget addButton() {
    return InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Container(
          height: 120,
          padding: EdgeInsets.only(top: 35.0, bottom: 35.0),
          child: Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                border: Border.all(color: Themer().ringColor(), width: 3.0),
              ),
              child: Container()),
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => AddBoardScreen()));
        });
  }
}

class _Props {
  final List<Board> boards;
  final Function dispatch;

  _Props({
    this.boards,
    this.dispatch,
  });

  static fromStore(Store<AppState> store) {
    return _Props(
      boards: store.state.todo.boards.values.toList(),
      dispatch: (action) => store.dispatch(action),
    );
  }
}
