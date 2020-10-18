import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:minimalist/render/components/common/components.dart';
import 'package:minimalist/render/presentation/themer.dart';
import 'package:minimalist/state/app/app_state.dart';
import 'package:minimalist/state/settings/settings_actions.dart';
import 'package:minimalist/state/settings/settings_state.dart';
import 'package:redux/redux.dart';

class ThemeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
      converter: _Props.fromStore,
      builder: (BuildContext context, _Props props) {
        return _Presenter(
          currentTheme: props.currentTheme,
          currentFont: props.currentFont,
          currentAlign: props.currentAlign,
          currentVerticalAlign: props.currentVerticalAlign,
          dispatch: props.dispatch,
        );
      },
    );
  }
}

class _Presenter extends StatefulWidget {
  final ThemeChoice currentTheme;
  final FontChoice currentFont;
  final ContentAlign currentAlign;
  final VerticalContentAlign currentVerticalAlign;
  final Function dispatch;

  _Presenter(
      {Key key, this.currentTheme, this.currentFont, this.currentAlign, this.currentVerticalAlign, this.dispatch})
      : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  @override
  Widget build(BuildContext context) {
    var slivers = <Widget>[
      HeaderSliver(title: 'THEME'),
      _controls(),
    ];
    return Scaffold(body: CustomScrollView(slivers: slivers, physics: BouncingScrollPhysics()));
  }

  Widget _controls() {
    var controlOptions = [
      _fontControl(),
      _verticalTextAlignControl(),
    ];

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50.0),
        child: ListView.separated(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) => controlOptions[index],
          separatorBuilder: (context, index) => Divider(height: 1.0, color: Themer().separatorBlue()),
          itemCount: controlOptions.length,
        ),
      ),
    );
  }

  Widget _fontControl() {
    var dispatch = (value) {
      Themer().setChosenFont(value);
      Themer().updateTheme(context);
      widget.dispatch(SetFontChoice(value));
    };
    var options = [
      SettingOption(FontChoice.ptSans, 'Font', 'Changes font', 'PT Sans', dispatch),
      SettingOption(FontChoice.productSans, 'Font', 'Changes font', 'Product Sans', dispatch),
    ];
    var selected = options.indexWhere((o) => o.value == widget.currentFont);
    return _SettingControl(options: options, selected: selected);
  }

  Widget _verticalTextAlignControl() {
    var dispatch = (value) {
      Themer().setVerticalContentAlign(value);
      Themer().updateTheme(context);
      widget.dispatch(SetVerticalContentAlign(value));
    };
    var options = [
      SettingOption(VerticalContentAlign.top, 'Vertical Content Align', 'Aligns todo items', 'Top', dispatch),
      SettingOption(VerticalContentAlign.center, 'Vertical Content Align', 'Aligns todo items', 'Center', dispatch),
      SettingOption(VerticalContentAlign.bottom, 'Vertical Content Align', 'Aligns todo items', 'Bottom', dispatch),
    ];
    var selected = options.indexWhere((o) => o.value == widget.currentVerticalAlign);
    return _SettingControl(options: options, selected: selected);
  }
}

class SettingOption {
  final dynamic value;
  final String title;
  final String desc;
  final String name;
  final Function dispatch;
  final Color color;

  SettingOption(this.value, this.title, this.desc, this.name, this.dispatch, {this.color});

  onSelect() => dispatch(value);
}

class _SettingControl extends StatelessWidget {
  final List<SettingOption> options;
  final int selected;

  const _SettingControl({Key key, this.options, this.selected}) : super(key: key);

  SettingOption _selectedOption() => options[selected];

  @override
  Widget build(BuildContext context) {
    var selectedOption = _selectedOption();
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => _showBottomSheet(context),
      child: Container(
        padding: EdgeInsets.only(right: 20.0, top: 30.0, bottom: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(selectedOption.title, style: TextStyle(fontSize: 22.0, fontWeight: Themer().fontBold())),
            Text(selectedOption.name, style: TextStyle(fontSize: 20.0)),
          ],
        ),
      ),
    );
  }

  Widget _option(BuildContext context, SettingOption option) {
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
            Text(option.name, style: TextStyle(color: Themer().anchorColor())),
            if (option.color != null)
              Container(
                padding: EdgeInsets.only(left: 8.0),
                child: Container(
                  height: 20.0,
                  width: 20.0,
                  decoration: BoxDecoration(color: option.color, borderRadius: BorderRadius.circular(20.0)),
                ),
              )
          ],
        ),
      ),
      onTap: () {
        option.dispatch(option.value);
        Navigator.of(context).pop();
      },
    );
  }

  _showBottomSheet(BuildContext context) {
    var selectedOption = _selectedOption();
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(height: 5.0),
              Text(selectedOption.title, style: TextStyle(fontSize: 22.0, fontWeight: Themer().fontBold())),
              Container(height: 10.0),
              Text(selectedOption.desc),
              Container(height: 15.0),
              Container(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) => _option(context, options[index]),
                  separatorBuilder: (context, index) => Divider(height: 1.0, color: Themer().separatorBlue()),
                  itemCount: options.length,
                ),
              ),
              Container(height: 20.0),
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                    child: Text('Cancel', style: TextStyle(color: Themer().hintTextColor())),
                    padding: EdgeInsets.only(bottom: 10.0)),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Props {
  final ThemeChoice currentTheme;
  final FontChoice currentFont;
  final ContentAlign currentAlign;
  final VerticalContentAlign currentVerticalAlign;
  final Function dispatch;

  _Props({this.currentTheme, this.currentFont, this.currentAlign, this.currentVerticalAlign, this.dispatch});

  static _Props fromStore(Store<AppState> store) {
    return _Props(
      dispatch: (action) => store.dispatch(action),
      currentTheme: ThemeChoice.blue,
      currentFont: store.state.settings.fontChoice,
      currentAlign: ContentAlign.left,
      currentVerticalAlign: store.state.settings.verticalContentAlign,
    );
  }
}
