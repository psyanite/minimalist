import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minimalist/render/components/dialog/multi_select_dialog.dart';
import 'package:minimalist/render/presentation/themer.dart';

class BottomModal extends StatelessWidget {
  final List<Widget> options;

  const BottomModal(this.options, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 5.0),
          Container(
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) => options[index],
              separatorBuilder: (context, index) => Divider(height: 1.0, color: Themer().separatorBlue()),
              itemCount: options.length,
            ),
          ),
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text('Cancel', textAlign: TextAlign.center, style: TextStyle(color: Themer().hintTextColor())),
                  padding: EdgeInsets.only(top: 20.0, bottom: 30.0),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BottomModalOption extends StatelessWidget {
  final MultiSelectDialogOption option;

  const BottomModalOption(this.option, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return InkWell(
        splashColor: Themer().splashPrimary(),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          height: 40.0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(option.title, style: TextStyle(color: Themer().anchorColor())),
            ],
          ),
        ),
        onTap: () => option.onTap(),
      );
    });
  }
}
