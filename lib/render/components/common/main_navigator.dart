import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:minimalist/models/todo_list.dart';
import 'package:minimalist/render/home/todos_screen.dart';
import 'package:minimalist/render/presentation/themer.dart';
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

class MainNavigatorState extends State<_Presenter> with WidgetsBindingObserver {
  PageController _ctrl = PageController();
  Queue<int> _history;
  bool _lastActionWasGo;
  int _currentIndex = 0;

  @override
  initState() {
    super.initState();
    _history = Queue<int>();
    _history.addLast(0);

    WidgetsBinding.instance.addObserver(this);

    Future.delayed(Duration.zero, () async {
      var brightness;
      if (Themer().darkModeChoice() == DarkModeChoice.auto) {
        brightness = MediaQuery.of(context).platformBrightness;
      } else if (Themer().darkModeChoice() == DarkModeChoice.always) {
        brightness = Brightness.dark;
      } else {
        brightness = Brightness.light;
      }
      Themer().setTheme(context, brightness);
    });

    Navi(mainNav: this);
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ctrl.dispose();
    _ctrl = null;
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    if (Themer().darkModeChoice() == DarkModeChoice.auto) {
      var brightness = MediaQuery.of(context).platformBrightness == Brightness.dark ? Brightness.light : Brightness.dark;
      Themer().setTheme(context, brightness);
    }
    super.didChangePlatformBrightness();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: PageView(
          controller: _ctrl,
          physics: BouncingScrollPhysics(),
          onPageChanged: _onPageChange,
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

  _onPageChange(int index) {
    var history = Queue<int>.from(_history);
    history.addLast(index);
    setState(() {
      _currentIndex = index;
      _history = history;
      _lastActionWasGo = true;
    });
  }

  jumpToPage(int index) {
    if (_currentIndex == index) return;
    _ctrl.animateToPage(
      index,
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
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
