import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:minimalist/render/presentation/themer.dart';
import 'package:minimalist/state/app/app_state.dart';
import 'package:redux/redux.dart';

class Clap extends StatelessWidget {
  final int todoListId;
  final Color color;

  Clap(this.todoListId, this.color, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
      converter: (Store<AppState> store) => _Props.fromStore(store, todoListId),
      builder: (BuildContext context, _Props props) {
        return _Presenter(
          color: color,
          count: props.count,
        );
      },
    );
  }
}

class _Presenter extends StatefulWidget {
  final Color color;
  final int count;

  _Presenter({Key key, this.color, this.count}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> with TickerProviderStateMixin {
  double _sparklesAngle = 0.0;
  ScoreWidgetStatus _scoreWidgetStatus = ScoreWidgetStatus.HIDDEN;
  final duration = Duration(milliseconds: 400);
  Random random;
  Timer holdTimer, scoreOutETA;
  AnimationController scoreInAnimationController,
      scoreOutAnimationController,
      scoreSizeAnimationController,
      sparklesAnimationController;
  Animation scoreOutPositionAnimation, sparklesAnimation;

  @override
  initState() {
    super.initState();
    random = Random();
    scoreInAnimationController = AnimationController(duration: Duration(milliseconds: 150), vsync: this);
    scoreInAnimationController.addListener(() {
      setState(() {}); // Calls render function
    });

    scoreOutAnimationController = AnimationController(vsync: this, duration: duration);
    scoreOutPositionAnimation = Tween(begin: 100.0, end: 150.0)
        .animate(CurvedAnimation(parent: scoreOutAnimationController, curve: Curves.easeOut));
    scoreOutPositionAnimation.addListener(() {
      setState(() {});
    });
    scoreOutAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _scoreWidgetStatus = ScoreWidgetStatus.HIDDEN;
      }
    });

    scoreSizeAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    scoreSizeAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        scoreSizeAnimationController.reverse();
      }
    });
    scoreSizeAnimationController.addListener(() {
      setState(() {});
    });

    sparklesAnimationController = AnimationController(vsync: this, duration: duration);
    sparklesAnimation = CurvedAnimation(parent: sparklesAnimationController, curve: Curves.easeIn);
    sparklesAnimation.addListener(() {
      setState(() {});
    });
  }

  @override
  dispose() {
    super.dispose();
    scoreInAnimationController.dispose();
    scoreOutAnimationController.dispose();
  }

  @override
  void didUpdateWidget(_Presenter old) {
    if (old.count < widget.count) {
      if (scoreOutETA != null) {
        scoreOutETA.cancel();
      }
      if (_scoreWidgetStatus == ScoreWidgetStatus.BECOMING_INVISIBLE) {
        scoreOutAnimationController.stop(canceled: true);
        _scoreWidgetStatus = ScoreWidgetStatus.VISIBLE;
      } else if (_scoreWidgetStatus == ScoreWidgetStatus.HIDDEN) {
        _scoreWidgetStatus = ScoreWidgetStatus.BECOMING_VISIBLE;
        scoreInAnimationController.forward(from: 0.0);
      }
      increment(null); // Take care of tap
    }
    super.didUpdateWidget(old);
  }

  void increment(Timer t) {
    scoreSizeAnimationController.forward(from: 0.0);
    sparklesAnimationController.forward(from: 0.0);
    setState(() {
      _sparklesAngle = random.nextDouble() * (2 * pi);
    });
  }

  void onTapDown(TapDownDetails tap) {
    // User pressed the button. This can be a tap or a hold.
    if (scoreOutETA != null) {
      scoreOutETA.cancel(); // We do not want the score to vanish!
    }
    if (_scoreWidgetStatus == ScoreWidgetStatus.BECOMING_INVISIBLE) {
      // We tapped down while the widget was flying up. Need to cancel that animation.
      scoreOutAnimationController.stop(canceled: true);
      _scoreWidgetStatus = ScoreWidgetStatus.VISIBLE;
    } else if (_scoreWidgetStatus == ScoreWidgetStatus.HIDDEN) {
      _scoreWidgetStatus = ScoreWidgetStatus.BECOMING_VISIBLE;
      scoreInAnimationController.forward(from: 0.0);
    }
    increment(null); // Take care of tap
  }

  @override
  Widget build(BuildContext context) {
    var extraSize = 0.0;
    if (_scoreWidgetStatus == ScoreWidgetStatus.BECOMING_VISIBLE || _scoreWidgetStatus == ScoreWidgetStatus.VISIBLE) {
      extraSize = scoreSizeAnimationController.value * 7;
    }

    var stackChildren = <Widget>[];

    var firstAngle = _sparklesAngle;
    var sparkleRadius = (sparklesAnimationController.value * 50);
    var sparklesOpacity = (1 - sparklesAnimation.value);

    for (int i = 0; i < 5; ++i) {
      var currentAngle = (firstAngle + ((2 * pi) / 5) * (i));
      var sparklesWidget = Positioned(
        child: Transform.rotate(
            angle: currentAngle - pi / 2,
            child: Opacity(
                opacity: sparklesOpacity,
                child: Image.asset(
                  "assets/images/sparkles.png",
                  width: 14.0,
                  height: 14.0,
                ))),
        left: (sparkleRadius * cos(currentAngle)) + 20,
        top: (sparkleRadius * sin(currentAngle)) + 20,
      );
      stackChildren.add(sparklesWidget);
    }

    var textColor = Themer().brightness() == Brightness.dark
      ? Color(0xBBFFFFFF) : Colors.white;

    stackChildren.add(Container(
        height: 30.0 + extraSize,
        width: 50.0 + extraSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.0),
          color: widget.color,
        ),
        child: Center(
            child: Text(
          "+ " + widget.count.toString(),
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 22.0, letterSpacing: -1.0),
        ))));

    return Container(
      height: 60.0,
      child: Stack(
        alignment: FractionalOffset.center,
        overflow: Overflow.visible,
        children: stackChildren,
      ),
    );
  }
}

class _Props {
  final int count;

  _Props({
    this.count,
  });

  static fromStore(Store<AppState> store, int listId) {
    return _Props(
      count: store.state.todo.lists[listId].completedCount,
    );
  }
}

enum ScoreWidgetStatus { HIDDEN, BECOMING_VISIBLE, VISIBLE, BECOMING_INVISIBLE }
