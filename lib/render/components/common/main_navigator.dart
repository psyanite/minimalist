import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:minimalist/models/todo_list.dart';
import 'package:minimalist/render/home/todos_screen.dart';
import 'package:minimalist/services/navi.dart';
import 'package:minimalist/state/app/app_state.dart';
import 'package:redux/redux.dart';

class MainNavigator extends StatelessWidget {
  MainNavigator({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
      converter: (Store<AppState> store) => _Props.fromStore(store),
      builder: (BuildContext context, _Props props) {
        return _Presenter(
          lists: props.lists,
          dispatch: props.dispatch,
        );
      },
    );
  }
}

class _Presenter extends StatefulWidget {
  final LinkedHashMap<int, TodoList> lists;
  final Function dispatch;

  _Presenter({Key key, this.lists, this.dispatch}) : super(key: key);

  @override
  MainNavigatorState createState() => MainNavigatorState();
}

class MainNavigatorState extends State<_Presenter> {
  PageController _ctrl = PageController();
  Queue<int> _history;
  bool _lastActionWasGo;
  int _currentIndex = 0;

  @override
  initState() {
    super.initState();
    _history = Queue<int>();
    _history.addLast(0);

    Navi(mainNav: this);
  }

  @override
  dispose() {
    _ctrl.dispose();
    _ctrl = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: PageView(
          controller: _ctrl,
          physics: AlwaysScrollableScrollPhysics(),
          onPageChanged: _onPageChanged,
          children: widget.lists.keys.map((id) => TodosScreen(id)).toList(),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() {
    if (_history.length == 0) {
      return Future(() => true);
    } else {
      var history = Queue<int>.from(_history);
      if (_lastActionWasGo) history.removeLast();
      var previousPage = history.removeLast();
      setState(() {
        _history = history;
        _lastActionWasGo = false;
      });
      _ctrl.jumpToPage(previousPage);
      return Future(() => false);
    }
  }

  _onPageChanged(int index) {
    setState(() => _currentIndex = index);
  }

  jumpToPage(int index) {
    if (_currentIndex == index) return;
    var history = Queue<int>.from(_history);
    history.addLast(index);
    setState(() {
      _history = history;
      _lastActionWasGo = true;
    });
    _ctrl.jumpToPage(index);
  }

}

class _Props {
  final LinkedHashMap<int, TodoList> lists;
  final Function dispatch;

  _Props({
    this.lists,
    this.dispatch,
  });

  static fromStore(Store<AppState> store) {
    return _Props(
      lists: store.state.todo.lists,
      dispatch: (action) => store.dispatch(action),
    );
  }
}
