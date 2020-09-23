import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minimalist/render/presentation/themer.dart';

class MultiSelectDialogOption {
  final String title;
  final Function onTap;

  MultiSelectDialogOption({this.title, this.onTap});
}

class MultiSelectDialog extends StatelessWidget {
  final String title;
  final String desc;
  final List<MultiSelectDialogOption> options;

  const MultiSelectDialog({Key key, this.title, this.desc, this.options}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 5.0),
          if (title != null) Text(title, style: TextStyle(fontSize: 22.0, fontWeight: Themer().fontBold())),
          if (desc != null) Container(height: 10.0),
          if (desc != null) Text(desc),
          if (title != null || desc != null) Container(height: 15.0),
          Container(
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) => _option(options[index]),
              separatorBuilder: (context, index) => Divider(height: 1.0, color: Themer().separatorBlue()),
              itemCount: options.length,
            ),
          ),
          Container(height: 20.0),
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              child: Text('Cancel', style: TextStyle(color: Themer().hintTextColor())),
              padding: EdgeInsets.only(bottom: 10.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _option(MultiSelectDialogOption option) {
    return Builder(
        builder: (context) {
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
          onTap: () {
            option.onTap();
            Navigator.of(context).pop();
          },
        );
      }
    );
  }

}

