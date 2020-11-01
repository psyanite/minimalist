import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AsyncButton extends StatefulWidget {
  final Widget child;
  final Function onTap;

  AsyncButton({Key key, this.child, this.onTap}) : super(key: key);

    @override
    _AsyncButtonState createState() => _AsyncButtonState();
}

class _AsyncButtonState extends State<AsyncButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _doMagic,
      child: _content(),
    );
  }

  Widget _content() {
    if (isLoading) {
      return Container(
        width: 25.0,
        height: 25.0,
        child: CircularProgressIndicator(strokeWidth: 3.0, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
      );
    } else {
      return widget.child;
    }
  }

  _doMagic() async {
    setState(() {
      isLoading = true;
    });
    await widget.onTap();
    setState(() {
      isLoading = false;
    });
  }
}
