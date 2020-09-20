import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minimalist/render/presentation/themer.dart';

class RingButton extends StatefulWidget {
  final Function onTap;
  final double size;
  final double ringWidth;

  RingButton({Key key, this.onTap, this.size = 50.0, this.ringWidth = 5.0}) : super(key: key);

  @override
  _RingButtonState createState() => _RingButtonState();
}

class _RingButtonState extends State<RingButton> with SingleTickerProviderStateMixin {
  AnimationController _ctrl;
  Animation _colorTween;

  @override
  void initState() {
    _ctrl = AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    _colorTween = ColorTween(begin: Themer().ringColor(), end: Themer().splashPrimary()).animate(_ctrl);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _ctrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorTween,
      builder: (context, child) {
        return InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.size),
                border: Border.all(color: _colorTween.value, width: widget.ringWidth),
              ),
              child: Container()),
          onTap: () {
            _ctrl.forward().whenComplete(() => _ctrl.reverse());
            widget.onTap();
          }

        );
      },
    );
  }
}
