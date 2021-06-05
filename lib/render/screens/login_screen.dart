import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minimalist/render/components/common/components.dart';
import 'package:minimalist/render/presentation/themer.dart';
import 'package:minimalist/render/screens/login_success_screen.dart';
import 'package:minimalist/render/screens/privacy_screen.dart';
import 'package:minimalist/render/screens/resolve_conflict_screen.dart';
import 'package:minimalist/render/screens/settings_screen.dart';
import 'package:minimalist/render/screens/terms_screen.dart';
import 'package:minimalist/services/auth_service.dart';
import 'package:minimalist/services/firestore_service.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:minimalist/state/app/app_state.dart';
import 'package:redux/redux.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
      converter: (Store<AppState> store) => _Props.fromStore(store),
      builder: (BuildContext context, _Props props) {
        return _Presenter(
          appstate: props.appstate,
        );
      },
    );
  }
}

class _Presenter extends StatefulWidget {
  final AppState appstate;

  const _Presenter({Key key, this.appstate}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0, 0.6, 1.0],
                    colors: [Color(0xFF1ED1FC), Color(0xFF130CB7), Color(0xFF130CB7)],
                  ),
                ),
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    backArrow(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: sheet(context),
                    )
                  ],
                ),
              );
            },
          ),
        ),
        if (_loading) LoadingOverlay(),
      ],
    );
  }

  Widget backArrow() {
    return Align(
      alignment: Alignment.topLeft,
      child: SafeArea(
        child: Container(
          width: 100.0,
          height: 100.0,
          child: BackArrow(color: Colors.white),
        ),
      ),
    );
  }

  Widget sheet(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        color: Themer().paper(),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(height: 50.0),
          Image.asset('assets/images/icon.png', height: 150.0),
          Container(height: 10.0),
          Text(
            'minimalist',
            style: TextStyle(fontSize: 50.0, fontWeight: Themer().fontBold(), color: Color(0xFF0D47A1)),
            textAlign: TextAlign.center,
          ),
          Container(height: 20.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.0),
            child: Text(
              'Backup your data to the cloud with just one click. Your data will be automatically securely synced to the cloud.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Themer().hintTextColor())
            ),
          ),
          Container(height: 40.0),
          googleButton(context),
          Container(height: 40.0),
          terms(context),
          Container(height: 100.0),
        ],
      ),
    );
  }

  Widget googleButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.0),
      child: HollowButton(
        borderColor: Color(0x440D47A1),
        children: <Widget>[
          Image.asset('assets/images/login-google.png', height: 40.0),
          Container(width: 20.0),
          Text('Login with Google', style: TextStyle(fontSize: 25.0, color: Color(0xFF0D47A1))),
          Container(width: 30.0),
        ],
        onTap: () => loginWithGoogle(context),
      ),
    );
  }

  loginWithGoogle(BuildContext context) async {
    this.setState(() => _loading = true);
    var user = await AuthService().loginWithGoogle();
    if (user == null) {
      snackError(context);
    } else {
      var cloudData = await FirestoreService().getState(user);
      if (cloudData != null) {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (_) => ResolveConflictScreen(userData: cloudData)));
      } else {
        FirestoreService().saveState(widget.appstate.toJson());
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen()));
        Navigator.push(context, MaterialPageRoute(builder: (_) => LoginSuccessScreen()));
      }
    }
  }

  Widget terms(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('By continuing you agree to our ', style: TextStyle(color: Themer().hintTextColor())),
        Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TermsScreen())),
            child: Text('Terms & Conditions', style: TextStyle(decoration: TextDecoration.underline, color: Themer().hintTextColor())),
          ),
          Text(' and ', style: TextStyle(color: Themer().hintTextColor())),
          InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PrivacyScreen())),
            child: Text('Privacy Policy', style: TextStyle(decoration: TextDecoration.underline, color: Themer().hintTextColor())),
          ),
          Text('.', style: TextStyle(color: Themer().hintTextColor()))
        ])
      ],
    );
  }
}

class _Props {
  final AppState appstate;

  _Props({
    this.appstate,
  });

  static fromStore(Store<AppState> store) {
    return _Props(
      appstate: store.state,
    );
  }
}
