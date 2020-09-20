import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:minimalist/render/components/common/components.dart';
import 'package:minimalist/render/presentation/themer.dart';
import 'package:minimalist/state/app/app_state.dart';
import 'package:minimalist/state/settings/settings_actions.dart';
import 'package:minimalist/state/settings/settings_state.dart';
import 'package:redux/redux.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
      converter: _Props.fromStore,
      builder: (BuildContext context, _Props props) {
        return _Presenter(
          currentTheme: props.currentTheme,
          currentFont: props.currentFont,
          currentAlign: props.currentAlign,
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
  final Function dispatch;

  _Presenter({Key key, this.currentTheme, this.currentFont, this.currentAlign, this.dispatch}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  @override
  Widget build(BuildContext context) {
    var slivers = <Widget>[
      _appBar(),
      _controls(),
    ];
    return Scaffold(body: CustomScrollView(slivers: slivers));
  }

  Widget _appBar() {
    return SliverSafeArea(
      sliver: SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 35.0, bottom: 20.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            Stack(
              children: <Widget>[
                Container(width: 50.0, height: 60.0),
                Positioned(left: -12.0, child: BackArrow(color: Themer().lightGrey())),
              ],
            ),
            Text('CUSTOMISE', style: Themer().appBarTitleStyle())
          ]),
        ),
      ),
    );
  }

  Widget _controls() {
    var controlOptions = [
      _themeControl(),
      _fontControl(),
      _textAlignControl(),
    ];

    return SliverToBoxAdapter(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) => controlOptions[index],
        separatorBuilder: (context, index) => Divider(height: 1.0, color: Themer().separatorBlue()),
        itemCount: controlOptions.length,
      ),
    ));
  }

  Widget _themeControl() {
    var dispatch = (value) => widget.dispatch(SetThemeChoice(value));
    var options = [
      _SettingOption(ThemeChoice.cyan, 'Color Scheme', 'Changes accent colors', 'Cyan', dispatch, color: Colors.cyan),
      _SettingOption(ThemeChoice.blue, 'Color Scheme', 'Changes accent colors', 'Blue', dispatch, color: Colors.blue),
      _SettingOption(ThemeChoice.indigo, 'Color Scheme', 'Changes accent colors', 'Indigo', dispatch, color: Colors.indigo),
      _SettingOption(ThemeChoice.blueGrey, 'Color Scheme', 'Changes accent colors', 'Blue Grey', dispatch, color: Colors.blueGrey),
      _SettingOption(ThemeChoice.grey, 'Color Scheme', 'Changes accent colors', 'Grey', dispatch, color: Colors.grey),
    ];
    var selected = options.indexWhere((o) => o.value == widget.currentTheme);
    return _SettingControl(options: options, selected: selected);
  }

  Widget _fontControl() {
    var dispatch = (value) => widget.dispatch(SetFontChoice(value));
    var options = [
      _SettingOption(FontChoice.ptSans, 'Font', 'Changes font', 'PT Sans', dispatch),
      _SettingOption(FontChoice.productSans, 'Font', 'Changes font', 'Product Sans', dispatch),
    ];
    var selected = options.indexWhere((o) => o.value == widget.currentFont);
    return _SettingControl(options: options, selected: selected);
  }

  Widget _textAlignControl() {
    var dispatch = (value) => widget.dispatch(SetContentAlign(value));
    var options = [
      _SettingOption(ContentAlign.left, 'Content Align', 'Aligns text and titles', 'Left', dispatch),
      _SettingOption(ContentAlign.right, 'Content Align', 'Aligns text and titles', 'Right', dispatch),
      _SettingOption(ContentAlign.center, 'Content Align', 'Aligns text and titles', 'Center', dispatch),
    ];
    var selected = options.indexWhere((o) => o.value == widget.currentAlign);
    return _SettingControl(options: options, selected: selected);
  }
}

class _SettingOption {
  final dynamic value;
  final String title;
  final String desc;
  final String name;
  final Function dispatch;
  final Color color;

  _SettingOption(this.value, this.title, this.desc, this.name, this.dispatch, {this.color});

  onSelect() => dispatch(value);
}

class _SettingControl extends StatelessWidget {
  final List<_SettingOption> options;
  final int selected;

  const _SettingControl({Key key, this.options, this.selected}) : super(key: key);

  _SettingOption _selectedOption() => options[selected];

  @override
  Widget build(BuildContext context) {
    var selectedOption = _selectedOption();
    return InkWell(
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

  Widget _option(BuildContext context, _SettingOption option) {
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
  final Function dispatch;

  _Props({this.currentTheme, this.currentFont, this.currentAlign, this.dispatch});

  static _Props fromStore(Store<AppState> store) {
    return _Props(
      dispatch: (action) => store.dispatch(action),
      currentTheme: store.state.settings.themeChoice,
      currentFont: store.state.settings.fontChoice,
      currentAlign: store.state.settings.contentAlign,
    );
  }
}
