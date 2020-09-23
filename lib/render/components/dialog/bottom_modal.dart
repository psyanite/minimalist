import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minimalist/render/presentation/themer.dart';

class BottomModal extends StatelessWidget {
  final String title;
  final String desc;
  final List<Widget> options;
  final bool showCancel;

  const BottomModal({Key key, this.title, this.desc, this.options, this.showCancel = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets,
      duration: Duration(milliseconds: 100),
      curve: Curves.ease,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(height: 5.0),
            if (title != null) Text(title, style: TextStyle(fontSize: 22.0, fontWeight: Themer().fontBold())),
            if (desc != null) Container(height: 10.0),
            if (desc != null) Text(desc),
            if (title != null || desc != null) Container(height: 15.0),
            if (options != null) ...options,
            Container(height: 20.0),
            if (showCancel)
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  child: Text('Cancel', style: TextStyle(color: Themer().hintTextColor())),
                  padding: EdgeInsets.only(bottom: 10.0),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
