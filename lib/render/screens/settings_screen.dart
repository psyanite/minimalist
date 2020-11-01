import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:minimalist/render/components/common/components.dart';
import 'package:minimalist/render/presentation/themer.dart';
import 'package:minimalist/render/screens/about_screen.dart';
import 'package:minimalist/render/screens/account_screen.dart';
import 'package:minimalist/render/screens/login_screen.dart';
import 'package:minimalist/services/auth_service.dart';
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
          darkModeChoice: props.darkModeChoice,
          currentTheme: props.currentTheme,
          currentFont: props.currentFont,
          currentAlign: props.currentAlign,
          currentVerticalAlign: props.currentVerticalAlign,
          autoDeleteDoneItems: props.autoDeleteDoneItems,
          moveDoneItemsToTheBottom: props.moveDoneItemsToTheBottom,
          dispatch: props.dispatch,
        );
      },
    );
  }
}

class _Presenter extends StatefulWidget {
  final DarkModeChoice darkModeChoice;
  final ThemeChoice currentTheme;
  final FontChoice currentFont;
  final ContentAlign currentAlign;
  final VerticalContentAlign currentVerticalAlign;
  final bool autoDeleteDoneItems;
  final bool moveDoneItemsToTheBottom;
  final Function dispatch;

  _Presenter(
      {Key key,
      this.darkModeChoice,
      this.currentTheme,
      this.currentFont,
      this.currentAlign,
      this.currentVerticalAlign,
      this.autoDeleteDoneItems,
      this.moveDoneItemsToTheBottom,
      this.dispatch})
      : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(builder: (BuildContext context) {
      return CustomScrollView(slivers: [
        HeaderSliver(title: 'SETTINGS'),
        if (AuthService().getUser() == null) backupButton(context),
        controls(),
        moreSettings(context),
      ], physics: BouncingScrollPhysics());
    }));
  }

  Widget backupButton(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(left: 50.0, right: 50.0, top: 20.0, bottom: 10.0),
        child: BottomButton(text: 'Backup Data', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()))),
      ),
    );
  }

  Widget moreSettings(BuildContext context) {
    var items = [
      AuthService().getUser() != null
          ? page('Account', () => Navigator.push(context, MaterialPageRoute(builder: (_) => AccountScreen())))
          : page('Login', () => Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()))),
      page('About Us', () => Navigator.push(context, MaterialPageRoute(builder: (_) => AboutScreen()))),
    ];

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(left: 50.0, right: 50.0, top: 20.0, bottom: 100.0),
        child: ListView.separated(
          padding: EdgeInsets.all(0),
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) => items[index],
          separatorBuilder: (context, index) => Divider(height: 1.0, color: Themer().separator()),
          itemCount: items.length,
        ),
      ),
    );
  }

  Widget page(String title, Function onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: Text(
          title,
          style: TextStyle(fontSize: 22.0, fontWeight: Themer().fontBold()),
        ),
      ),
    );
  }

  Widget controls() {
    var controlOptions = [
      darkModeControl(),
      fontControl(),
      verticalTextAlignControl(),
      autoDeleteDoneItemsControl(),
      moveDoneItemsToTheBottom(),
    ];

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50.0),
        child: ListView.separated(
          padding: EdgeInsets.only(top: 30.0),
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) => controlOptions[index],
          separatorBuilder: (context, index) => Divider(height: 1.0, color: Themer().separator()),
          itemCount: controlOptions.length,
        ),
      ),
    );
  }

  Widget darkModeControl() {
    var dispatch = (value) {
      Themer().setDarkModeChoice(value);
      var brightness;
      if (Themer().darkModeChoice() == DarkModeChoice.auto) {
        brightness = MediaQuery.of(context).platformBrightness;
      } else if (Themer().darkModeChoice() == DarkModeChoice.always) {
        brightness = Brightness.dark;
      } else {
        brightness = Brightness.light;
      }
      Themer().setTheme(context, brightness);

      widget.dispatch(SetDarkModeChoice(value));
    };
    var options = [
      SettingOption(DarkModeChoice.auto, 'Dark Mode', null, 'Automatically enable when dark mode on this device is enabled', dispatch),
      SettingOption(DarkModeChoice.always, 'Dark Mode', null, 'Always use dark mode', dispatch),
      SettingOption(DarkModeChoice.never, 'Dark Mode', null, 'Never use dark mode', dispatch),
    ];
    var selected = options.indexWhere((o) => o.value == widget.darkModeChoice);
    return _SettingControl(options: options, selected: selected);
  }

  Widget fontControl() {
    var dispatch = (value) {
      Themer().setChosenFont(value);
      Themer().setTheme(context, Themer().brightness());
      widget.dispatch(SetFontChoice(value));
    };
    var options = [
      SettingOption(FontChoice.ptSans, 'Font', null, 'PT Sans', dispatch),
      SettingOption(FontChoice.productSans, 'Font', null, 'Product Sans', dispatch),
    ];
    var selected = options.indexWhere((o) => o.value == widget.currentFont);
    return _SettingControl(options: options, selected: selected);
  }

  Widget verticalTextAlignControl() {
    var dispatch = (value) {
      Themer().setVerticalContentAlign(value);
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

  Widget autoDeleteDoneItemsControl() {
    return _SettingSwitch(
      current: widget.autoDeleteDoneItems,
      title: 'Auto Delete Done Items',
      desc: 'Automatically delete items from list when they are marked as done',
      onTap: (value) {
        Themer().setAutoDeleteDoneItems(value);
        widget.dispatch(SetAutoDeleteDoneItems(value));
      },
    );
  }

  Widget moveDoneItemsToTheBottom() {
    return _SettingSwitch(
      current: widget.moveDoneItemsToTheBottom,
      title: 'Move Done Items to the Bottom',
      desc: 'Automatically move done items to the bottom of the list when they are marked as done.',
      onTap: (value) {
        Themer().setMoveDoneItemsToTheBottom(value);
        widget.dispatch(SetMoveDoneItemsToTheBottom(value));
      },
    );
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

  _SettingControl({Key key, this.options, this.selected}) : super(key: key);

  SettingOption _selectedOption() => options[selected];

  @override
  Widget build(BuildContext context) {
    var selectedOption = _selectedOption();
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => _showBottomSheet(context),
      child: Container(
        padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
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
        margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(option.name, textAlign: TextAlign.center, style: TextStyle(color: Themer().anchorColor())),
            ),
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
              if (selectedOption.desc != null)
                Container(
                  margin: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 15.0),
                  child: Text(selectedOption.desc, textAlign: TextAlign.center),
                ),
              Container(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) => _option(context, options[index]),
                  separatorBuilder: (context, index) => Divider(height: 1.0, color: Themer().separator()),
                  itemCount: options.length,
                ),
              ),
              Container(height: 20.0),
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Container(child: Text('Cancel', style: TextStyle(color: Themer().hintTextColor())), padding: EdgeInsets.only(bottom: 10.0)),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SettingSwitch extends StatelessWidget {
  final bool current;
  final String title;
  final String desc;
  final Function onTap;

  _SettingSwitch({Key key, this.current, this.title, this.desc, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 22.0, fontWeight: Themer().fontBold())),
                Text(desc),
              ],
            ),
          ),
          CupertinoSwitch(
            value: current,
            activeColor: Color(0xFF64D2FF),
            onChanged: (bool value) {
              onTap(value);
            },
          )
        ],
      ),
    );
  }
}

class _Props {
  final DarkModeChoice darkModeChoice;
  final ThemeChoice currentTheme;
  final FontChoice currentFont;
  final ContentAlign currentAlign;
  final VerticalContentAlign currentVerticalAlign;
  final bool autoDeleteDoneItems;
  final bool moveDoneItemsToTheBottom;
  final Function dispatch;

  _Props(
      {this.darkModeChoice,
      this.currentTheme,
      this.currentFont,
      this.currentAlign,
      this.currentVerticalAlign,
      this.autoDeleteDoneItems,
      this.moveDoneItemsToTheBottom,
      this.dispatch});

  static _Props fromStore(Store<AppState> store) {
    return _Props(
      dispatch: (action) => store.dispatch(action),
      darkModeChoice: store.state.settings.darkModeChoice,
      currentTheme: ThemeChoice.blue,
      currentFont: store.state.settings.fontChoice,
      currentAlign: ContentAlign.left,
      currentVerticalAlign: store.state.settings.verticalContentAlign,
      autoDeleteDoneItems: store.state.settings.autoDeleteDoneItems,
      moveDoneItemsToTheBottom: store.state.settings.moveDoneItemsToTheBottom,
    );
  }
}
