import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minimalist/render/components/dialog/dialog.dart';
import 'package:minimalist/render/presentation/themer.dart';

class Confirm extends StatefulWidget {
  final String title;
  final String description;
  final String action;
  final Function onTap;

  Confirm({Key key, this.title, this.description, this.action, this.onTap}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<Confirm> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var content = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(height: 10.0),
        Column(children: <Widget>[
          Text(widget.title, style: TextStyle(fontSize: 18.0, fontWeight: Themer().fontBold())),
          if (widget.description != null) _description(),
        ]),
        Container(height: 10.0),
        _options(context),
      ],
    );
    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      content: Container(
        width: 100,
        child: content,
      ),
    );
  }

  Widget _description() {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      width: 200.0,
      child: Text(widget.description, textAlign: TextAlign.center, style: TextStyle(color: Themer().hintTextColor(), fontSize: 14.0)),
    );
  }

  Widget _options(context) {
    var options = <Widget>[
      isLoading
          ? Container(
              height: 40.0,
              padding: EdgeInsets.only(top: 12.0, bottom: 13.0),
              child: Container(
                width: 15.0,
                height: 15.0,
                child: CircularProgressIndicator(strokeWidth: 3.0, valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlue)),
              ),
            )
          : _option(DialogOption(
              display: widget.action,
              onTap: doMagic,
              style: TextStyle(color: Themer().anchorColor(), fontSize: 16.0, fontWeight: Themer().fontBold()))),
      _option(DialogOption(display: 'Cancel', onTap: () => Navigator.of(context, rootNavigator: true).pop(true), style: TextStyle(fontSize: 16.0))),
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.from(options.map((o) {
        return Column(children: <Widget>[Divider(color: Color(0x16007AFF)), o]);
      })),
    );
  }

  Widget _option(DialogOption option) {
    return InkWell(
      onTap: option.onTap,
      child: Container(
        height: 40.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[Text(option.display, style: option.style)],
        ),
      ),
    );
  }

  doMagic() async {
    setState(() {
      isLoading = true;
    });
    await widget.onTap();
    setState(() {
      isLoading = false;
    });
  }
}
